Pod::Spec.new do |s|

  s.name         = 'BRStyle'
  s.version      = '0.9.4'
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

  s.default_subspecs = 'All'
  
  s.subspec 'All' do |sp|
    sp.source_files = 'BRStyle/Code/BRStyle.h'
    sp.dependency 'BRStyle/Core'
	sp.dependency 'BRStyle/UIBarButtonItem'
	sp.dependency 'BRStyle/UIButton'
	sp.dependency 'BRStyle/UINavigationBar'
	sp.dependency 'BRStyle/UIToolbar'
  end
  
  s.subspec 'Core' do |sp|
    sp.source_files = 'BRStyle/Code/Core.h', 'BRStyle/Code/Core'
  end
  
  s.subspec 'UIBarButtonItem' do |sp|
    sp.source_files = 'BRStyle/Code/UIBarButtonItem'
    sp.dependency 'BRStyle/Core'
  end

  s.subspec 'UIButton' do |sp|
    sp.source_files = 'BRStyle/Code/UIButton'
    sp.dependency 'BRStyle/Core'
  end

  s.subspec 'UINavigationBar' do |sp|
    sp.source_files = 'BRStyle/Code/UINavigationBar'
    sp.dependency 'BRStyle/Core'
  end

  s.subspec 'UIToolbar' do |sp|
    sp.source_files = 'BRStyle/Code/UIToolbar'
    sp.dependency 'BRStyle/Core'
  end

end
