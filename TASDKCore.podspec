Pod::Spec.new do |spec|
  spec.name = 'TASDKCore'
  spec.version = '8.2.0'
  spec.summary = 'Мобильный SDK'
  spec.description = 'Позволяет настроить прием платежей в нативной форме приложений для платформы iOS'
  spec.homepage = 'https://www.tinkoff.ru/kassa'
  spec.license = { type: 'Apache 2.0', file: 'TinkoffASDKCore/License.txt' }
  spec.author = 'APW MBPay'
  spec.platform = :ios
  spec.module_name = 'TinkoffASDKCore'
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '13.0'
  spec.static_framework = true
  spec.source_files = 'TinkoffASDKCore/TinkoffASDKCore/**/*.swift'
  spec.source = {
    git: 'https://opensource.tbank.ru/mobile-tech/asdk-ios.git',
    tag: 'release/january-2025'
  }
  spec.resource_bundles = {
    'TinkoffASDKCoreResources' => ['TinkoffASDKCore/TinkoffASDKCore/**/*.{lproj,strings,der,xcprivacy}']
  }
  spec.pod_target_xcconfig = {
    'CODE_SIGN_IDENTITY' => ''
  }
end
