Pod::Spec.new do |s|
  s.name               = "GESlider"
  s.version            = "0.2"
  s.requires_arc       = true
  s.summary            = "Another Slider (stepable, range slider)"

  s.homepage           = "https://github.com/343max/GESlider"
  s.license            = { :type => "BSD", :file => "LICENSE" }
  s.author             = { "Max von Webel" => "max@343max.de" }
  s.social_media_url   = "http://twitter.com/343max"
  s.platform           = :ios, "7.0"
  s.source             = { :git => "https://github.com/343max/GESlider.git", :tag => "0.1" }
  s.source_files       = "Slider/GESlider/*.{h,m}"
  s.resources          = "Slider/Assets/*.png"
end
