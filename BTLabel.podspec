#
# Be sure to run `pod lib lint BTLabel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BTLabel"
  s.version          = "1.0.0"
  s.summary          = "UILabel subclass with vertical text alignment, insets and height calculation."
  s.homepage         = "https://github.com/bteapot/BTLabel"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Денис Либит" => "bteapot@me.com" }
  s.source           = { :git => "https://github.com/bteapot/BTLabel.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'BTLabel' => ['Pod/Assets/*.png']
  }
end
