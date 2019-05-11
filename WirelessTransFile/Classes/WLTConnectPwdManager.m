//
//  WLTConnectPwdManager.m
//  AFNetworking
//
//  Created by Lee on 2019/5/11.
//

#import "WLTConnectPwdManager.h"
#import "NSString+WLTExt.h"

@implementation WLTConnectPwdManager
{
    NSString *_pwd;
    NSString *_md5;
}
+ (instancetype)sharedInstance {
    static WLTConnectPwdManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [WLTConnectPwdManager new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}
- (void)reset
{
    _pwd = [NSString stringWithFormat:@"%06d",arc4random_uniform(1000000)];
    _md5 = nil;
}
+ (void)reset
{
    [[WLTConnectPwdManager sharedInstance] reset];
}
#pragma mark --lazy

- (NSString *)connectPwd{
    if(!_pwd){
        [self reset];
    }
    return _pwd;
}
- (NSString *)connectPwdMd5{
    if (!_md5) {
        _md5 = [_pwd md5];
    }
    return _md5;
}
@end
