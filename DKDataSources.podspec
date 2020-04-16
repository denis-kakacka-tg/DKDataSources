#
# Be sure to run `pod lib lint DKDataSources.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DKDataSources'
  s.version          = '1.0.0'
  s.summary          = 'Data driven DataSource allowing use of multiple cell types in elegant way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Data driven generic table/collection view DataSources, allows to use multiple cell types in one or multiple sections.
                       DESC

  s.homepage         = 'https://github.com/deniskakacka/DKDataSources'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Denis Kakačka' => 'dkakacka@gmail.com' }
  s.source           = { :git => 'https://github.com/deniskakacka/DKDataSources.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/dkreationsapps'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DKDataSources/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DKDataSources' => ['DKDataSources/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
