#
# Be sure to run `pod lib lint BHAddressParser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BHAddressParser'
  s.version          = '0.1.0'
  s.summary          = '智能地址解析器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  1. 能够识别多种结构的地址信息
  2. 兼容解析常用平台App的复制地址信息
  3. 结合NSDataDetector智能高效识别，未直接使用地址库检索
                       DESC

  s.homepage         = 'https://github.com/WWWarehouseMobile/BHAddressParser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '学宝' => 'zhanxuebao@outlook.com' }
  s.source           = { :git => 'git@github.com:WWWarehouseMobile/BHAddressParser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BHAddressParser/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BHAddressParser' => ['BHAddressParser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
