//
//  WLTFileManager.h
//  AFNetworking
//
//  Created by Lee on 2019/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLTFileManager : NSObject

@property (nonatomic, readonly)BOOL isRuning;
/**
 @return 单例
 */
+ (instancetype)sharedInstance;
/**
 开启http服务

 @return 是否开启成功
 */
+ (BOOL)startServer;

+ (void)stopServer;
+ (NSString *)ipAddress;
+ (NSString *)serverUrl;
@end

NS_ASSUME_NONNULL_END
