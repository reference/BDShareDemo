/**
 MIT License
 
 Copyright (c) 2018 Scott Ban (https://github.com/reference/BDShare)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenShare/OpenShare.h>
#import "WXApi.h"

typedef enum {
    WXSession_Friend = 0,
    WXSession_TimeLine
}WXSession;

NS_ASSUME_NONNULL_BEGIN

@interface BDShare : NSObject

/**
 if this is set other property is not available
 */
@property (nonatomic, strong) OSMessage *osMessage;

/**
 title
 */
@property (nonatomic, strong) NSString *title;

/**
 desc
 */
@property (nonatomic, strong) NSString *desc;

/**
 link
 */
@property (nonatomic, strong) NSString *link;

/**
 image url and image can only one be exsit. share with wechat mini program
 */
@property (nonatomic, strong) NSString *imageUrl;

/**
  image url and image can only one be exsit. share with wechat mini program
 */
@property (nonatomic, strong) NSData *image;

/**
 path for wechat mini program
 */
@property (nonatomic, strong) NSString *path;

/**
 userName for wechat mini program
 */
@property (nonatomic, strong) NSString *userName;

/**
 miniProgramType
 */
@property (nonatomic, assign) WXMiniProgramType miniProgramType;

/**
 web page url for wechat mini program
 */
@property (nonatomic, strong) NSString *webpageUrl;

/**
 instance
 */
+ (id)ins;

/**
 register wechat and Openshare
 */
- (BOOL)registerWechatWithAppID:(NSString *)appId linkUrl:(NSString *)linkUrl;

/**
 share to wechat
 */
- (void)shareToWXSesstion:(WXSession)session completion:(void(^)(void))completion;

/**
 share to wechat mini program with card style
 */
- (void)shareToMiniProgram;

/**
 launch wechat mini program
 */
- (void)launchWeChatMiniProgram;

@end

NS_ASSUME_NONNULL_END
