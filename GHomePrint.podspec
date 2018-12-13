

Pod::Spec.new do |s|


  s.name         = "GHomePrint"
  s.version      = "1.0.1"
  s.summary      = "屏幕调试,输出log1"

  s.description  = <<-DESC
  屏幕调试,输出log 测试用
                   DESC

  s.homepage     = "https://github.com/shabake/GHomePrintDemo"
  s.license        = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "shabake" => "45329453@qq.com" }

  s.source       = { :git => "https://github.com/shabake/GHomePrintDemo.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files  =  "GHomePrint/**/*"



end
