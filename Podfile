source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift or 8.0+
use_frameworks!

# xcodeproj is deprecated in 1.0 and has been renamed to project. For pre-1.0 versions use xcodeproj.

workspace 'Demo_SSDP.xcworkspace'

xcodeproj 'SSDP_Client/SSDP_Client.xcodeproj'
xcodeproj 'SSDP_Service/SSDP_Service.xcodeproj'

def shared_pods
pod 'CocoaAsyncSocket'  
end


target 'SSDP_Client' do
	xcodeproj 'SSDP_Client/SSDP_Client.xcodeproj'
	shared_pods
end

target 'SSDP_Service' do
	xcodeproj 'SSDP_Service/SSDP_Service.xcodeproj'
	shared_pods
end