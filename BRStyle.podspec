Pod::Spec.new do |s|

  s.name         = 'BRStyle'
  s.version      = '0.9.1'
  s.summary      = 'Basic color and font style framework for UIKit.'

  s.description        = <<-DESC
                         BRStyle provides a basic style framework for application-wide
                         colors and fonts. It aims to make it easy to define a global
                         style for your application, in a simple way.
                         DESC

  s.homepage           = 'https://github.com/Blue-Rocket/BRStyle'
  s.license            = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author             = { 'Matt Magoffin' => 'matt@bluerocket.us' }
  s.social_media_url   = 'http://twitter.com/bluerocketinc'
  s.platform           = :ios, '7.1'
  s.source             = { :git => 'https://github.com/Blue-Rocket/BRStyle.git', 
                           :tag => s.version.to_s }
  
  s.requires_arc       = true

  s.default_subspecs = 'Core'
  
  s.subspec 'All' do |sp|
    sp.source_files = 'BRStyle/Code/BRStyle.h'
    sp.dependency 'BRStyle/Core'
    sp.dependency 'BRStyle/RestKit'
  end
  
  s.subspec 'Core' do |sp|
    sp.source_files = 'BRStyle/Code/Core.h', 'BRStyle/Code/Core'
  end
  
  s.subspec 'RestKit' do |sp|
    sp.source_files = 'BRStyle/Code/RestKit.h', 'BRStyle/Code/RestKit'
    sp.dependency 'RestKit/ObjectMapping', '~> 0.24'
    sp.dependency 'MAObjCRuntime',         '~> 0.0.1'
    sp.ios.frameworks = 'MobileCoreServices'
  end

end
