# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'VMusic' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
	pod 'Alamofire', '~> 4.5'
	pod 'SDWebImage', '~> 4.0'
   	 pod 'RealmSwift'
    	pod 'ObjectMapper', '~> 3.0'
    	pod 'AlamofireObjectMapper'
    	pod 'MBProgressHUD', '~> 1.0.0'
    	pod 'ICSPullToRefresh', '~> 0.6'
	pod "ObjectMapper+Realm"
	pod 'MaterialActivityIndicator'
	post_install do |installer|
    		installer.pods_project.build_configurations.each do |config|
        		config.build_settings.delete('CODE_SIGNING_ALLOWED')
        		config.build_settings.delete('CODE_SIGNING_REQUIRED')
    		end
	end

  # Pods for VMusic

end
