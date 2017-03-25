#
# Be sure to run `pod lib lint JDCHorizontalTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'JDCHorizontalTableView'
s.version          = '0.1.0'
s.summary          = 'A horizontal tableview implementation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
 A simple UITableView horizontal version which provides UIKit like interfaces. Easy to use. :) Checkout the demo for details.
DESC

s.homepage         = 'https://github.com/nightwolf-chen/JDCHorizontalTableView'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Jiong Chen' => 'jidongchen93@gmail.com' }
s.source           = { :git => 'https://github.com/nightwolf-chen/JDCHorizontalTableView.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '5.0'

s.source_files = 'JDCHorizontalTableView/Classes/**/*'

# s.resource_bundles = {
#   'JDCHorizontalTableView' => ['JDCHorizontalTableView/Assets/*.png']
# }

s.public_header_files = 'JDCHorizontalTableView/Classes/include/*.h'
s.frameworks = 'UIKit'
# s.dependency 'AFNetworking', '~> 2.3'
end

