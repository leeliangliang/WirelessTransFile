//
//  WLTActionResponse.m
//  AFNetworking
//
//  Created by Lee on 2019/4/28.
//

#import "WLTActionHandlerResponse.h"
#import "WLTSystemTool.h"
#import <CocoaHTTPServer/HTTPMessage.h>
#import "WLTConnectPwdManager.h"
#import "NSString+WLTExt.h"

@interface WLTActionHandlerResponse ()
{
    NSString *_set_cookie;
}
@property (nonatomic, copy, readwrite) NSDictionary *param;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, weak) HTTPMessage *httpMessage;
@end

@implementation WLTActionHandlerResponse
- (instancetype)initWithParams:(NSDictionary *)params withUriPath:(NSString *)path message:(HTTPMessage *)msg
{
    if(self = [super initWithData:nil])
    {
        self.param = params;
        self.path = [NSURL URLWithString:path].path;
        self.httpMessage = msg;
        [self _transformJsonDataWith:[self _handlerRequest]];
    }
    return self;
}

- (NSDictionary *)_handlerRequest{
    NSString *action = self.param[@"action"];
    if([action isEqualToString:@"Auth"])
    {
        if ([self.param[@"authcode"] isEqualToString:[WLTConnectPwdManager sharedInstance].connectPwd]) {
            _set_cookie =  [NSString stringWithFormat:@"pwd=%@;wifiLoading=true;", [WLTConnectPwdManager sharedInstance].connectPwdMd5];
            return [self _responseSucessDictWith:nil];
        }
        return nil;
    }
    NSString *cookie = [self.httpMessage headerField:@"Cookie"];
    if ([cookie containsString:[WLTConnectPwdManager sharedInstance].connectPwdMd5])
    {
        if([action isEqualToString:@"Browse"])
        {
            return [self _responseSucessDictWith:nil];
        }
    }
    return nil;
}
- (NSDictionary *)_responseSucessDictWith:(NSDictionary *)dict{
    NSMutableDictionary *resData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"RESULT",[WLTSystemTool WLT_freeDiskSpace],@"DISKSPACE",nil];
    [resData setObject:@[@"videos", @"musics", @"picture", @"documents", @"skins", @"compressed", @"others"] forKey:@"BASICDIRS"];
    [resData setObject:[WLTSystemTool WLT_getFileInfoFromPath:self.path]?:@[] forKey:@"FILES"];
    [resData setObject:self.path forKey:@"CURRENTPATH"];
    if(dict){
        [resData addEntriesFromDictionary:dict];
    }
    return resData;
}
- (void)_transformJsonDataWith:(NSDictionary *)dict{
    
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
    if (isYes) {
        /* JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.
         */
        data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    }
}
- (NSDictionary *)httpHeaders
{
    if (_set_cookie)
    {
        return @{@"Set-Cookie":_set_cookie};
    }
    return nil;
}
- (void)connectionDidClose{
    _set_cookie = nil;
}
@end
