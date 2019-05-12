//
//  HTTPMessage+Ext.m
//  AFNetworking
//
//  Created by Lee on 2019/5/12.
//

#import "HTTPMessage+Ext.h"
#import "WLTConnectPwdManager.h"

@implementation HTTPMessage (WLTExt)
- (BOOL)authCookieForUserLogin{
    NSString *cookie = [self headerField:@"Cookie"];
    if (@available(iOS 8.0, *)) {
        return [cookie containsString:[WLTConnectPwdManager sharedInstance].connectPwdMd5];
    } else {
        // Fallback on earlier versions
        return [cookie rangeOfString:[WLTConnectPwdManager sharedInstance].connectPwdMd5].location != NSNotFound;
    }
}
@end
