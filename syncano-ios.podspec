Pod::Spec.new do |s|

  s.name         = "syncano-ios"
  s.version      = "4.0.18”
  s.summary      = "Library for http://syncano.com API"

  s.homepage     = "http://www.syncano.com"
  s.license      = 'MIT'
  s.author       = 'Syncano Inc.'

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"

  s.requires_arc = true

  s.source = { :git => 'https://github.com/Syncano/syncano-ios.git', :tag => s.version}
  
  s.public_header_files = 'syncano-ios/*.h'
  s.source_files = 'syncano-ios/*.{h,m}'
  s.resources = 'syncano-ios/certfile.der'

  s.dependency 'AFNetworking', '~> 3.0.0'
  s.dependency 'Mantle', '~> 2.0'
  s.dependency 'UICKeyChainStore', '~> 2.0'
  s.dependency 'FMDB', '2.6'

end
