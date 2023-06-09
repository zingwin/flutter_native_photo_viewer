#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_native_photo_viewer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_native_photo_viewer'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
#  s.source_files = 'Classes/**/*'
#  s.public_header_files = 'Classes/**/*.h'
  s.source_files = 'Classes/**/*.{h,m,mm,swift,c}'
  s.resources      = "Classes/YBImageBrowser/**/*.bundle"
  
  s.library = 'stdc++'
  s.dependency 'Flutter'
#  s.dependency 'YBImageBrowser'
#  s.dependency 'YBImageBrowser/Video'
  s.dependency 'SDWebImage',  '>= 5.0.0'
  s.dependency 'YYImage/WebP'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
