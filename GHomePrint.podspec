

Pod::Spec.new do |s|


  s.name         = "GHomePrint"
  s.version      = "1.0.0"
  s.summary      = "屏幕调试,输出log"

  s.description  = <<-DESC
  屏幕调试,输出log
                   DESC

  s.homepage     = "https://github.com/shabake/GHomePrintDemo"
  s.license        = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "shabake" => "45329453@qq.com" }

  s.source       = { :git => "https://github.com/shabake/GHomePrintDemo.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '9.0'

  s.source_files  =  "GHomePrint/**/*"



end
