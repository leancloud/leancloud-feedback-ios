# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

platform :ios, '8.0'

workspace 'LeanCloudFeedback.xcworkspace'

target 'LeanCloudFeedback' do
    inhibit_all_warnings!
    project 'LeanCloudFeedback.xcodeproj'
    pod 'AVOSCloud', '11.4.9'
end

target 'LeanCloudFeedbackDemo' do
    inhibit_all_warnings!
    project 'LeanCloudFeedbackDemo/LeanCloudFeedbackDemo.xcodeproj'
    pod 'AVOSCloud', '11.4.9'
    pod 'LeanCloudFeedback', :path => '.'
end
