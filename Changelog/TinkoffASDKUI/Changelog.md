### `TinkoffASDKUI 6.2.1 @ 2025-01-23`
#### added
- [EACQAPW-14622](): Отображение скелетона при загрузке ПФ by [ext.iglushko]()


### `TinkoffASDKUI 6.2.0 @ 2025-01-14`
#### added
- [EACQAPW-13446](): Поддержка SwiftUI. by [ext.iglushko]()
- [EACQAPW-13693](): Добавить документацию по интеграции с SwiftUI by [ext.iglushko]()
#### fixed
- [EACQAPW-13845](): Баг - Показываем галочку "активной" карты после удаления одной из карт на экране отдельном список карт by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var AcquiringUISDK.sui is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AsdkSuiView is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IAcquiringSuiSDK is a new API without @available attribute`
- ⚠️ `ABI breakage: func View.ignoreSafeArea() is a new API without @available attribute`

### `TinkoffASDKUI 6.1.1 @ 2024-11-21`
#### changed
- [EACQAPW-12549](): Разделение номера карты by [ext.iglushko]()
#### fixed
- [EACQAPW-10045](): Скрывать экран со списком банков при ошибке в Init и GetQR при включенной настройке сокрытия шторок by [ext.iglushko]()
- [EACQAPW-13200](): Appbased обработка ошибок by [ext.iglushko]()
- [EACQAPW-13239](): Appbased поля ввода номера карты не дизейблятся во время запроса by [ext.iglushko]()
- [EACQAPW-13240](): Некорректная валидация номера карты by [ext.iglushko]()


### `TinkoffASDKUI 6.1.0 @ 2024-11-07`
#### added
- [EACQAPW-12212](): Добавил регресс юнит тесты в allure by [ext.iglushko]()
- [EACQAPW-12846](): EACQAPW-12846 Автотесты: настройка терминала by [ext.gglushkov]()
- [EACQAPW-12982](): Автотесты: Логирование сетевых запросов by [ext.gglushkov]()
#### fixed
- [EACQAPW-12549](): Разделение номера карты для unrecognized карты by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var UiTestsConfigKeys.networkLogsFilePath is a new API without @available attribute`
- ⚠️ `ABI breakage: var UiTestsConfigKeys.usedTerminalForUiTests is a new API without @available attribute`

### `TinkoffASDKUI 6.0.2 @ 2024-10-15`
#### changed
- [EACQAPW-12639](): Поднять ui version до 6.0.2 by [ext.iglushko]()


### `TinkoffASDKUI 6.0.1 @ 2024-10-15`
#### fixed
- [EACQAPW-12616](): Appbased Не передается Cres в Submit3dsAuthorization by [ext.iglushko]()


### `TinkoffASDKUI 6.0.0 @ 2024-10-10`
#### added
- [EACQAPW-10981](): Автотесты: обработка ошибок by [ext.gglushkov]()
- [EACQAPW-12000](): добавлены фича-флаги для управления отображением способов оплаты by [s.galagan]()
- [EACQAPW-12070](): Автотесты: Мокирование фичатоглов by [ext.gglushkov]()
- [EACQAPW-12228](): Добавлен опциональный параметр версии приложения, для управления тоглами by [s.galagan]()
- [EACQAPW-12259](): iOS поддержать работу ASDK на iOS 18 UIApplication.open by [s.galagan]()
#### changed
- [EACQAPW-11594](): Управление кэшом для разных терминалов by [ext.iglushko]()
- [EACQAPW-11713](): Оптимизирована валидация карт, используя только алгоритм Luhn by [s.galagan]()
- [EACQAPW-12316](): Выпил яндекс пея из кода семпла by [ext.iglushko]()
- [EACQAPW-8728](): Обработка ошибок by [ext.iglushko]()
#### fixed
- [EACQAPW-12183](): Appbased Ошибка timeout & Appbased Бесконечный лоудер при ошибке в AttachCard by [ext.iglushko]()
- [EACQAPW-12252](): Заменил ссылку на леднинг tpay by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.imageAlertRed is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusDeadlineExpired is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetIconAlarm is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetIconWifiOff is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:showPaymentNotifications:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var UiTestsConfigKeys.togglesFilePath is a new API without @available attribute`
- ⚠️ `ABI breakage: func UITestsUtils.getConfiguredFeatureToggles() is a new API without @available attribute`
- ⛔️ `ABI breakage: func AcquiringUISDK.yandexPayButtonContainerFactory(with:initializer:completion:) has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayButtonContainer has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayButtonContainerDelegate has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayButtonContainerFactory has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayButtonContainerFactoryInitializer has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayPaymentFlow has been removed`
- ⛔️ `ABI breakage: protocol IYandexPayPaymentFlowAssembly has been removed`
- ⛔️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:shouldHideLogoOnMainForm:showPaymentNotifications:) has been removed`
- ⛔️ `ABI breakage: enum YandexPayButtonContainerTheme has been removed`
- ⛔️ `ABI breakage: struct YandexPayButtonContainerConfiguration has been removed`
- ⛔️ `ABI breakage: protocol YandexPayPaymentFlowDelegate has been removed`
- ⛔️ `ABI breakage: struct YandexPaySDKConfiguration has been removed`

