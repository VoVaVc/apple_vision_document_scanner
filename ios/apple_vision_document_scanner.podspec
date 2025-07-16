#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint apple_vision_document_scanner.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'apple_vision_document_scanner'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to scan documents with apple VisionKit'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vlad Pavlov' => 'https://github.com/VoVaVc' }
  s.source           = { 
    :path => '.',
    :git => "https://github.com/VoVaVc/apple_vision_document_scanner.git"
  }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'apple_vision_document_scanner_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
