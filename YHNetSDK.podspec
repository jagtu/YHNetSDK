
Pod::Spec.new do |s|

  s.name         = "YHNetSDK"

  s.version      = "0.1.1.2"

  s.summary      = "YHNetSDK is only a net sdk"

  s.description  = "YHNetSDK is only a base net sdk, we need pod thirdparty: AFNetworking"

  s.homepage     = "https://github.com/XmYlzYhkj/YHNetSDK.git"

  s.license      = "MIT"

  s.author       = { "jagtu" => "42318168@qq.com" }

  s.platform     = :ios, "9.0"

  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '$(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))',
    'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200' => 'arm64 arm64e armv7 armv7s armv6 armv8'
  }

  s.source       = { :git => "git@gitlab.ylzpay.com:ios/ios_component/YHNetSDK.git", :tag => s.version.to_s }

  s.source_files  = "YHNetSDK/Classes/*"

  s.requires_arc = true

  #s.dependency     "Reachability"

  s.dependency     "AFNetworking",'~> 4.0'

  #s.vendored_frameworks = ["Framework/*.framework"]
  
  end
