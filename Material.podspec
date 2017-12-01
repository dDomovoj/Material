Pod::Spec.new do |s|
  s.name         = "Material"
  s.version      = "0.1.0"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.summary      = "Material components"
  s.homepage     = "https://github.com/dDomovoj/Material"
  s.author       = { 'Dmitry Duleba' => 'dmitryduleba@gmail.com' }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/dDomovoj/Material.git", :tag => s.version }
  s.source_files = 'Material/Source/**/*.{swift}'

  s.framework = "UIKit"
  s.framework = "Foundation"
end
