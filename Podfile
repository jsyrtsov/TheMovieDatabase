# Uncomment the next line to define a global platform for your project
# platform :ios

# ignore all warnings from all pods
inhibit_all_warnings!

target 'TheMovieDatabase' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TheMovieDatabase

pod 'Nuke', '~> 8.2.0'
pod 'RealmSwift', '~> 3.18.0'
pod 'YoutubeDirectLinkExtractor', :path => 'Vendor/YoutubeDirectLinkExtractor'
pod 'ExpandableLabel', '~> 0.5.2'
pod 'Locksmith', '~> 4.0.0'

  target 'TheMovieDatabaseTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end