### `TinkoffASDKUI 5.1.0 @ 2024-08-26`
#### added
- [EACQAPW-10274](): Автотесты: Рекуррентный платеж by [al.v.ponomareva]()
- [EACQAPW-10275](): Автотесты: Сканирование карты by [ext.gglushkov]()
- [EACQAPW-10981](): Автотесты: поле email by [ext.gglushkov]()
- [EACQAPW-11085](): Tests for Remote toggles by [ext.iglushko]()
- [EACQAPW-11353](): Автотесты Комби-Инит by [ext.gglushkov]()
#### changed
- [EACQAPW-11357](): Обновлена почта поддержки в документации iOS by [s.galagan]()
- [EACQAPW-11466](): Fix test by [ext.iglushko]()
- [EACQAPW-11592](): Обновил 3ds wrapper & 3ds sdk by [ext.iglushko]()
#### fixed
- [EACQAPW-11537](): Remote toggles service fixes by [ext.iglushko]()
- [EACQAPW-11544](): Не отправляется DATA о фичатогле в /AttachCard by [ext.iglushko]()
- [EACQAPW-11683](): В информации о FT не приходит параметр 3DS NO by [ext.iglushko]()
- [EACQAPW-11718](): Убрать паблик мутацию тоглов by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.buttonControl is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.cardPaymentView is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.recurrentErrorSheet is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.recurrentErrorSheetPrimaryButton is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.recurrentErrorSheetCardData is a new API without @available attribute`
- ⚠️ `ABI breakage: var UiTestsConfigKeys.scanCardIsNeeded is a new API without @available attribute`
- ⚠️ `ABI breakage: var UiTestsConfigKeys.shouldNotSendEmail is a new API without @available attribute`
- ⚠️ `ABI breakage: var UiTestsConfigKeys.combiInitIsEnabled is a new API without @available attribute`
- ⚠️ `ABI breakage: struct UITestsUtils is a new API without @available attribute`

### `TinkoffASDKUI 5.0.0 @ 2024-06-06`
#### added
- [EACQAPW-10464](): Удалить deprecated методы + сделать доступным coreSDK из UI SDK by [ext.iglushko]()
- [EACQAPW-9434](): Внедрить 3ds-app-based flow [флоу привязки карты] by [ext.iglushko]()
- [EACQAPW-9814](): Автотесты: Оплата через СБП by [ext.gglushkov]()
- [EACQAPW-9931](): Добавил custom в PaymentCardCheckType by [ext.iglushko]()
#### changed
- [EACQAPW-10136](): Привести визуал App Based к МБ by [ext.iglushko]()
- [EACQAPW-10161](): Доработки по асдк by [ext.iglushko]()
- [EACQAPW-10319](): Добавлен completion, сообщающий о закрытии экрана со списком карт by [s.galagan]()
- [EACQAPW-9894](): Исправлены автотесты by [ext.gglushkov]()
- [EACQAPW-10399](): Поднятие версии YandexPaySDK 1.3.6 -> 1.7.0 by [ext.iglushko]()
- [EACQAPW-9815](): Автотесты: Удаление карты by [ext.gglushkov]()
#### fixed
- [EACQAPW-10070](): Добавил вызов /Check3DSVersion для .custom checkType при добавлении карты by [ext.iglushko]()
- [EACQAPW-10105](): СБП Бесконечный лоудер "Обрабатываем платеж" после получения промежуточного статуса by [ext.iglushko]()
- [EACQAPW-10243](): Баг не отправляются поля в DATA для /FA для карт с 3дс 1.0 by [ext.iglushko]()
- [EACQAPW-9894](): Фикс сбп флоу поверх платежной формы не скрывается шторка by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:addCardOptions:cardScannerDelegate:) has mangled name changing from 'TinkoffASDKUI.AcquiringUISDK.presentCardList(on: __C.UIViewController, customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>) -> ()' to 'TinkoffASDKUI.AcquiringUISDK.presentCardList(on: __C.UIViewController, customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>, completion: Swift.Optional<() -> ()>) -> ()'`
- ⚠️ `ABI breakage: var AcquiringUISDK.coreSDK is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetLoader is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetTitle is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetSecondaryButton is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.sbpTableView is a new API without @available attribute`
- ⚠️ `ABI breakage: func IYandexPayButtonContainer.setIsBordered(_:) is a new API without @available attribute`
- ⛔️ `ABI breakage: func IYandexPayButtonContainer.setIsBordered(_:) has been added as a protocol requirement`
- ⛔️ `ABI breakage: struct YandexPayButtonContainerTheme has been changed to a enum`
- ⚠️ `ABI breakage: enumelement YandexPayButtonContainerTheme.light is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement YandexPayButtonContainerTheme.dark is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement YandexPayButtonContainerTheme.system is a new API without @available attribute`
- ⚠️ `ABI breakage: func YandexPayButtonContainerTheme.==(_:_:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func YandexPayButtonContainerTheme.hash(into:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var YandexPayButtonContainerTheme.hashValue is a new API without @available attribute`
- ⚠️ `ABI breakage: var YandexPayButtonContainerConfiguration.cornerRadius is a new API without @available attribute`
- ⚠️ `ABI breakage: var YandexPayButtonContainerConfiguration.isBordered is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor YandexPayButtonContainerConfiguration.init(theme:cornerRadius:isBordered:) is a new API without @available attribute`
- ⚠️ `ABI breakage: struct UiTestsConfigKeys is a new API without @available attribute`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:addCardOptions:cardScannerDelegate:) has been renamed to func presentCardList(on:customerKey:addCardOptions:cardScannerDelegate:completion:)`
- ⛔️ `ABI breakage: func IYandexPayButtonContainer.reloadPersonalizationData(completion:) has been removed`
- ⛔️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:shouldHideLogoOnMainForm:) has been removed`
- ⛔️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:) has been removed`
- ⛔️ `ABI breakage: enum YandexPayButtonContainerAppearance has been removed`
- ⛔️ `ABI breakage: var YandexPayButtonContainerTheme.appearance has been removed`
- ⛔️ `ABI breakage: var YandexPayButtonContainerTheme.dynamic has been removed`
- ⛔️ `ABI breakage: constructor YandexPayButtonContainerTheme.init(appearance:dynamic:) has been removed`
- ⛔️ `ABI breakage: constructor YandexPayButtonContainerConfiguration.init(theme:) has been removed`

### `TinkoffASDKUI 4.3.0 @ 2024-05-07`
#### added
- [EACQAPW-9496](): Возможность отключения стандартных шторок об оплате (успех/ошибка by [ext.iglushko]()
- [EACQAPW-9540](): Добавлены автотесты на отображение главной платежной формы by [ext.gglushkov]()
- [EACQAPW-9904](): Автотесты: Выбор карты для оплаты by [ext.gglushkov]()
#### fixed
- [EACQAPW-9894](): Багфикс - остаемся на ПФ после завершения платежа при выключенных шторках by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.imageDeletedCard is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.mainFormSheet is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.orderDetails is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.receiptSwitchData is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.emailCell is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.emailInputField is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.tinkoffPayMethod is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.sbpMethod is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.cardMethod is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:shouldHideLogoOnMainForm:showPaymentNotifications:) is a new API without @available attribute`

