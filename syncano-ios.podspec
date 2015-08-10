Pod::Spec.new do |s|

  s.name         = "syncano-ios"
  s.version      = "4.0.0"
  s.summary      = "Library for http://syncano.com API"

  s.homepage     = "http://www.syncano.com"
  s.license      = 'MIT'
  s.author       = 'Syncano Inc.'

  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.8"

  s.requires_arc = true

  s.source = { :git => 'https://github.com/Syncano/syncano4-ios.git', :tag => s.version}
  
  s.public_header_files = 'syncano4-ios/*.h'
  s.source_files = 'syncano4-ios/*.{h,m}'

  s.dependency 'AFNetworking', '~> 2.5'
  s.dependency 'Mantle', '~> 2.0'
  s.dependency 'UICKeyChainStore', '~> 2.0'

end