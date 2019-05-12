//
//  HTTPMessage+Ext.h
//  AFNetworking
//
//  Created by Lee on 2019/5/12.
//

#import <CocoaHTTPServer/HTTPMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPMessage (WLTExt)
- (BOOL)authCookieForUserLogin;
@end

NS_ASSUME_NONNULL_END
