#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_app_guard.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_app_guard'
  s.version          = '0.0.1'
  
  s.summary          = 'A robust mobile security package for Flutter apps, enhancing resilience against threats like rooting, debugging, and app cloning.'
  
  s.description      = <<-DESC
  The AppGuard Flutter plugin provides a comprehensive suite of mobile security features for Android and iOS applications. It includes functionalities for:
  - Device integrity checks (root/jailbreak detection)
  - Debugging and emulator detection
  - Screenshot prevention
  - App cloning detection
  - And other measures to enhance application resilience and prevent fraud.
  This plugin is designed to help developers build more secure Flutter applications by integrating native platform security capabilities.
                       DESC
  s.homepage         = 'https://github.com/Rgada28/flutter_app_guard/tree/develop' 
  # --- UPDATED: License type changed to BSD-3-Clause ---
  s.license          = { :type => 'BSD-3-Clause', :file => '../LICENSE' }
  s.author           = { 'Raj Gada' => '' }
  s.source           = { :path => '.' } 

  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'DTTJailbreakDetection', '0.4.0'
  s.dependency 'ScreenProtectorKit', '1.3.1'
  s.platform = :ios, '12.0' 

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'app_guard_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
