//
//  NSString+Ext.h
//  AFNetworking
//
//  Created by Lee on 2019/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WLTExt)
+ (NSString *)formatBitSizeWith:(unsigned long long)size;

- (nullable NSString *)md5;
@end

NS_ASSUME_NONNULL_END
