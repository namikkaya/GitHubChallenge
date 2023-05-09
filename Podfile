# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GitHubChallenge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  # Pods for GitHubChallenge

  target 'GitHubChallengeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GitHubChallengeUITests' do
    # Pods for testing
  end

  pod 'SnapKit', '~> 5.6.0'
  pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher.git', :commit => 'af4be92'
  pod 'Alamofire'

  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
  end
end
