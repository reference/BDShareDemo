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

#import "BDShare.h"
#import <OpenShare/OpenShare+Weixin.h>

@implementation BDShare

+ (id)ins
{
    static BDShare *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [BDShare new];
    });
    return s;
}

- (BOOL)registerWechatWithAppID:(NSString *)appId linkUrl:(NSString *)linkUrl
{
    //openshare
    [OpenShare connectWeixinWithAppId:appId];
    return [WXApi registerApp:appId universalLink:linkUrl];
}

- (void)shareToWXSesstion:(WXSession)session completion:(void(^)(void))completion;
{
    OSMessage *msg = [OSMessage new];
    msg.title = self.title;
    msg.desc = self.desc;
    msg.link = self.link;
    if (self.image) {
        msg.image = self.image;
    }else if (self.imageUrl.length > 0){
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        msg.image = UIImageCompressToData(img,1024 * 32);
    }
    switch (session) {
        case WXSession_Friend:
        {
            [OpenShare shareToWeixinSession:self.osMessage?self.osMessage:msg Success:^(OSMessage *message) {
                if (completion) {
                    completion();
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
        case WXSession_TimeLine:
        {
            [OpenShare shareToWeixinTimeline:self.osMessage?self.osMessage:msg Success:^(OSMessage *message) {
                if (completion) {
                    completion();
                }
            } Fail:^(OSMessage *message, NSError *error) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
        default:
            break;
    }
}


- (void)shareToMiniProgram
{
    //分享到小程序卡片
    WXMiniProgramObject *wxObj = [WXMiniProgramObject object];
    wxObj.webpageUrl = self.webpageUrl;
    wxObj.userName = self.userName;
    wxObj.path = self.path;
    if (self.image) {
        wxObj.hdImageData = self.image;
    }else if (self.imageUrl.length > 0){
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        wxObj.hdImageData = UIImageCompressToData(img,1024 * 32);
    }
    wxObj.miniProgramType = self.miniProgramType;

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.desc;
    message.mediaObject = wxObj;
    message.thumbData = nil;
        
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req completion:nil];
}

- (void)launchWeChatMiniProgram
{
    
}

#pragma mark - privite

NSData * UIImageCompressToData(UIImage *image, NSUInteger bytes) {
    if (bytes < 1024) {
        bytes = 1024;
        NSLog(@">[COMPRESS] Not less than %d bytes", (int)bytes);
    }
    NSData *data = UIImageJPEGRepresentation(image, 1.f);
    NSLog(@">[IMAGE] size:%@ bytes:%d", NSStringFromCGSize(image.size), (int)data.length);
    int retry = 0;
    while (data.length > bytes) {
        CGFloat quality = (float)bytes / data.length;
        if (quality < 0.1f) {
            quality = 0.1f;
        }
        data = UIImageJPEGRepresentation(image, quality);
        if (data.length > bytes) {
            float scale = (float)bytes / data.length;
            if (scale < 0.1f) {
                scale = 0.1f;
            }
            CGSize size = UIImageSizeToScale(image, scale);
            image = UIImageScaleToSize(image, size);
            data = UIImageJPEGRepresentation(image, 1.f);
        }
        retry++;
    }
    NSLog(@">[COMPRESSED] size:%@ bytes:%d retry:%d",
          NSStringFromCGSize(image.size), (int)data.length, retry);
    return data;
}

CGSize UIImageSizeToScale(UIImage *image, CGFloat scale) {
    CGSize size = image.size;
    if (scale > 0) {
        size.width *= scale;
        size.height *= scale;
    }
    return size;
}

UIImage * UIImageScaleToSize(UIImage *image, CGSize size) {
    UIImage *resized = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}
@end
