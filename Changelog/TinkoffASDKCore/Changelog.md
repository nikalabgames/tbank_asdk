### `TinkoffASDKCore 8.2.0 @ 2025-01-23`
#### changed
- [EACQAPW-13399](): Исправлено перезаписывание тоглов в случае, если еще не пришел ответ на запрос GetToggles by [ext.gglushkov]()


### `TinkoffASDKCore 8.1.0 @ 2025-01-14`
#### added
- [EACQAPW-13983](): Добавили новые поля НДС в Tax тип. by [ext.iglushko]()
#### changed
- [EACQAPW-13981](): Заменить Complete3DSMethodv2 -> Complete3DSMethodV2 by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: enumelement Tax.vat5 is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement Tax.vat7 is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement Tax.vat105 is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement Tax.vat107 is a new API without @available attribute`

### `TinkoffASDKCore 8.0.3 @ 2024-11-21`
#### changed
- [EACQAPW-12549](): Разделение номера карты by [ext.iglushko]()
#### fixed
- [EACQAPW-13092](): Исправлено обновление локальных тоглов by [ext.gglushkov]()


### `TinkoffASDKCore 8.0.2 @ 2024-11-07`
#### added
- [EACQAPW-12212](): Добавил регресс юнит тесты в allure by [ext.iglushko]()


### `TinkoffASDKCore 8.0.1 @ 2024-10-11`
#### added
- [EACQAPW-12561](): Поднять версию Core до 8.0.1 by [ext.iglushko]()


### `TinkoffASDKCore 8.0.1 @ 2024-10-10`
#### added
- [EACQAPW-12000](): добавлены фича-флаги для управления отображением способов оплаты by [s.galagan]()
- [EACQAPW-12070](): Автотесты: Мокирование фичатоглов by [ext.gglushkov]()
- [EACQAPW-12228](): Добавлен опциональный параметр версии приложения, для управления тоглами by [s.galagan]()
- [EACQAPW-8728](): Обработка ошибок by [ext.iglushko]()
#### changed
- [EACQAPW-11594](): Управление кэшом для разных терминалов by [ext.iglushko]()
- [EACQAPW-12316](): Выпил яндекс пея из кода семпла by [ext.iglushko]()
#### fixed
- [EACQAPW-12252](): Исправить параметры для tpay by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:appVersion:) is a new API without @available attribute`
- ⛔️ `ABI breakage: accessor FeatureToggle.isEnabled.Set() has been removed`
- ⛔️ `ABI breakage: accessor FeatureToggle.isEnabled.Modify() has been removed`
- ⚠️ `ABI breakage: enumelement FeatureToggleList.mainFormLogoVisibility is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement FeatureToggleList.tpayMethodVisibility is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement FeatureToggleList.sbpMethodVisibility is a new API without @available attribute`
- ⚠️ `ABI breakage: var FeatureToggleList.id is a new API without @available attribute`
- ⚠️ `ABI breakage: enum NetworkError is a new API without @available attribute`
- ⛔️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:) has been removed`
- ⛔️ `ABI breakage: enumelement PaymentSourceData.yandexPay has been removed`
- ⛔️ `ABI breakage: enumelement TerminalPayMethod.yandexPay has been removed`
- ⛔️ `ABI breakage: struct YandexPayMethod has been removed`

### `TinkoffASDKCore 7.0.0 @ 2024-08-26`
#### added
- [EACQAPW-11085](): Remote feature toggles by [ext.iglushko]()
#### changed
- [EACQAPW-11357](): Обновлена почта поддержки в документации iOS by [s.galagan]()
#### fixed
- [EACQAPW-11537](): Remote toggles service fixes by [ext.iglushko]()
- [EACQAPW-11544](): Не отправляется DATA о фичатогле в /v2/AttachCard by [ext.iglushko]()
- [EACQAPW-11683](): В информации о FT не приходит параметр 3DS NO by [ext.iglushko]()
- [EACQAPW-11718](): Убрать паблик мутацию тоглов by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: func AcquiringSdk.getToggles(completion:) is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor AttachCardData.init(cardNumber:expDate:cvv:requestKey:data:isUsing3DS:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func Check3DSVersionPayload.receiveVersion() has mangled name changing from 'TinkoffASDKCore.Check3DSVersionPayload.receiveVersion() -> TinkoffASDKCore.Check3DSVersionPayload.ThreeDSVersion' to 'TinkoffASDKCore.Check3DSVersionPayload.receiveVersion() -> TinkoffASDKCore.ThreeDSVersion'`
- ⛔️ `ABI breakage: func Check3DSVersionPayload.receiveVersion() has return type change from TinkoffASDKCore.Check3DSVersionPayload.ThreeDSVersion to TinkoffASDKCore.ThreeDSVersion`
- ⚠️ `ABI breakage: enum ThreeDSVersion is a new API without @available attribute`
- ⚠️ `ABI breakage: struct GetTogglesPayload is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ToggleModel is a new API without @available attribute`
- ⚠️ `ABI breakage: enum ToggleDcoStatus is a new API without @available attribute`
- ⛔️ `ABI breakage: constructor AttachCardData.init(cardNumber:expDate:cvv:requestKey:data:) has been removed`
- ⛔️ `ABI breakage: enum Check3DSVersionPayload.ThreeDSVersion has been removed`
- ⛔️ `ABI breakage: func IFeatureToggle.set(isEnabled:) has been removed`

