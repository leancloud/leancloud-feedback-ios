# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'LeanCloudFeedback.xcworkspace'

platform :ios, '6.0'

target 'LeanCloudFeedback' do
    xcodeproj 'LeanCloudFeedback.xcodeproj'
    pod 'AVOSCloud', '~> 3.1.4'
end

target 'LeanCloudFeedbackDemo' do
    
    xcodeproj 'LeanCloudFeedbackDemo/LeanCloudFeedbackDemo.xcodeproj'
    pod 'AVOSCloud', '~> 3.1.4'
    pod 'LeanCloudFeedback', :path => '.'
end
