#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "osmscout-router"
  s.version          = "0.1.0"
  s.summary          = "Uses osxscout to generate an offline map route."
  s.description      = <<-DESC
                        Uses osxscout to generate an offline map route
                       DESC
  s.license          = 'MIT'
  s.author           = { "Nicholas Kostelnik" => "nkostelnik@gmail.com" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NAME'
  s.source_files = 'Classes'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'osmscout'
end
