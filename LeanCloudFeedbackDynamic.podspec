Pod::Spec.new do |s|

  s.name     = "LeanCloudFeedbackDynamic"
  s.version  = "0.1.1"
  s.platform = :ios, "8.0"
  s.summary  = "LeanCloud iOS SDK for mobile backend."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/docs/feedback.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }
  s.source   = { :git => "https://github.com/leancloud/leancloud-feedback-ios.git", :tag => s.version.to_s }

  s.source_files        = "LeanCloudFeedback/**/*.{h,m}"
  s.public_header_files = "LeanCloudFeedback/**/*.h"
  s.resources           = "LeanCloudFeedback/resources/*.{png,strings}"

  s.dependency 'AVOSCloudDynamic'

  s.xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" => "\"${PODS_ROOT}/AVOSCloudDynamic/**\"",
      "OTHER_LDFLAGS" => "$(inherited) -ObjC -framework AVOSCloud",
  }
end
