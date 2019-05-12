//
//  NSString+Ext.h
//  AFNetworking
//
//  Created by Lee on 2019/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WLTExt)
//格式化文件大小
+ (NSString *)formatBitSizeWith:(unsigned long long)size;

/**
 md5

 @return md5
 */
- (nullable NSString *)md5;

/**
 获取URL path

 @return path
 */
- (NSString *)urlPath;



/**
 文件存在 返回重命名的文件

 @return 路径
 */
- (NSString *)filePathIfisExitAndRename;
@end


@interface NSDate (WLTExt)

/**
 <#Description#>

 @return <#return value description#>
 */
- (NSString *)formateDate;
@end

NS_ASSUME_NONNULL_END
