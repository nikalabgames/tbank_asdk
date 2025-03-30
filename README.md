# T-Bank Acquiring SDK for iOS

Acquiring SDK позволяет интегрировать [Интернет-Эквайринг Т-Кассы][acquiring] в мобильные приложения для платформы iOS.

<!-- Table of contents mark -->

[TOC]

## Требования

Для работы T-Bank Acquiring SDK необходимо:

- Поддержка `iOS 13.0` и выше
- Версия **Xcode 15.1** `Swift - 5.9.2`

## Модули

<details>
<summary>Диаграмма</summary>

```mermaid
graph TD;
  TinkoffASDKCore-->TinkoffASDKUI;
```

</details>

Acquiring SDK состоит из трех модулей, которые можно подключать в ваше приложение по необходимости:

- **TinkoffASDKCore** - низкоуровневый модуль, используемый для формирования и совершения сетевых запросов к [API эквайринга][server-api], а также для конфигурации безопасной передачи данных в сети
- **TinkoffASDKUI** - содержит всю необходимую логику для интеграции различных пользовательских сценариев по приему платежей в ваше приложение. В большинстве ситуаций вам достаточно подключить только его

## Подключение

**Cocoapods**

Для подключения с помощью `Cocoapods` добавьте в файл `Podfile` необходимые для ваших целей зависимости:

```ruby
pod 'TASDKCore'
pod 'TASDKUI'
```

Для работы импорт фреймворков таков:

```swift
TASDKCore - import TinkoffASDKCore
TASDKUI - import TinkoffASDKUI
```

**Swift Package Manager**

<details>
<summary>Через Xcode</summary>

- File -> Add packages -> `https://opensource.tbank.ru/mobile-tech/asdk-ios.git`

Выберите нужные модули:

![spm-products][img-spm-products]

- Выбирайте **Core** модуль, если вы используете свой UI
- Выбирайте **UI** если используете UI от asdk

</details>

<details>
<summary>Используя Package.swift файл</summary>

- Чтобы интегрировать AcquiringSdk в ваш проект используя `Package.swift` нужно указать зависимость:

```swift
dependencies: [
  // 1 Способ добавить пакедж указав хэш конкретного коммита
  .package(url: "https://opensource.tbank.ru/mobile-tech/asdk-ios.git", .revision("commit-hash"))
  // 2 Способ добавить пакедж указав ветку
  .package(url: "https://opensource.tbank.ru/mobile-tech/asdk-ios.git", .branch("master"),
]
```

</details>

## Подготовка к работе

**Для начала работы с SDK вам понадобятся:**

- `TerminalKey` - Идентификатор терминала Продавца
- `PublicKey` – публичный ключ, используемый для шифрования данных

> - Данные выдаются в личном кабинете после подключения [Интернет-Эквайрингу][acquiring]
> - [Подробнее о настройке Личного кабинета](./Docs/PersonalAccountSettings.md)
> - [Тестовые карты для ASDK][api-test-cards]

**Инициализация SDK**
Для инициализации SDK прежде всего необходимо создать конфигурацию, а после передать ее в `init`. Ниже приведен пример с минимально необходимыми параметрами:

<details>
<summary>Дополнительные параметры в AcquiringSdkConfiguration</summary>