### `TinkoffASDKUI 4.2.0 @ 2024-04-17`
#### added
- [EACQAPW-9061](): Добавлены автотесты оплаты картой. by [al.v.ponomareva]()
- [EACQAPW-9568](): Реализовать настройку скрытия лого на шторке by [ext.iglushko]()
#### changed
- [EACQAPW-9488](): Обновил логотипы Тинькофф by [s.galagan]()
#### fixed
- [EACQAPW-9255](): Добавлена блокировка кнопок на платежной форме при проведении платежа картой by [s.galagan]()
- [EACQAPW-9448](): Починил тесты для xcode 15.1 by [s.galagan]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.mainFormSheetSmallGerbImage is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.mainFormSheetPrimaryButton is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.mainFormSheetCardData is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.payByNewCardPagePrimaryButton is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.payByNewCardPageCardData is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheet is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetIconSuccess is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetIconFail is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetDescription is a new API without @available attribute`
- ⚠️ `ABI breakage: var AsdkAccessibilityIdentifier.paymentStatusSheetPrimaryButton is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor UISDKConfiguration.init(webViewAuthChallengeService:paymentStatusRetriesCount:addCardCheckType:shouldHideLogoOnMainForm:) is a new API without @available attribute`

### `TinkoffASDKUI 4.1.4 @ 2024-03-19`
#### changed
- [EACQAPW-8630](): Поднятие минимальной версии iOS до iOS 13 by [ext.iglushko]()
#### fixed
- [EACQAPW-8302](): Изменение логики алерта "Не получилось найти приложение банка" by [ext.iglushko]()


### `TinkoffASDKUI 4.1.3 @ 2024-02-08`
#### fixed
- [EACQAPW-8139](): Скрытие клавиатуры багфикс by [ext.iglushko]()


### `TinkoffASDKUI 4.1.2 @ 2024-01-10`
#### fixed
- [EACQAPW-8043](): Удалил CFBundleExecutable из TdsSdkIosResources.bundle/Info.plist by [ext.iglushko]()


### `TinkoffASDKUI 4.1.1 @ 2023-12-20`
#### changed
- [EACQAPW-7140](): Поправил тесты для тпея by [ext.iglushko]()


### `TinkoffASDKUI 4.1.0 @ 2023-11-22`
#### added
- [EACQAPW-7265](): Добавить подержку bank100000000004 для ASDK ios ПФ by [ext.iglushko]()
#### changed
- [EACQAPW-6130](): Make Version public by [a.pravosudov]()
- [EACQAPW-7334](): Поправил тесты по схемам тинькофф банка by [ext.iglushko]()
- [EACQAPW-7415](): Обновил версии Version.swift by [ext.iglushko]()
#### fixed
- [EACQAPW-6546](): Лоудер блокирует экран ввода данных новой карты by [ext.iglushko]()
- [EACQAPW-6573](): Закомментил тест чтобы не падал линт при релизе by [ivanglushkodev]()
- [EACQAPW-6610](): Правки убрал кириллицу из сурс кода by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: struct Version is a new API without @available attribute`

