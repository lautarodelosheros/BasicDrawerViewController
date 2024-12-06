#
# Be sure to run `pod lib lint BasicDrawerViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BasicDrawerViewController'
  s.version          = '0.5.1'
  s.summary          = 'A simple Android-like Drawer implementation for iOS.'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
A simple Android-like Drawer implementation for iOS.
                       DESC

  s.homepage         = 'https://github.com/lautarodelosheros/BasicDrawerViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lautaro de los Heros' => 'lautarodelosheros@gmail.com' }
  s.source           = { :git => 'https://github.com/lautarodelosheros/BasicDrawerViewController', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/BasicDrawerViewController/Classes/**/*'
  
  s.resource_bundles = {
    'BasicDrawerViewControllerBundle' => ['Sources/BasicDrawerViewController/Assets/**/*']
  }
  
end
