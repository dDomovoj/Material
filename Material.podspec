Pod::Spec.new do |s|
  s.name         = "Material"
  s.version      = "0.1.0"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.summary      = "Utility components"
  s.homepage     = "https://github.com/dDomovoj/Material"
  s.author       = "dDomovoj"
  s.source       = { :git => "https://github.com/dDomovoj/Material.git", :tag => s.version }
  s.ios.deployment_target = "9.0"
end