### `TinkoffASDKCore 6.0.0 @ 2024-06-06`
#### added
- [EACQAPW-9434](): Внедрить 3ds-app-based flow [флоу привязки карты] by [ext.iglushko]()
- [EACQAPW-9931](): Добавил custom в PaymentCardCheckType by [ext.iglushko]()
#### changed
- [EACQAPW-10161](): Доработки по асдк by [ext.iglushko]()
- [EACQAPW-10399](): Поднятие версии YandexPaySDK 1.3.6 -> 1.7.0 by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func IFeatureToggle.set(isEnabled:) is a new API without @available attribute`
- ⛔️ `ABI breakage: func IFeatureToggle.set(isEnabled:) has been added as a protocol requirement`
- ⛔️ `ABI breakage: struct FeatureToggle is now with final`
- ⛔️ `ABI breakage: struct FeatureToggle has been changed to a class`
- ⛔️ `ABI breakage: var FeatureToggle.description is now with final`
- ⛔️ `ABI breakage: accessor FeatureToggle.description.Get() is now with final`
- ⛔️ `ABI breakage: var FeatureToggle.id is now with final`
- ⛔️ `ABI breakage: accessor FeatureToggle.id.Get() is now with final`
- ⛔️ `ABI breakage: var FeatureToggle.isEnabled is now with final`
- ⛔️ `ABI breakage: accessor FeatureToggle.isEnabled.Get() is now with final`
- ⚠️ `ABI breakage: accessor FeatureToggle.isEnabled.Set() is a new API without @available attribute`
- ⚠️ `ABI breakage: accessor FeatureToggle.isEnabled.Modify() is a new API without @available attribute`
- ⚠️ `ABI breakage: func FeatureToggle.set(isEnabled:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var IFeatureToggleService.toggles is a new API without @available attribute`
- ⛔️ `ABI breakage: var IFeatureToggleService.toggles has been added as a protocol requirement`
- ⚠️ `ABI breakage: func IFeatureToggleService.featureEnabled(_:) is a new API without @available attribute`
- ⛔️ `ABI breakage: func IFeatureToggleService.featureEnabled(_:) has been added as a protocol requirement`
- ⛔️ `ABI breakage: enum PaymentCardCheckType has removed conformance to Hashable`
- ⚠️ `ABI breakage: enumelement PaymentCardCheckType.custom is a new API without @available attribute`
- ⚠️ `ABI breakage: func PaymentCardCheckType.encode(to:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var YandexPayMethod.url is a new API without @available attribute`
- ⚠️ `ABI breakage: enum FeatureToggleList is a new API without @available attribute`
- ⛔️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:appBasedSdkInterface:) has been removed`
- ⛔️ `ABI breakage: var YandexPayMethod.merchantOrigin has been removed`

### `TinkoffASDKCore 5.1.4 @ 2024-05-07`
#### added
- [EACQAPW-9805](): Добавлен Privacy Manifest by [s.galagan]()


### `TinkoffASDKCore 5.1.3 @ 2024-04-17`
#### changed
- [EACQAPW-9488](): Обновил логотипы Тинькофф. by [s.galagan]()
#### fixed
- [EACQAPW-9448](): Починил тесты для xcode 15.1 by [s.galagan]()


### `TinkoffASDKCore 5.1.2 @ 2024-03-19`
#### changed
- [EACQAPW-8630](): Поднятие минимальной версии iOS до iOS 13 by [ext.iglushko]()


### `TinkoffASDKCore 5.1.1 @ 2024-02-22`
#### changed
- [EACQAPW-8524](): Заменить endpoint на v2/Submit3DSAuthorization by [ext.iglushko]()
#### fixed
- [EACQAPW-8553](): Фикс - убрал доп параметры для формирования токена by [ext.iglushko]()


### `TinkoffASDKCore 5.1.0 @ 2024-02-08`
#### added
- [EACQAPW-8037](): Реализовал сервис для работы с Feature Toggle-ами by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: protocol IFeatureToggle is a new API without @available attribute`
- ⚠️ `ABI breakage: struct FeatureToggle is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IFeatureToggleService is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IFeatureToggleServiceAssembly is a new API without @available attribute`
- ⚠️ `ABI breakage: class FeatureToggleServiceAssembly is a new API without @available attribute`

### `TinkoffASDKCore 5.0.1 @ 2023-12-20`
#### added
- [EACQAPW-7366](): Настроить передачу параметра deviceOS в Init + FinishAuthorize by [ext.iglushko]()


### `TinkoffASDKCore 5.0.0 @ 2023-11-22`
#### changed
- [EACQAPW-6033](): Обновление моделей Receipt и Items by [ext.nvasilev]()
- [EACQAPW-6129](): Перевел EditSdkCredentials на MVP by [ext.iglushko]()
- [EACQAPW-6130](): Make Version public by [a.pravosudov]()
- [EACQAPW-7415](): Обновил версии Version.swift by [ext.iglushko]()
#### fixed
- [EACQAPW-6333](): Поправил C букву с rus -> eng by [ext.iglushko]()
- [EACQAPW-6610](): Правки убрал кириллицу из сурс кода by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: var ClientInfo.documentCode is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor ClientInfo.init(birthdate:citizenship:documentCode:documentData:address:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_05.items has mangled name changing from 'TinkoffASDKCore.ReceiptFdv1_05.items : Swift.Array<TinkoffASDKCore.Item>' to 'TinkoffASDKCore.ReceiptFdv1_05.items : Swift.Array<TinkoffASDKCore.Item_v1_05>'`
- ⛔️ `ABI breakage: var ReceiptFdv1_05.items has declared type change from [TinkoffASDKCore.Item] to [TinkoffASDKCore.Item_v1_05]`
- ⚠️ `ABI breakage: accessor ReceiptFdv1_05.items.Get() has mangled name changing from 'TinkoffASDKCore.ReceiptFdv1_05.items.getter : Swift.Array<TinkoffASDKCore.Item>' to 'TinkoffASDKCore.ReceiptFdv1_05.items.getter : Swift.Array<TinkoffASDKCore.Item_v1_05>'`
- ⛔️ `ABI breakage: accessor ReceiptFdv1_05.items.Get() has return type change from [TinkoffASDKCore.Item] to [TinkoffASDKCore.Item_v1_05]`
- ⚠️ `ABI breakage: accessor ReceiptFdv1_05.items.Set() has mangled name changing from 'TinkoffASDKCore.ReceiptFdv1_05.items.setter : Swift.Array<TinkoffASDKCore.Item>' to 'TinkoffASDKCore.ReceiptFdv1_05.items.setter : Swift.Array<TinkoffASDKCore.Item_v1_05>'`
- ⛔️ `ABI breakage: accessor ReceiptFdv1_05.items.Set() has parameter 0 type change from [TinkoffASDKCore.Item] to [TinkoffASDKCore.Item_v1_05]`
- ⚠️ `ABI breakage: accessor ReceiptFdv1_05.items.Modify() has mangled name changing from 'TinkoffASDKCore.ReceiptFdv1_05.items.modify : Swift.Array<TinkoffASDKCore.Item>' to 'TinkoffASDKCore.ReceiptFdv1_05.items.modify : Swift.Array<TinkoffASDKCore.Item_v1_05>'`
- ⚠️ `ABI breakage: constructor ReceiptFdv1_05.init(shopCode:email:taxation:phone:items:agentData:supplierInfo:) has mangled name changing from 'TinkoffASDKCore.ReceiptFdv1_05.init(shopCode: Swift.Optional<Swift.String>, email: Swift.Optional<Swift.String>, taxation: TinkoffASDKCore.Taxation, phone: Swift.Optional<Swift.String>, items: Swift.Array<TinkoffASDKCore.Item>, agentData: Swift.Optional<TinkoffASDKCore.AgentData>, supplierInfo: Swift.Optional<TinkoffASDKCore.SupplierInfo>) throws -> TinkoffASDKCore.ReceiptFdv1_05' to 'TinkoffASDKCore.ReceiptFdv1_05.init(shopCode: Swift.Optional<Swift.String>, email: Swift.Optional<Swift.String>, taxation: TinkoffASDKCore.Taxation, phone: Swift.Optional<Swift.String>, items: Swift.Array<TinkoffASDKCore.Item_v1_05>, agentData: Swift.Optional<TinkoffASDKCore.AgentData>, supplierInfo: Swift.Optional<TinkoffASDKCore.SupplierInfo>) throws -> TinkoffASDKCore.ReceiptFdv1_05'`
- ⛔️ `ABI breakage: constructor ReceiptFdv1_05.init(shopCode:email:taxation:phone:items:agentData:supplierInfo:) has parameter 4 type change from [TinkoffASDKCore.Item] to [TinkoffASDKCore.Item_v1_05]`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.taxation is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.email is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.phone is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.items is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.payments is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.operatingCheckProps is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.sectoralCheckProps is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.addUserProp is a new API without @available attribute`
- ⚠️ `ABI breakage: var ReceiptFdv1_2.additionalCheckProps is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor ReceiptFdv1_2.init(email:taxation:phone:items:customer:customerInn:clientInfo:payments:operatingCheckProps:sectoralCheckProps:addUserProp:additionalCheckProps:) is a new API without @available attribute`
- ⚠️ `ABI breakage: struct Item has mangled name changing from 'TinkoffASDKCore.Item' to 'TinkoffASDKCore.Item_v1_2'`
- ⛔️ `ABI breakage: struct Item has removed conformance to Decodable`
- ⚠️ `ABI breakage: func Item.encode(to:) has mangled name changing from 'TinkoffASDKCore.Item.encode(to: Swift.Encoder) throws -> ()' to 'TinkoffASDKCore.Item_v1_2.encode(to: Swift.Encoder) throws -> ()'`
- ⚠️ `ABI breakage: func Item.==(_:_:) has mangled name changing from 'static TinkoffASDKCore.Item.== infix(TinkoffASDKCore.Item, TinkoffASDKCore.Item) -> Swift.Bool' to 'static TinkoffASDKCore.Item_v1_2.== infix(TinkoffASDKCore.Item_v1_2, TinkoffASDKCore.Item_v1_2) -> Swift.Bool'`
- ⛔️ `ABI breakage: func Item.==(_:_:) has parameter 0 type change from TinkoffASDKCore.Item to TinkoffASDKCore.Item_v1_2`
- ⛔️ `ABI breakage: func Item.==(_:_:) has parameter 1 type change from TinkoffASDKCore.Item to TinkoffASDKCore.Item_v1_2`
- ⚠️ `ABI breakage: constructor Item_v1_2.init(amount:price:name:tax:quantity:paymentObject:paymentMethod:supplierInfo:agentData:userData:excise:countryCode:declarationNumber:measurementUnit:markProcessingMode:markCode:markQuantity:sectoralItemProps:) is a new API without @available attribute`
- ⚠️ `ABI breakage: enum PaymentObject has mangled name changing from 'TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2'`
- ⚠️ `ABI breakage: enumelement PaymentObject.excise has mangled name changing from 'TinkoffASDKCore.PaymentObject.excise(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.excise(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.excise has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.job has mangled name changing from 'TinkoffASDKCore.PaymentObject.job(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.job(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.job has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.service has mangled name changing from 'TinkoffASDKCore.PaymentObject.service(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.service(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.service has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.gamblingBet has mangled name changing from 'TinkoffASDKCore.PaymentObject.gamblingBet(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.gamblingBet(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.gamblingBet has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.gamblingPrize has mangled name changing from 'TinkoffASDKCore.PaymentObject.gamblingPrize(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.gamblingPrize(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.gamblingPrize has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.lottery has mangled name changing from 'TinkoffASDKCore.PaymentObject.lottery(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.lottery(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.lottery has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.lotteryPrize has mangled name changing from 'TinkoffASDKCore.PaymentObject.lotteryPrize(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.lotteryPrize(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.lotteryPrize has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.intellectualActivity has mangled name changing from 'TinkoffASDKCore.PaymentObject.intellectualActivity(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.intellectualActivity(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.intellectualActivity has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.payment has mangled name changing from 'TinkoffASDKCore.PaymentObject.payment(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.payment(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.payment has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.agentCommission has mangled name changing from 'TinkoffASDKCore.PaymentObject.agentCommission(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.agentCommission(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.agentCommission has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: enumelement PaymentObject.another has mangled name changing from 'TinkoffASDKCore.PaymentObject.another(TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.another(TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2'`
- ⛔️ `ABI breakage: enumelement PaymentObject.another has declared type change from (TinkoffASDKCore.PaymentObject.Type) -> TinkoffASDKCore.PaymentObject to (TinkoffASDKCore.PaymentObject_v1_2.Type) -> TinkoffASDKCore.PaymentObject_v1_2`
- ⚠️ `ABI breakage: constructor PaymentObject.init(rawValue:) has mangled name changing from 'TinkoffASDKCore.PaymentObject.init(rawValue: Swift.String) -> TinkoffASDKCore.PaymentObject' to 'TinkoffASDKCore.PaymentObject_v1_2.init(rawValue: Swift.String) -> Swift.Optional<TinkoffASDKCore.PaymentObject_v1_2>'`
- ⛔️ `ABI breakage: constructor PaymentObject.init(rawValue:) has return type change from TinkoffASDKCore.PaymentObject to TinkoffASDKCore.PaymentObject_v1_2?`
- ⚠️ `ABI breakage: var PaymentObject.rawValue has mangled name changing from 'TinkoffASDKCore.PaymentObject.rawValue : Swift.String' to 'TinkoffASDKCore.PaymentObject_v1_2.rawValue : Swift.String'`
- ⚠️ `ABI breakage: accessor PaymentObject.rawValue.Get() has mangled name changing from 'TinkoffASDKCore.PaymentObject.rawValue.getter : Swift.String' to 'TinkoffASDKCore.PaymentObject_v1_2.rawValue.getter : Swift.String'`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.commodity is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.contribution is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.propertyRights is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.unrealization is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.taxReduction is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.tradeFee is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.resortTax is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.pledge is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.incomeDecrease is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.iePensionInsuranceWithoutPayments is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.iePensionInsuranceWithPayments is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.ieMedicalInsuranceWithoutPayments is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.ieMedicalInsuranceWithPayments is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.socialInsurance is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.casinoChips is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.agentPayment is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.excisableGoodsWithoutMarkingCode is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.excisableGoodsWithMarkingCode is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.goodsWithoutMarkingCode is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement PaymentObject_v1_2.goodsWithMarkingCode is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AddUserProp is a new API without @available attribute`
- ⚠️ `ABI breakage: struct Item_v1_05 is a new API without @available attribute`
- ⚠️ `ABI breakage: struct MarkCode is a new API without @available attribute`
- ⚠️ `ABI breakage: struct MarkQuantity is a new API without @available attribute`
- ⚠️ `ABI breakage: struct OperatingCheckProps is a new API without @available attribute`
- ⚠️ `ABI breakage: enum PaymentObject_v1_05 is a new API without @available attribute`
- ⚠️ `ABI breakage: struct Payments is a new API without @available attribute`
- ⚠️ `ABI breakage: struct SectoralCheckProps is a new API without @available attribute`
- ⚠️ `ABI breakage: struct SectoralItemProps is a new API without @available attribute`
- ⚠️ `ABI breakage: struct Version is a new API without @available attribute`
- ⛔️ `ABI breakage: var ClientInfo.documentСode has been removed`
- ⛔️ `ABI breakage: constructor ClientInfo.init(birthdate:citizenship:documentСode:documentData:address:) has been removed`
- ⛔️ `ABI breakage: constructor Item.init(from:) has been removed`
- ⛔️ `ABI breakage: constructor Item.init(amount:price:name:tax:quantity:paymentObject:paymentMethod:ean13:shopCode:measurementUnit:supplierInfo:agentData:) has been removed`
- ⛔️ `ABI breakage: struct Item has been renamed to struct Item_v1_2`
- ⛔️ `ABI breakage: enumelement PaymentObject.composite has been removed`
- ⛔️ `ABI breakage: enum PaymentObject has been renamed to enum PaymentObject_v1_2`
- ⛔️ `ABI breakage: var ReceiptFdv1_2.base has been removed`
- ⛔️ `ABI breakage: constructor ReceiptFdv1_2.init(base:customer:customerInn:clientInfo:) has been removed`

### `TinkoffASDKCore 4.1.0 @ 2023-08-28`
#### changed
- [EACQAPW-6012](): Оключить app based flow для платежей по карте by [ext.iglushko]()
- [EACQAPW-6098](): Добавил логгирование версий компонентов ASDK by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: protocol IAsdkVersionProvider is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AsdkVersionProvider is a new API without @available attribute`

### `TinkoffASDKCore 4.0.0 @ 2023-08-24`
#### added
- [EACQAPW-5996](): Влитие /dev ветки в /master by [ext.iglushko]()
#### changed
- [EACQAPW-5968](): Переезд на пайплайны коры by [ext.iglushko]()

#### ⚙️ API changes
- ⚠️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:appBasedSdkInterface:) is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor AttachCardData.init(cardNumber:expDate:cvv:requestKey:data:) is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement AttachCardStatus.needConfirmation3DS2AppBased is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor CertificateData.init(paymentSystem:directoryServerID:type:url:notAfterDate:sha256Fingerprint:algorithm:forceUpdateFlag:) is a new API without @available attribute`
- ⚠️ `ABI breakage: enum Check3DSVersionPayload.ThreeDSVersion is a new API without @available attribute`
- ⚠️ `ABI breakage: func Check3DSVersionPayload.receiveVersion() is a new API without @available attribute`
- ⚠️ `ABI breakage: func Checking3DSURLData.==(_:_:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func DefaultAuthChallengeService.didReceive(challenge:completionHandler:) has mangled name changing from 'TinkoffASDKCore.DefaultAuthChallengeService.didReceive(challenge: __C.NSURLAuthenticationChallenge, completionHandler: (__C.NSURLSessionAuthChallengeDisposition, Swift.Optional<__C.NSURLCredential>) -> ()) -> ()' to 'TinkoffASDKCore.DefaultAuthChallengeService.didReceive(challenge: TinkoffASDKCore.IURLAuthenticationChallenge, completionHandler: (__C.NSURLSessionAuthChallengeDisposition, Swift.Optional<__C.NSURLCredential>) -> ()) -> ()'`
- ⛔️ `ABI breakage: func DefaultAuthChallengeService.didReceive(challenge:completionHandler:) has parameter 0 type change from Foundation.URLAuthenticationChallenge to TinkoffASDKCore.IURLAuthenticationChallenge`
- ⚠️ `ABI breakage: var FinishAuthorizeData.paymentId is a new API without @available attribute`
- ⚠️ `ABI breakage: var FinishAuthorizeData.infoEmail is a new API without @available attribute`
- ⚠️ `ABI breakage: var FinishAuthorizeData.sendEmail is a new API without @available attribute`
- ⚠️ `ABI breakage: var FinishAuthorizeData.amount is a new API without @available attribute`
- ⚠️ `ABI breakage: var FinishAuthorizeData.data is a new API without @available attribute`
- ⚠️ `ABI breakage: var FinishAuthorizeData.deviceChannel is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor FinishAuthorizeData.init(paymentId:paymentSource:infoEmail:amount:data:) is a new API without @available attribute`
- ⚠️ `ABI breakage: constructor Get3DSAppBasedCertsConfigPayload.init(certificates:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func GetCardListData.==(_:_:) is a new API without @available attribute`
- ⚠️ `ABI breakage: var PaymentInitData.additionalData is a new API without @available attribute`
- ⛔️ `ABI breakage: struct Receipt has been changed to a enum`
- ⛔️ `ABI breakage: struct Receipt has removed conformance to Decodable`
- ⚠️ `ABI breakage: enumelement Receipt.version1_05 is a new API without @available attribute`
- ⚠️ `ABI breakage: enumelement Receipt.version1_2 is a new API without @available attribute`
- ⚠️ `ABI breakage: func RemoveCardData.==(_:_:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func RemoveCardPayload.==(_:_:) is a new API without @available attribute`
- ⚠️ `ABI breakage: func IThreeDSDeviceInfoProvider.createThreeDsDataBrowser(threeDSCompInd:) is a new API without @available attribute`
- ⛔️ `ABI breakage: func IThreeDSDeviceInfoProvider.createThreeDsDataBrowser(threeDSCompInd:) has been added as a protocol requirement`
- ⚠️ `ABI breakage: func IThreeDSDeviceInfoProvider.createThreeDsDataSDK(sdkAppID:sdkEphemPubKey:sdkReferenceNumber:sdkTransID:sdkMaxTimeout:sdkEncData:) is a new API without @available attribute`
- ⛔️ `ABI breakage: func IThreeDSDeviceInfoProvider.createThreeDsDataSDK(sdkAppID:sdkEphemPubKey:sdkReferenceNumber:sdkTransID:sdkMaxTimeout:sdkEncData:) has been added as a protocol requirement`
- ⚠️ `ABI breakage: func IThreeDSDeviceInfoProvider.createThreeDsDataBrowser() is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IDataLoader is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AdditionalData is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IAppBasedSdkUiProvider is a new API without @available attribute`
- ⚠️ `ABI breakage: struct AppBasedSdkUiProvider is a new API without @available attribute`
- ⚠️ `ABI breakage: enum ASDKCoreError is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ClientInfo is a new API without @available attribute`
- ⚠️ `ABI breakage: enum DeviceChannel is a new API without @available attribute`
- ⚠️ `ABI breakage: struct DynamicCodingKey is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IEmailValidator is a new API without @available attribute`
- ⚠️ `ABI breakage: class EmailValidator is a new API without @available attribute`
- ⚠️ `ABI breakage: enum FfdVersion is a new API without @available attribute`
- ⚠️ `ABI breakage: enum FinishAuthorizeDataEnum is a new API without @available attribute`
- ⚠️ `ABI breakage: struct FinishAuthorizeDataWrapper is a new API without @available attribute`
- ⚠️ `ABI breakage: protocol IURLAuthenticationChallenge is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ReceiptFdv1_05 is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ReceiptFdv1_2 is a new API without @available attribute`
- ⚠️ `ABI breakage: enum TdsSdkInterface is a new API without @available attribute`
- ⚠️ `ABI breakage: enum TdsSdkUiType is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ThreeDsDataBrowser is a new API without @available attribute`
- ⚠️ `ABI breakage: struct ThreeDsDataSDK is a new API without @available attribute`
- ⚠️ `ABI breakage: enum ThreeDSDeviceData is a new API without @available attribute`
- ⛔️ `ABI breakage: constructor AcquiringSdkConfiguration.init(credential:server:requestsTimeoutInterval:logger:tokenProvider:urlSessionAuthChallengeService:) has been removed`
- ⛔️ `ABI breakage: constructor AttachCardData.init(cardNumber:expDate:cvv:requestKey:deviceData:) has been removed`
- ⛔️ `ABI breakage: enumelement AttachCardStatus.needConfirmationRandomAmount has been removed`
- ⛔️ `ABI breakage: constructor FinishAuthorizeData.init(paymentId:paymentSource:infoEmail:deviceInfo:threeDSVersion:source:route:) has been removed`
- ⛔️ `ABI breakage: var PaymentInitData.paymentFormData has been removed`
- ⛔️ `ABI breakage: func PaymentInitData.addPaymentData(_:) has been removed`
- ⛔️ `ABI breakage: var Receipt.shopCode has been removed`
- ⛔️ `ABI breakage: var Receipt.email has been removed`
- ⛔️ `ABI breakage: var Receipt.phone has been removed`
- ⛔️ `ABI breakage: var Receipt.taxation has been removed`
- ⛔️ `ABI breakage: var Receipt.items has been removed`
- ⛔️ `ABI breakage: var Receipt.agentData has been removed`
- ⛔️ `ABI breakage: var Receipt.supplierInfo has been removed`
- ⛔️ `ABI breakage: var Receipt.customer has been removed`
- ⛔️ `ABI breakage: var Receipt.customerInn has been removed`
- ⛔️ `ABI breakage: constructor Receipt.init(from:) has been removed`
- ⛔️ `ABI breakage: constructor Receipt.init(shopCode:email:taxation:phone:items:agentData:supplierInfo:customer:customerInn:) has been removed`
- ⛔️ `ABI breakage: struct ThreeDSDeviceInfo has been removed`
- ⛔️ `ABI breakage: func IThreeDSDeviceInfoProvider.createDeviceInfo(threeDSCompInd:) has been removed`
- ⛔️ `ABI breakage: var IThreeDSDeviceInfoProvider.deviceInfo has been removed`