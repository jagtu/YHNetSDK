
Pod::Spec.new do |s|

  s.name         = "YHNetSDK"
  s.version      = "1.0.7"
  s.summary      = "YHNetSDK is only a net sdk"

  s.description  = "YHNetSDK is only a base net sdk, we need pod thirdparty: AFNetworking"

  s.homepage     = "https://github.com/XmYlzYhkj/YHNetSDK"

  s.license      = "MIT "

  s.author       = { "zhengxiaolang" => "haifeng3099@126.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/XmYlzYhkj/YHNetSDK.git", :tag => "1.0.6" }

  #s.source_files  = "Classes", "Classes/*"

  s.source_files = '*.{h,m}'

  s.requires_arc = true

  #s.dependency     "Reachability", "~> 3.2"

  s.dependency     "AFNetworking",  "~> 3.1"

  #s.vendored_frameworks = ["Framework/*.framework"]
  
  end