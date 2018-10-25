#
# Be sure to run `pod lib lint Bonsai.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Bonsai'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight logging library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Bonsai is a lightweight logging library with support for multiple outputs, custom drivers, log levels (with emojis 🎉), debug focus mode and a handy string extension.

                       DESC

  s.homepage         = 'https://github.com/jamesruston/Bonsai'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jamesruston' => 'jruston90@gmail.com' }
  s.source           = { :git => 'https://github.com/jamesruston/Bonsai.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Bonsai/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Bonsai' => ['Bonsai/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
