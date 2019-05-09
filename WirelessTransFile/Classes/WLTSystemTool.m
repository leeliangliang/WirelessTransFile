//
//  TEst.m
//  AFNetworking
//
//  Created by Lee on 2019/4/29.
//
#import "WLTSystemTool.h"
#import "NSString+WLTExt.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

static const NSString *kWLTFilePathNameKey = @"com.leeliang.WirelessTransFile";
#define IOS_WIFI        @"en0"

@implementation WLTSystemTool

//获取所有相关IP信息
+ (NSString *) WLT_getIPAddresses
{
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                if (![name isEqualToString:IOS_WIFI])
                {
                    //如果那不是WiFi
                    continue;
                }
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        return [NSString stringWithUTF8String:addrBuf];
                    }
                }
                //                else {
                //                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                //                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                //
                //                    }
                //            }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return nil;
}

/**
 *  总的空间
 */
+ (NSNumber*) WLT_totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];

    return [fattributes objectForKey:NSFileSystemSize];
}

/**
 *  剩余空间
 */
+ (NSNumber*) WLT_freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];

    return [fattributes objectForKey:NSFileSystemFreeSize];
}
+ (NSString *)WLT_fileRootPath
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES).firstObject;
    NSString *rootPath = [cachePath stringByAppendingPathComponent:[kWLTFilePathNameKey copy]];
    return rootPath;
}
+ (NSArray *)WLT_getFileInfoFromPath:(NSString *)path
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [[self WLT_fileRootPath] stringByAppendingPathComponent:path];
    BOOL isdir;
    if (!([fileManager fileExistsAtPath:dirPath isDirectory:&isdir] && isdir)){
        //不存在或者不是文件夹 创建文件
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return nil;
        }
    }
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
    NSMutableArray *fileInfoArray = [NSMutableArray arrayWithCapacity:filesArray.count];
    BOOL isDir = NO;
    if (!error)
    {
        for (NSString *fPath in filesArray) {
            NSString *filepath = [dirPath stringByAppendingPathComponent:fPath];
            BOOL exit = [fileManager fileExistsAtPath:filepath isDirectory:(&isDir)];
            if(exit && !isDir){
                NSString *fileName = [dirPath lastPathComponent];
                NSMutableDictionary *fileInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:fPath,@"PATH",fileName,@"NAME",@"FILE",@"KIND",nil];
                NSError *attriError;
                NSDictionary *fileAttri = [fileManager attributesOfItemAtPath:filepath error:&attriError];
                if (!attriError) {
                    [fileInfo setObject:[NSString formatBitSizeWith:[fileAttri fileSize]] forKey:@"SIZE"];
                }
                [fileInfoArray addObject:fileInfo];
            }
        }
    }
    return fileInfoArray;
}
@end
