//
//  WLTConnectPwdManager.h
//  AFNetworking
//
//  Created by Lee on 2019/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLTConnectPwdManager : NSObject
@property (nonatomic,readonly)NSString *connectPwd;
@property (nonatomic,readonly)NSString *connectPwdMd5;

/**
 初始化

 @return id
 */
+ (instancetype)sharedInstance;

/**
 重置密码
 */
+ (void)reset;
@end

NS_ASSUME_NONNULL_END
