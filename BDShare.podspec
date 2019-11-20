#
#  Be sure to run `pod spec lint BDShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "BDShare"
    s.version      = "0.0.2"
    s.summary      = "social share for wechat.include payment and so on."
    s.description  = "social share for wechat.include payment and so on."
    s.homepage     = "https://github.com/reference"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Scott Ban" => "imti_bandianhong@126.com" }
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/reference/BDShareDemo.git", :tag => "#{s.version}" }

    s.frameworks = "UIKit", "Foundation"
    s.library = "WechatOpenSDK"
    s.requires_arc = true

    s.source_files  =  "BDShareDemo/BDShare/BDShareHeader.h"
    s.public_header_files = "BDShareDemo/BDShare/BDShareHeader.h"

    s.dependency "OpenShare"

    s.subspec "BDShare" do |ss|
        ss.source_files  = "BDShareDemo/BDShare/BDShare/*.{h,m}"
        ss.public_header_files = "BDShareDemo/BDShare/BDShare/*.h"
    end
    
end
