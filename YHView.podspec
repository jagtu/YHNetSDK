
Pod::Spec.new do |s|

  s.name         = "YHView"
  s.version      = "0.0.2”
  s.summary      = "this is a test."

  s.description  = "this is a test sdk this is a test dsdk"

  s.homepage     = "https://github.com/jagtu/YHView.git"


  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "oid" => "42318168@qq.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/jagtu/YHView.git", :tag => “0.0.2” }


  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  s.requires_arc = true

  #s.vendored_frameworks = ["Classes/YHThemeKit.framework"]

end
