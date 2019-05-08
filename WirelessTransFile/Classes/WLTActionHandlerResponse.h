//
//  WLTActionResponse.h
//  AFNetworking
//
//  Created by Lee on 2019/4/28.
//
#import <CocoaHTTPServer/HTTPDataResponse.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLTActionHandlerResponse : HTTPDataResponse
@property (nonatomic, copy, readonly) NSDictionary *param;
- (instancetype)initWithParams:(NSDictionary *)params withUriPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
