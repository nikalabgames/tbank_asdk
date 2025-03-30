Pod::Spec.new do |spec|
  spec.name = 'TASDKUI'
  spec.version = '6.2.1'
  spec.summary = 'Мобильный SDK'
  spec.description = 'Позволяет настроить прием платежей в нативной форме приложений для платформы iOS'
  spec.homepage = 'https://www.tinkoff.ru/kassa'
  spec.license = { type: 'Apache 2.0', file: 'TinkoffASDKUI/License.txt' }
  spec.author = 'APW MBPay'
  spec.platform = :ios
  spec.module_name = 'TinkoffASDKUI'
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '13.0'
  spec.static_framework = true
  spec.source_files = 'TinkoffASDKUI/TinkoffASDKUI/**/*.swift'
  spec.source = {
    git: 'https://opensource.tbank.ru/mobile-tech/asdk-ios.git',
    tag: 'release/january-2025'
  }
  spec.resources = [
    'ThirdParty/TdsSdkIos.xcframework/ios-arm64/TdsSdkIos.framework/TdsSdkIosResources.bundle',
    'ThirdParty/ThreeDSWrapper.xcframework/ios-arm64/ThreeDSWrapper.framework/ThreeDSWrapperResources.bundle'
  ]
  spec.resource_bundles = {
    'TinkoffASDKUIResources' => ['TinkoffASDKUI/TinkoffASDKUI/**/*.{lproj,strings,xib,xcassets,imageset,png}']
  }
  spec.pod_target_xcconfig = {
    'CODE_SIGN_IDENTITY' => ''
  }
  spec.dependency 'TASDKCore'
  spec.vendored_frameworks = ['ThirdParty/**/*.{xcframework}']
end
