#
# Be sure to run `pod lib lint LWHero.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'LWHero'
  s.version          = '1.0.0'
  s.summary          = 'A Swift/SwiftUI Hero animation framework for iOS.'

  s.description      = <<-DESC
LWHero is a Swift port of LWHeroOC, providing elegant view controller transitions
and animations similar to Keynote's Magic Move effect. Built with modern Swift
patterns and SwiftUI support.
                       DESC

  s.homepage         = 'https://github.com/luowei/LWHero'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWHero.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'LWHero/Classes/**/*'

  s.frameworks = 'UIKit', 'QuartzCore'
end