### `TinkoffASDKUI 4.0.1 @ 2023-08-28`
#### changed
- [EACQAPW-6012](): Оключить app based flow для платежей по карте by [ext.iglushko]()
- [EACQAPW-6098](): Добавил логгирование версий компонентов ASDK by [ext.iglushko]()


### `TinkoffASDKUI 4.0.0 @ 2023-08-24`
#### added
- [EACQAPW-5996](): Влитие /dev ветки в /master by [ext.iglushko]()
#### changed
- [EACQAPW-5968](): Переезд на пайплайны коры by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: func AcquiringUISDK.addCardController(customerKey:) has mangled name changing from 'TinkoffASDKUI.AcquiringUISDK.addCardController(customerKey: Swift.String) -> TinkoffASDKUI.IAddCardController' to 'TinkoffASDKUI.AcquiringUISDK.addCardController(customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions) -> TinkoffASDKUI.IAddCardController'`
- ⚠️ `ABI breakage: func AcquiringUISDK.cardsController(customerKey:) has mangled name changing from 'TinkoffASDKUI.AcquiringUISDK.cardsController(customerKey: Swift.String) -> TinkoffASDKUI.ICardsController' to 'TinkoffASDKUI.AcquiringUISDK.cardsController(customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions) -> TinkoffASDKUI.ICardsController'`
- ⚠️ `ABI breakage: func AcquiringUISDK.presentAddCard(on:customerKey:cardScannerDelegate:completion:) has mangled name changing from 'TinkoffASDKUI.AcquiringUISDK.presentAddCard(on: __C.UIViewController, customerKey: Swift.String, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>, completion: Swift.Optional<(TinkoffASDKUI.AddCardResult) -> ()>) -> ()' to 'TinkoffASDKUI.AcquiringUISDK.presentAddCard(on: __C.UIViewController, customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>, completion: Swift.Optional<(TinkoffASDKUI.AddCardResult) -> ()>) -> ()'`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentAddCard(on:customerKey:cardScannerDelegate:completion:) has parameter 2 type change from TinkoffASDKUI.ICardScannerDelegate? to TinkoffASDKUI.AddCardOptions`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentAddCard(on:customerKey:cardScannerDelegate:completion:) has removed default argument from parameter 2`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentAddCard(on:customerKey:cardScannerDelegate:completion:) has parameter 3 type change from ((TinkoffASDKUI.AddCardResult) -> ())? to TinkoffASDKUI.ICardScannerDelegate?`
- ⚠️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:cardScannerDelegate:) has mangled name changing from 'TinkoffASDKUI.AcquiringUISDK.presentCardList(on: __C.UIViewController, customerKey: Swift.String, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>) -> ()' to 'TinkoffASDKUI.AcquiringUISDK.presentCardList(on: __C.UIViewController, customerKey: Swift.String, addCardOptions: TinkoffASDKUI.AddCardOptions, cardScannerDelegate: Swift.Optional<TinkoffASDKUI.ICardScannerDelegate>) -> ()'`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:cardScannerDelegate:) has parameter 2 type change from TinkoffASDKUI.ICardScannerDelegate? to TinkoffASDKUI.AddCardOptions`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:cardScannerDelegate:) has removed default argument from parameter 2`
- ⚠️ `ABI breakage: func ChargePaymentControllerDelegate.paymentController(_:shouldRepeatWithRebillId:failedPaymentProcess:additionalData:error:) has mangled name changing from 'TinkoffASDKUI.ChargePaymentControllerDelegate.paymentController(_: TinkoffASDKUI.IPaymentController, shouldRepeatWithRebillId: Swift.String, failedPaymentProcess: TinkoffASDKUI.IPaymentProcess, additionalData: Swift.Dictionary<Swift.String, Swift.String>, error: Swift.Error) -> ()' to 'TinkoffASDKUI.ChargePaymentControllerDelegate.paymentController(_: TinkoffASDKUI.IPaymentController, shouldRepeatWithRebillId: Swift.String, failedPaymentProcess: TinkoffASDKUI.IPaymentProcess, additionalInitData: Swift.Optional<TinkoffASDKCore.AdditionalData>, error: Swift.Error) -> ()'`
- ⛔️ `ABI breakage: func ChargePaymentControllerDelegate.paymentController(_:shouldRepeatWithRebillId:failedPaymentProcess:additionalData:error:) has parameter 3 type change from [Swift.String : Swift.String] to TinkoffASDKCore.AdditionalData?`
- ⚠️ `ABI breakage: var FinishPaymentOptions.paymentFinishData is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor FinishPaymentOptions.init(paymentId:amount:orderId:customerOptions:paymentFinishData:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func IAddCardController.addCard(options:completion:) has mangled name changing from 'TinkoffASDKUI.IAddCardController.addCard(options: TinkoffASDKUI.CardOptions, completion: (TinkoffASDKUI.AddCardStateResult) -> ()) -> ()' to 'TinkoffASDKUI.IAddCardController.addCard(cardData: TinkoffASDKUI.CardData, completion: (TinkoffASDKUI.AddCardStateResult) -> ()) -> ()'`
- ⛔️ `ABI breakage: func IAddCardController.addCard(options:completion:) has parameter 0 type change from TinkoffASDKUI.CardOptions to TinkoffASDKUI.CardData`
- ⚠️ `ABI breakage: func ICardsController.addCard(options:completion:) has mangled name changing from 'TinkoffASDKUI.ICardsController.addCard(options: TinkoffASDKUI.CardOptions, completion: (TinkoffASDKUI.AddCardResult) -> ()) -> ()' to 'TinkoffASDKUI.ICardsController.addCard(cardData: TinkoffASDKUI.CardData, completion: (TinkoffASDKUI.AddCardResult) -> ()) -> ()'`
- ⛔️ `ABI breakage: func ICardsController.addCard(options:completion:) has parameter 0 type change from TinkoffASDKUI.CardOptions to TinkoffASDKUI.CardData`
- ⚠️ `ABI breakage: func IRecurrentPaymentFailiureDelegate.recurrentPaymentNeedRepeatInit(additionalData:completion:) has mangled name changing from 'TinkoffASDKUI.IRecurrentPaymentFailiureDelegate.recurrentPaymentNeedRepeatInit(additionalData: Swift.Dictionary<Swift.String, Swift.String>, completion: (Swift.Result<Swift.String, Swift.Error>) -> ()) -> ()' to 'TinkoffASDKUI.IRecurrentPaymentFailiureDelegate.recurrentPaymentNeedRepeatInit(additionalInitData: TinkoffASDKCore.AdditionalData, completion: (Swift.Result<Swift.String, Swift.Error>) -> ()) -> ()'`
- ⛔️ `ABI breakage: func IRecurrentPaymentFailiureDelegate.recurrentPaymentNeedRepeatInit(additionalData:completion:) has parameter 0 type change from [Swift.String : Swift.String] to TinkoffASDKCore.AdditionalData`
- ⚠️ `ABI breakage: var PaymentOptions.paymentInitData is a new API without @available attribute`
- ⚠️ `ABI breakage: var PaymentOptions.paymentFinishData is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor PaymentOptions.init(orderOptions:customerOptions:paymentCallbackURL:paymentInitData:paymentFinishData:) is a new API without @available attribute`
- ⛔️ `ABI breakage: protocol ThreeDSWebFlowDelegate has generic signature change from <Self : AnyObject> to <Self : AnyObject, Self : Swift.Equatable>`
- ⛔️ `ABI breakage: protocol ThreeDSWebFlowDelegate has added inherited protocol Equatable`
- ⚠️ `ABI breakage: struct CardOptions has mangled name changing from 'TinkoffASDKUI.CardOptions' to 'TinkoffASDKUI.AddCardOptions'`
- ⚠️ `ABI breakage: var AddCardOptions.attachCardData is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor AddCardOptions.init(attachCardData:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var AddCardOptions.empty is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AsdkAccessibilityIdentifier is a new API without @available attribute`
- ⚠️ `ABI breakage: struct CardData is a new API without @available attribute`
- ⛔️ `ABI breakage: func AcquiringUISDK.addCardController(customerKey:) has been renamed to func addCardController(customerKey:addCardOptions:)`
- ⛔️ `ABI breakage: func AcquiringUISDK.cardsController(customerKey:) has been renamed to func cardsController(customerKey:addCardOptions:)`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentAddCard(on:customerKey:cardScannerDelegate:completion:) has been renamed to func presentAddCard(on:customerKey:addCardOptions:cardScannerDelegate:completion:)`
- ⛔️ `ABI breakage: func AcquiringUISDK.presentCardList(on:customerKey:cardScannerDelegate:) has been renamed to func presentCardList(on:customerKey:addCardOptions:cardScannerDelegate:)`
- ⛔️ `ABI breakage: var CardOptions.pan has been removed`
- ⛔️ `ABI breakage: var CardOptions.validThru has been removed`
- ⛔️ `ABI breakage: var CardOptions.cvc has been removed`
- ⛔️ `ABI breakage: constructor CardOptions.init(pan:validThru:cvc:) has been removed`
- ⛔️ `ABI breakage: struct CardOptions has been renamed to struct AddCardOptions`
- ⛔️ `ABI breakage: func ChargePaymentControllerDelegate.paymentController(_:shouldRepeatWithRebillId:failedPaymentProcess:additionalData:error:) has been renamed to func paymentController(_:shouldRepeatWithRebillId:failedPaymentProcess:additionalInitData:error:)`
- ⛔️ `ABI breakage: constructor FinishPaymentOptions.init(paymentId:amount:orderId:customerOptions:) has been removed`
- ⛔️ `ABI breakage: func IAddCardController.addCard(options:completion:) has been renamed to func addCard(cardData:completion:)`
- ⛔️ `ABI breakage: func ICardsController.addCard(options:completion:) has been renamed to func addCard(cardData:completion:)`
- ⛔️ `ABI breakage: func IRecurrentPaymentFailiureDelegate.recurrentPaymentNeedRepeatInit(additionalData:completion:) has been renamed to func recurrentPaymentNeedRepeatInit(additionalInitData:completion:)`
- ⛔️ `ABI breakage: var PaymentOptions.paymentData has been removed`
- ⛔️ `ABI breakage: constructor PaymentOptions.init(orderOptions:customerOptions:paymentCallbackURL:paymentData:) has been removed`

