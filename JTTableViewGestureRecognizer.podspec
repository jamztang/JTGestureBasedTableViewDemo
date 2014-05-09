Pod::Spec.new do |s|
  s.name         = "JTTableViewGestureRecognizer"
  s.version      = "0.0.1"
  s.summary      = "An iOS objective-C library template to recreate the gesture based interaction found from Clear for iPhone app."
  s.homepage     = "https://github.com/jamztang/JTGestureBasedTableViewDemo"
  s.license      = { :type => "MIT", :file => "JTGestureBasedTableView/LICENSE" }
  s.author       = "James Tang"
  s.platform     = :ios, "6.1"
  s.source       = { :git => "https://github.com/jamztang/JTGestureBasedTableViewDemo.git", :tag => "#{s.version}" }
  s.source_files = "JTGestureBasedTableView/JTTableViewGestureRecognizer.{h,m}"
  s.requires_arc = true
end
