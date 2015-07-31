Pod::Spec.new do |s|
  s.name             = "BTLabel"
  s.version          = "1.1.2"
  s.summary          = "UILabel subclass with vertical text alignment, insets and height calculation."
  s.homepage         = "https://github.com/bteapot/BTLabel"
  s.screenshots      = "http://i.imgur.com/h9YfnlC.png"
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
