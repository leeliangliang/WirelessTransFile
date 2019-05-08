//
//  NetworkTool.h
//  Pods
//
//  Created by Lee on 2019/4/25.
//

#import <Foundation/Foundation.h>

@interface WLTSystemTool : NSObject
+ (NSString *) WLT_getIPAddresses;
+ (NSNumber*) WLT_totalDiskSpace;
+ (NSNumber*) WLT_freeDiskSpace;
+ (NSString *)WLT_fileRootPath;//当前文件的目录
+ (NSArray *)WLT_getFileInfoFromPath:(NSString *)path;
@end