- **logger: ILogger?** - Интерфейс для логирования работы сетевого слоя. Вы можете передать сюда реализацию по умолчанию - `Logger`, форматирующую и выводящую данные в консоль
- **language** - язык, на котором сервер будет присылать тексты ошибок. Эти сообщения никогда не отображаются пользователю и используются исключительно для отладки
- **requestsTimeoutInterval: TimeInterval** - таймаут сетевых запросов. Значение по-умолчанию - 40 секунд
- **tokenProvider**: **ITokenProvider?** - протокол, предоставляющий токен для подписи запроса в API эквайринга. Необходим только для терминалов, с включенной проверкой токена. [Подробнее](#подпись-запросов-с-помощью-токена)
- **urlSessionAuthChallengeService: IURLSessionAuthChallengeService?** - Интерфейс для запроса данных и способах аутентификации `URLSession`. Не рекомендуется бездумно передавать сюда что-либо, поскольку используемая по-умолчанию реализация обеспечит корректное взаимодействие с сервером, в случае перехода на SSL/TLC сертификаты `Минцифры`. [Подробнее](#обеспечение-работы-с-ssltlc-сертификатами-минцифры)

</details>

<details>
<summary>Дополнительные параметры в UISDKConfiguration</summary>

- **webViewAuthChallengeService: IWebViewAuthChallengeService?** - Интерфейс для запроса данных и способах аутентификации `WKWebView`. Не рекомендуется бездумно передавать сюда что-либо, поскольку используемая по-умолчанию реализация обеспечит корректное взаимодействие с сервером, в случае перехода на SSL/TLC сертификаты `Минцифры`. [Подробнее](#обеспечение-работы-с-ssltlc-сертификатами-минцифры)
- **paymentStatusRetriesCount: Int** - Отвечает за максимальное количество запросов на обновление статуса платежа. Используется для того, чтобы получить конечный статус после того, как пользователь совершил оплату. Можно установить любое положительное значение. По умолчанию используется 10 попыток получить конечный статус с интервалом в 3 секунда
- **addCardCheckType: PaymentCardCheckType** - Тип проверки при привязке карты. По умолчанию - `.no`. [Подробнее][api-check-type]
- **showPaymentNotifications** - Показывать ли шторки уведомлений для оплаты - успех/ошибка

</details>

```swift
import TinkoffASDKCore
import TinkoffASDKUI

let credential = AcquiringSdkCredential(
    terminalKey: "TERMINAL_KEY",
    publicKey: "PUBLIC_KEY"
)

let coreSDKConfiguration = AcquiringSdkConfiguration(
    credential: credential,
    server: .prod // Используемое окружение
)

let uiSDKConfiguration = UISDKConfiguration()

do {
    let sdk = try AcquiringUISDK(
        coreSDKConfiguration: coreSDKConfiguration,
        uiSDKConfiguration: uiSDKConfiguration
    )
} catch {
    // Ошибка может возникнуть при некорректном параметре `publicKey`
    assertionFailure("\(error)")
}
```

## Совершение платежей

<img src="./Docs/images/pay-card-scheme.png"/>

<details>
<summary>Описание шагов</summary>

|Шаг|Инициатор|Описание|
|---|---------|--------|
|1|Пользователь|Переходит к оплате|
|2|Ваше приложение|Собирает необходимые параметры для вызова метода [/v2/Init](https://www.tbank.ru/kassa/dev/payments/#tag/Standartnyj-platezh/operation/Init) и формирования токена|
|3|Ваш сервер|Генерирует токен по описанному [алгоритму](https://opensource.tbank.ru/mobile-tech/asdk-ios#%D0%BF%D0%BE%D0%B4%D0%BF%D0%B8%D1%81%D1%8C-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-%D1%82%D0%BE%D0%BA%D0%B5%D0%BD%D0%B0)|
|4|Ваш сервер|Отправляет запрос на создание платежа с помощью метода [/v2/Init](https://www.tbank.ru/kassa/dev/payments/#tag/Standartnyj-platezh/operation/Init)|
|5|Т-Банк|Создает платеж в системе банка|
|6|Т-Банк|Возвращает ответ о созданном платеже|
|7|Ваш сервер|Передаёт параметры о платеже в приложение для последующего формирования finishOptions|
|8|Ваше приложение|Передает полученный paymentId в ASDK для завершения платежа с помощью метода, который использует структуру FinishPaymentOptions|
|9|ASDK|Отображает платежную форму пользователю|
|10|Пользователь|Выбирает способ оплаты и вводит платежные данные|
|11|ASDK, Т-Банк|Выполняют выбранный покупателем flow оплаты|
|12|ASDK|Получает результат оплаты с помощью вызова PaymentResult|
|13|ASDK|Возвращает приложению один из трех возможных кейсов: успешный, неуспешный и если платеж отменен|
|14|Ваше приложение|Отправляет запрос на ваш сервер, чтобы дополнительно проверить статус операции напрямую у банка|
|15|Ваш сервер|Проверяет статус операции, путем вызова [/v2/GetState](https://www.tbank.ru/kassa/dev/payments/#tag/Standartnyj-platezh/operation/GetState)|
|16|Т-Банк|Возвращает статус транзакции|
|17|Ваш сервер|Возвращает статус в ваше приложение|
|18|Ваше приложение|Отображает результат оплаты пользователю|

</details>


- Всякое взаимодействие с различными пользовательскими сценариями оплаты происходит через единый фасад `AcquiringUISDK`.
- Пример его инициализации можно увидеть в [разделе выше](#подготовка-к-работе).
- В SDK реализованы как отдельные точки входа для каждого сценария оплаты, так и общая платежная форма, содержащая в себе несколько видов оплаты, доступных на данном терминале.

> Для прохождения тест-кейсов и совершения тестовых платежей воспользуйтесь [тестовыми картами][api-test-cards]

**Формирование данных об оплате PaymentFlow**

Для того, чтобы совершить платеж, необходимо создать объект `PaymentFlow` и передать его в соответствующую функцию `AcquiringUISDK`.

`PaymentFlow` представляет из себя `enum`, указывающий на конкретный вид проведения оплаты. Используется во всех сценариях оплаты в SDK:

```swift
/// Тип проведения оплаты
public enum PaymentFlow: Equatable {
    /// Оплата совершится с помощью вызова `v2/Init` в API эквайринга, на основе которого будет сформирован `paymentId`
    case full(paymentOptions: PaymentOptions)
    /// Используется в ситуациях, когда вызов `v2/Init` и формирование `paymentId` происходит на бекенде продавца
    case finish(paymentOptions: FinishPaymentOptions)
}
```

Подобное разделение позволяет использовать SDK как в приложениях, где логика по формированию платежных данных реализована на клиенте, так и в приложениях, где эта работа происходит на сервере.

- `.full` - предлагается использовать в большинстве случаев оплаты.
  - Инициализацию [/Init][api-init] и подтверждение [/Finish][api-finish] платежа совершает asdk.
- `.finish` - только если вы хотите делать инициализацию платежа [/Init][api-init] сами например на своем сервере.
  - Сдк совершает только [/Finish][api-finish] подтверждение платежа.
  - Потребуется более глубокое изучение документации API метода Init, чтобы правильно сформировать платеж.

Ниже рассмотрим формирование параметров для каждого кейса:

<details>
<summary>Full payment - PaymentFlow.full</summary>

Здесь клиентское приложение предоставляет все необходимы данные, участвующие в проведении платежа. SDK самостоятельно инициирует и завершает платеж.

Для создания `PaymentFlow` с типом `.full`, необходимо передать параметры платежа с помощью `PaymentOptions`:

```swift
let receipt: Receipt
let shops: [Shop]
let receipts: [Receipt]

let orderOptions = OrderOptions(
    /// Идентификатор заказа в системе продавца
    orderId: "ORDER_ID",
    // Полная сумма заказа в копейках
    amount: 100000,
    // Краткое описание заказа
    description: "DESCRIPTION",
    // Данные чека
    receipt: receipt,
    // Данные маркетплейса. Используется для разбивки платежа по партнерам
    shops: shops,
    // Чеки для каждого объекта в `shops`.
    // В каждом чеке необходимо указывать `Receipt.shopCode` == `Shop.shopCode`
    receipts: receipts,
    // Сохранить платеж в качестве родительского
    savingAsParentPayment: false
)

let customerOptions = CustomerOptions(
    // Идентификатор покупателя в системе продавца.
    // С помощью него можно привязать карту покупателя к терминалу после успешного платежа
    customerKey: "CUSTOMER_KEY",
    // Email покупателя
    email: "EMAIL"
)

// Используется для редиректа в приложение после успешного или неуспешного совершения оплаты с помощью `T-Pay`
// В иных сценариях передавать эти данные нет необходимости
let paymentCallbackURL = PaymentCallbackURL(
    successURL: "SUCCESS_URL",
    failureURL: "FAIL_URL"
)
```

> :speech_balloon:
> Если параметр `paymentCallbackURL` передан – используются его значения.
> В противном случае – используются стандартные значения из настроек терминала.
> Для установки стандартных **SuccessURL** & **FailURL** обратитесь к персональному менеджеру через нашу поддержку.

```swift
// Словарь, содержащий дополнительные параметры в виде `[Key: Value]`, которые можно передать по необходимости
let paymentData = ["someKey": "someValue"]

let paymentOptions = PaymentOptions(
    orderOptions: orderOptions,
    customerOptions: customerOptions,
    paymentCallbackURL: paymentCallbackURL,
    paymentData: paymentData
)

let paymentFlow: PaymentFlow = .full(paymentOptions: paymentOptions)
```

Все эти данные могут использоваться для инициации платежа с помощью метода `v2/Init`. Подробнее можно ознакомиться [тут][api-init]

</details>

<details>
<summary>Finish payment - PaymentFlow.finish</summary>

Здесь клиентское приложение предоставляет минимальный набор данных для завершения платежа при условии, что платеж был инициирован ранее за пределами SDK:

```swift
// Идентификатор платежа, полученный при вызове `v2/Init`
let paymentId: String

let finishOptions = FinishPaymentOptions(
    paymentId: paymentId,
    amount: 100000,
    orderId: "ORDER_ID",
    customerOptions: customerOptions
)

let paymentFlow: PaymentFlow = .finish(paymentOptions: finishOptions)
```

</details>

**Получение результата оплаты PaymentResult**

При всех сценариях платежей в `Acquiring SDK` результат выполненной работы возвращается с помощью замыкания, вызываемого сразу после закрытия экрана оплаты:

```swift
/// Замыкание с результатом, вызываемое после закрытия экрана оплаты
public typealias PaymentResultCompletion = (PaymentResult) -> Void
```

Здесь `PaymentResult` представляет из себя `enum` с тремя возможными кейсами:

```swift
/// Результат платежа
public enum PaymentResult {
    /// Успешное завершение оплаты
    case succeeded(PaymentInfo)
    /// Произошла ошибка на этапе оплаты
    case failed(Error)
    /// Оплата отменена пользователем
    case cancelled(PaymentInfo? = nil)
}
```

В `PaymentInfo` находится дополнительная информация о совершенной оплате:

```swift
/// Информация о проведенном платеже
public struct PaymentInfo {
    /// Идентификатор платежа
    public let paymentId: String
    /// Идентификатор заказа в системе продавца
    public let orderId: String
    /// Сумма заказа в копейках
    public let amount: Int64
    // Последний детальный статус о платеже
    public let paymentStatus: AcquiringStatus
}
```

`PaymentInfo` так же может располагаться и в `cancelled` в тех ситуациях, когда SDK начал процесс оплаты, но пользователь закрыл экран, не дождавшись завершения работы.

### Оплата с помощью платежной формы

В SDK реализована общая платежная форма. В ней отображаются несколько способов оплаты, доступных для данного терминала, и пользователь может выбрать любой из них:

- **Оплата по новой карте**
- **Оплата по сохраненной карте**
- **T-Pay**
- **СБП**

> Платежная форма запрашивает доступные методы оплаты для терминала. На их основе отрисовывает способы оплаты.
> Управлять методами оплаты можно через Личный Кабинет или поддержку.

<table>
<tr>
    <th>Платежная форма с T-Pay, Карта, СБП</th>
    <th>Платежная форма без сохранненых карт</th>
    <th>Платежная форма с сохраннеными картами</th>
</tr>
<tr align="center">
    <td><img height="500" src="./Docs/images/flows/pf-all-methods.webp" alt="Платежная форма со всеми способами оплаты" title="Платежная форма"/></td>
    <td><img height="500" src="./Docs/images/flows/pf-new-card.webp" alt="Платежная форма - нет карт для оплаты" title="Платежная форма - нет карт для оплаты"/></td>
    <td><img height="500" src="./Docs/images/flows/pf-saved-card.webp" alt="Платежная форма с привязанными картами" title="Платежная форма с привязанными картами"/></td>
</tr>
</table>

> :warning: **Для корректной работы T-Pay и СБП необходимо дополнительно сконфигурировать ваш проект, поэтому ознакомьтесь с описанием этих способов оплаты ниже**.

Для отображения платежной формы необходимо вызвать соответствующую функцию в `AcquiringUISDK`:

```swift
/// Отображает основную платежную форму с различными способами оплаты
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого отобразится платежная форма
///   - paymentFlow: Содержит тип платежа и параметры оплаты
///   - configuration: Конфигурация платежной формы
///   - cardScannerDelegate: Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
///   - completion: Замыкание с результатом, вызываемое после закрытия экрана оплаты
public func presentMainForm(
    on presentingViewController: UIViewController,
    paymentFlow: PaymentFlow,
    configuration: MainFormUIConfiguration,
    cardScannerDelegate: ICardScannerDelegate? = nil,
    completion: PaymentResultCompletion? = nil
)
```

С помощью объекта `MainFormConfiguration` можно задать дополнительную конфигурацию платежной формы:

```swift
/// Конфигурация главной платежной формы
///
/// На основе этих данный будет формироваться отображение UI платежной формы с разными способами оплаты
public struct MainFormUIConfiguration {
  /// Очень краткое описание заказа, отображаемое пользователю
  public let orderDescription: String?
}
```

Также вы можете передать, ссылку на реализацию [ICardScannerDelegate](#сканирование-карт), с помощью которой пользователь сможет отсканировать свою банковскую карту.

Платежная форма закроется по завершении оплаты и вернет в `completion` объект `PaymentResult`

### Отдельный сценарий оплаты через T-Pay

> **Внимание!**
> Чтобы покупатель имел возможность оплатить заказ с помощью T-Pay необходимо при вызове [/v2/Init](https://www.tbank.ru/kassa/dev/payments/#tag/Standartnyj-platezh) **всегда** передавать параметры устройства в DATA.

Прежде всего для корректной работы `T-Pay` в вашем приложении необходимо добавить в `Info.plist` в массив по ключу `LSApplicationQueriesSchemes` значение `bank100000000004`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>bank100000000004</string>
</array>
```

Благодаря этому SDK сможет корректно определить наличие приложения `Т-Банк` на устройстве пользователя.

Для отображения экрана оплаты `T-Pay` необходимо вызвать соответствующую функцию в `AcquiringUISDK`:

```swift
/// Отображает экран оплаты `TinkoffPay`
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран оплаты `TinkoffPay`
///   - paymentFlow: Содержит тип платежа и параметры оплаты
///   - completion: Замыкание с результатом оплаты, вызываемое после закрытия экрана `TinkoffPay`
public func presentTinkoffPay(
    on presentingViewController: UIViewController,
    paymentFlow: PaymentFlow,
    completion: PaymentResultCompletion? = nil
)
```

При наличии у пользователя установленного приложения `Т-Банк` SDK совершит переход в него.

Экран закроется по завершении оплаты и вернет в `completion` объект `PaymentResult`

Оплата с помощью `T-Pay` также доступа с [платежной формы](#оплата-с-помощью-платежной-формы)

### Отдельный сценарий оплаты через СБП

<table>
<tr>
    <th>Cписок банков на устройстве</th>
    <th>Cписок всех банков</th>
</tr>
<tr align="center">
    <td><img height="530" src="Docs/images/flows/sbp.webp"/></td>
    <td><img height="530" src="/Docs/images/flows/sbp_banks.webp"/></td>
</tr>
</table>

В SDK доступны несколько видов оплаты с помощью `СБП`. В данном разделе описан сценарий, при котором пользователю отображается список банков, поддерживающих оплату `СБП`. При выборе конкретного банка из списка произойдет переход в соответствующее банковское приложение.

Для получения списка доступных банков SDK отправляет запрос в [НСПК][nspk-sbp] и получает в ответ `JSON` со списком URL-схем банковских приложений:

```json
{
  "version": "1.0",
  "dictionary": [
    {
      "bankName": "Сбербанк",
      "logoURL": "https://qr.nspk.ru/proxyapp/logo/bank100000000111.webp",
      "schema": "bank100000000111",
      "package_name": "ru.sberbankmobile"
    },
    {
      "bankName": "Т-Банк",
      "logoURL": "https://qr.nspk.ru/proxyapp/logo/bank100000000004.webp",
      "schema": "bank100000000004",
      "package_name": "com.idamob.tinkoff.android"
    },
    {
      "bankName": "Банк ВТБ",
      "logoURL": "https://qr.nspk.ru/proxyapp/logo/bank100000000005.webp",
      "schema": "bank110000000005",
      "package_name": "ru.vtb24.mobilebanking.android"
    }
  ]
}
```

Поскольку список содержит более сотни банков, для удобства SDK отображает в первую очередь именно те, что достоверно установлены на устройстве пользователя. Для этого этого мы формируем `URL` на основе значения в `schema` и вызываем системную функцию [canOpenURL(:)][apple-can-open-url].

Согласно [документации][apple-can-open-url-discussion], данный метод возвращает корректный ответ только при внесении схемы в массив с ключом `LSApplicationQueriesSchemes` в `Info.plist`. Также там сказано, что в этот список вы можете внести не более 50 схем.

Именно поэтому для корректного отображения списка банков вам необходимо выбрать наиболее приоритетные для вас банковские приложения, которые в первую очередь будут отображаться на экране банков СБП, и внести их в `Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>bank100000000111</string>
  <string>bank100000000004</string>
  <string>bank110000000005</string>
  <string>bank100000000008</string>
</array>
```

> :warning: **В связи с блокировками банковских приложений в AppStore схемы могут меняться. Вам необходимо периодически сверяться со [списком][nspk-sbp] и актуализировать Info.plist своего приложения**

Для отображения экрана со списком банков `СБП` вызовите в `AcquiringUISDK` функцию:

```swift
/// Отображает экран со списком приложений банков, с помощью которых можно провести оплату через `Систему быстрых платежей`
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран со списком банков
///   - paymentFlow: Содержит тип платежа и параметры оплаты
///   - completion: Замыкание с результатом оплаты, вызываемое после закрытия экрана оплаты `СБП`
public func presentSBPBanksList(
    on presentingViewController: UIViewController,
    paymentFlow: PaymentFlow,
    completion: PaymentResultCompletion? = nil
)
```

Экран закроется по завершении оплаты и вернет в `completion` объект `PaymentResult`.

Данный вид оплаты также доступен с [платежной формы](#оплата-с-помощью-платежной-формы)

### Генерация QR-кода для оплаты через СБП

<p align="center">
    <img src="./Docs/images/flows/sbp_qr.webp" width="30%" height="30%">
<p/>

В SDK есть возможность отобразить `QR-код` с ссылкой для совершения оплаты при помощи `Системы быстрых платежей`. После сканирования кода на устройстве пользователя откроется форма оплаты в банковском приложении. И здесь стоит выделить `2 вида QR`:

- **QR-Static** - Платежная ссылка СБП, сформированная для многократного использования для оплаты товара или услуг
- **QR-Dynamic** - Платежная ссылка СБП, сформированная для однократного использования для оплаты товара или услуг

**Генерация статического (многоразового) QR-кода СПБ для оплаты**

Для генерации `статического QR-кода` используется следующая функцию в `AcquiringUISDK`:

```swift
/// Отображает экран с многоразовым `QR-кодом`, отсканировав который, пользователь сможет провести оплату с помощью `Системы быстрых платежей`
///
/// При данном типе оплаты SDK никак не отслеживает статус платежа
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран с `QR-кодом`
///   - completion: Замыкание, вызываемое при закрытии экрана с `QR-кодом`
public func presentStaticSBPQR(
    on presentingViewController: UIViewController,
    completion: (() -> Void)? = nil
)
```

При закрытии экрана вызовется `completion` без каких-либо данных

**Генерация динамического (одноразового) QR-кода СПБ для оплаты**

Для генерации `динамического QR-кода` используется следующая функцию в `AcquiringUISDK`:

```swift
/// Отображает экран с одноразовым `QR-кодом`, отсканировав который, пользователь сможет провести оплату  с помощью `Системы быстрых платежей`
///
/// При данном типе оплаты сумма и информация о платеже фиксируется, и SDK способен получить и обработать статус платежа
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран с `QR-кодом`
///   - paymentFlow: Содержит тип платежа и параметры оплаты
///   - completion: Замыкание с результатом оплаты, вызываемое после закрытия экрана с `QR-кодом`
public func presentDynamicSBPQR(
    on presentingViewController: UIViewController,
    paymentFlow: PaymentFlow,
    completion: @escaping PaymentResultCompletion
)
```

Экран закроется по завершении оплаты и вернет в `completion` объект `PaymentResult`

## Управление банковскими картами

Помимо платежей в SDK предусмотрены точки входа для экранов управление картами

### Список сохраненных карт

<details>
<summary>Скриншот</summary>
<img height="530" src="Docs/images/flows/cards_list.webp"/>
</details>

Для открытия экрана со списком сохраненных карт достаточно вызвать в `AcquiringUISDK` функцию:

```swift
/// Отображает экран со списком карт
///
/// На этом экране пользователь может ознакомиться со списком привязанных карт, удалить или добавить новую карту
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран добавления карты
///   - customerKey: Идентификатор покупателя в системе Продавца, к которому будет привязана карта
///   - cardScannerDelegate: Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
///   - completion: Событие, сообщающее о закрытии экрана 'Список сохраненных карт'
public func presentCardList(
    on presentingViewController: UIViewController,
    customerKey: String,
    cardScannerDelegate: ICardScannerDelegate? = nil
)
```

Также вы можете передать, ссылку на реализацию [ICardScannerDelegate](#сканирование-карт), с помощью которой пользователь сможет отсканировать свою банковскую карту.

### Привязка новой карты

<details>
<summary>Скриншот</summary>
<img height="530" src="Docs/images/flows/add_card.webp"/>
</details>

Возможность привязать новую карту доступна пользователю с экрана со списком карт, но при необходимости вы можете самостоятельно встроить ее в свое приложение.
Для этого необходимо вызвать следующую функцию в `AcquringUISDK`:

```swift
/// Отображает экран привязки новой карты
/// - Parameters:
///   - presentingViewController: `UIViewController`, поверх которого будет отображен экран привязки карты
///   - customerKey: Идентификатор покупателя в системе Продавца, к которому будет привязана карта
///   - cardScannerDelegate: Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
///   - completion: Замыкание с результатом привязки карты, которое будет вызвано на главном потоке после закрытия экрана
public func presentAddCard(
    on presentingViewController: UIViewController,
    customerKey: String,
    cardScannerDelegate: ICardScannerDelegate? = nil,
    completion: ((AddCardResult) -> Void)? = nil
)
```

Также вы можете передать, ссылку на реализацию [ICardScannerDelegate](#сканирование-карт), с помощью которой пользователь сможет отсканировать свою банковскую карту.

По завершении привязки карты экран закроется, вернув `AddCardResult` в `completion`:

```swift
/// Результат привязки карты
public enum AddCardResult {
    /// Привязка карты произошла успешно.
    /// В этом случае возвращается модель с подробной информацией о карте
    case succeded(PaymentCard)
    /// В процессе привязки карты произошла ошибка
    case failed(Error)
    /// Пользователь отменил привязку новой карты
    case cancelled
}
```

Объект `PaymentCard` будет содержать всю доступную информацию о привязанной карте:

- **pan: String** - Маскированный номер карты, например `430000******0777`
- **cardId: String** - Идентификатор карты в системе банка
- **expDate: String?** - Срок годности карты в формате `MMYY`, например `1212`
- **status: PaymentCardStatus** - Текущий статус карты. В случае успешной привязки - `active`
- **parentPaymentId: Int64** - Идентификатор последнего платежа, зарегистрированного как родительский

## Надежность и безопасность

### Обеспечение работы с SSL/TLC сертификатами Минцифры

На случай отзыва глобальных сертификатов в SDK предусмотрена возможность перехода на сертификаты, выданные `Министерством цифрового развития`.
**Крайне важно** адаптировать свой проект по инструкции ниже. В противном случае ваше приложение не сможет принимать оплату в случае внезапного отзыва сертификатов.

**Настройка**

В файл `Info.plist` добавьте опцию `Allow Arbitrary Loads` для конкретных доменов, путем проставления списка доменов из примера ниже. Дополнительно укажите свойство `Allow Arbitrary Loads in Web Content = true` для корректной работы `WebView`.

<details>
<summary>Пример реализации в Info.plist: </summary>

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>qr.nspk.ru</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
        <key>stage.dev-tcsgroup</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
        <key>rest-api-test.tinkoff.ru</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
        <key>securepay.tinkoff.ru</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```
</details>

### Подпись запросов с помощью токена

Токен - это строка которая используется для подписи запроса, в которой зашифрованы данные запроса с помощью пароля терминала.

> **Внимание!**
>
> По умолчанию проверка токенов на терминале отключена, рекомендуем включить проверку подписи запросов через ЛК.

Если ваш терминал поддерживает валидацию токена, отправляемого в запросах к API эквайринга, то необходимо реализовать протокол `ITokenProvider` и передать его в `AcquiringSdkConfiguration`:

```swift
func provideToken(
  forRequestParameters parameters: [String: String], // Параметры, участвующие в генерации токена
  completion: @escaping (Result<String, Error>) -> Void // Замыкание, которое необходимо вызвать, передав результат генерации токена
)
```

Для генерации токена необходимо:

- Добавить пароль от терминала в словарь с ключом `Password`
- Отсортировать пары ключ-значение по ключам в алфавитном порядке
- Конкатенировать значения всех пар
- Для полученной строки вычислить хэш SHA-256

<details>
<summary>Пример</summary>

> :warning: **Реализация ниже приведена исключительно в качестве примера**. В целях безопасности не стоит хранить и как бы то ни было взаимодействовать с паролем от терминала в коде мобильного приложения. Наиболее подходящий сценарий - передавать полученные параметры на сервер, где будет происходить генерация токена на основе параметров и пароля

[Подробнее о подписи запроса](https://www.tbank.ru/kassa/dev/payments/#section/Token)

## Дополнительные возможности

### SwiftUI интеграция
- Для использования АСДК внутри **SwiftUI** контекста, используйте `sui` свойство объекта `AcquiringUISDK` - оно дублирует все методы `AcquiringUISDK` см. [подготовка к работе](#подготовка-к-работе).
- После вызова метода через `sui` в ответ получаете SwiftUI view `AsdkSuiView`.
- Далее для презентации полученного view **используйте** метод `.popover()`.

Пример:
```swift
import SwiftUI
import TinkoffASDKUI

struct ExampleView: View {
    let uiSDK: AcquiringUISDK
    @State private var isShowingMainForm = false

    var body: some View {
        Button("Оплатить") {
            isShowingMainForm = true
        }
        .popover(isPresented: $isShowingMainForm) {
            // Вернем view для платежной формы
            uiSDK.sui.mainFormView(...)
        }
    }
}
```

### Темная тема и локализация

- **Локализация** - присутсвует для следующих языков: русский, английский. Обратите внимание чтобы локализация работала, в `Xcode -> Project -> Info -> Localizations` должны присутствовать English, Russian опции, если их нет добавьте.
- **Темная тема** - в asdk реализована:

<details>
<summary>Скриншоты темной темы</summary>
<p align="center">
    <img src="./Docs/images/flows/pf-dark.webp" height="530" title="Пример темной темы на платежной форме">
    <img src="./Docs/images/flows/pf-new-card-dark.webp" height="530" title="Пример темной темы на платежной форме">
    <img src="./Docs/images/flows/pf-saved-card-dark.webp" height="530" title="Пример темной темы на платежной форме">
<p/>
</details>

### Проведение платежей без UI ASDK

Создает новый `IPaymentController`, с помощью которого можно совершить оплату с прохождением проверки `3DS`, используя свой `UI`.

```swift
public func paymentController() -> IPaymentController {
  paymentControllerAssembly.paymentController()
}
```

На данный момент в `IPaymentController` отсутствует оплата через:

- T-Pay
- СБП

### Работа с картами без UI ASDK

Создает новый `ICardsController`, с помощью которого можно получить список активных карт, удалить и привязать новую карту с прохождением проверки 3DS, используя свой `UI`.

```swift
/// - Parameter customerKey: Идентификатор покупателя в системе продавца
/// - Returns: ICardsController
public func cardsController(customerKey: String) -> ICardsController {
  cardsControllerAssembly.cardsController(customerKey: customerKey)
}
```

### Сканирование карт

<p align="center">
    <img src="./Docs/images/flows/card_scanner_button.webp" width="30%" height="30%">
<p/>

При запуске всех пользовательских сценариев, где может присутствовать поле ввода карточных данных, у вас есть возможность передать ссылку на реализацию протокола `ICardScannerDelegate`:

```swift
/// Замыкание, в которое необходимо передать карточные данные по завершении сканирования
public typealias CardScannerCompletion = (_ cardNumber: String?, _ expiration: String?, _ cvc: String?) -> Void

/// Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
public protocol ICardScannerDelegate: AnyObject {
    /// Уведомляет о нажатии пользователем на кнопку сканера при вводе карточных данных
    ///
    /// Объект, реализующий данный протокол, должен отобразить экран со сканером.
    /// После завершения сканирования необходимо передать полученные карточные данные в `completion`
    /// - Parameters:
    ///   - viewController:`UIViewController`, поверх которого необходимо отобразить экран со сканером
    ///   - completion: Замыкание, в которое необходимо передать карточные данные по завершении сканирования
    func cardScanButtonDidPressed(on viewController: UIViewController, completion: @escaping CardScannerCompletion)
}
```

В таком случае пользователю отобразиться иконка сканера, по нажатии на которую вы можете отловить событие `cardScanButtonDidPressed` и отобразить экран сканера.

### Логирование запросов

Чтобы получать логи от asdk требуется передать объект `Logger()` в `AcquiringSdkConfiguration` в поле `logger`.

- **logger: ILogger?** - Интерфейс для логирования работы сетевого слоя.
- **Logger** - стандартная реализация - форматирует и выводит данные в консоль.

```swift
import TinkoffASDKCore

let acquiringSDKConfiguration = AcquiringSdkConfiguration(
  credential: ..,
  server: .prod,
  logger: Logger(), // Передали стандартный логгер
  )
```

Вы также можете сами реализовать свой логер опираясь на интерфейс `ILogger`

## Поддержка

- Если вы обнаружили ошибку, пожалуйста, сообщите о ней на почту acq_help@tbank.ru.
- Запросы на добавление новых функций и внесение изменений в функционал следует отправлять через менеджера или на acq_help@tbank.ru.
- По всем вопросам, связанным с сценарием платежей и их работой, обращайтесь на acq_help@tbank.ru.
- Документация [API методов][server-api].

[acquiring]: https://www.tinkoff.ru/kassa/dev/payments/index.html#section/Vvedenie/Podklyuchenie-ekvajringa
[acquiring-request-sign]: https://www.tinkoff.ru/kassa/dev/payments/#section/Podpis-zaprosa
[api-check-type]: https://www.tinkoff.ru/kassa/dev/payments/index.html#tag/Metody-raboty-s-kartami/paths/~1AddCard/post
[api-init]: https://www.tinkoff.ru/kassa/dev/payments/index.html#tag/Standartnyj-platyozh/paths/~1Init/post
[api-finish]: https://www.tinkoff.ru/kassa/dev/payments/index.html#tag/Standartnyj-platyozh/paths/~1FinishAuthorize/post
[api-charge]: https://www.tinkoff.ru/kassa/dev/payments/index.html#tag/Rekurrentnyj-platyozh/paths/~1Charge/post
[api-test-cards]: https://www.tinkoff.ru/kassa/dev/payments/index.html#tag/Testovye-karty
[nspk-sbp]: https://qr.nspk.ru/proxyapp/c2bmembers.json
[apple-can-open-url]: https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl
[apple-can-open-url-discussion]: https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl#discussion
[cocoapods]: https://cocoapods.org
[server-api]: https://www.tinkoff.ru/kassa/dev/payments/index.html
[issues]: https://opensource.tbank.ru/mobile-tech/asdk-ios/-/issues
[img-spm-products]: Docs/images/spm_products.png
