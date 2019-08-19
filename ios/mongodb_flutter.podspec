#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'mongodb_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Mongodb Mobile for Flutter'
  s.description      = <<-DESC
Mongodb Mobile
                       DESC
  s.homepage         = 'https://github.com/amondnet/mongodb_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Minsu Lee' => 'amond@amond.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'


  s.dependency 'StitchSDK', '= 6.0.1'
  s.static_framework = true
  s.ios.deployment_target = '11.0'
end

