# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

platform :ios, '8.0'

workspace 'LeanCloudFeedback.xcworkspace'

target 'LeanCloudFeedback' do
    project 'LeanCloudFeedback.xcodeproj'
    pod 'AVOSCloud', '10.1.0'
end

target 'LeanCloudFeedbackDemo' do
    project 'LeanCloudFeedbackDemo/LeanCloudFeedbackDemo.xcodeproj'
    pod 'AVOSCloud', '10.1.0'
    pod 'LeanCloudFeedback', :path => '.'
end
