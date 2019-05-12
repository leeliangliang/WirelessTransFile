//
//  NSString+Ext.m
//  AFNetworking
//
//  Created by Lee on 2019/4/30.
//

#import "NSString+WLTExt.h"
#import <CommonCrypto/CommonCrypto.h>

const unsigned long long kBitSize_TB_TAG = (unsigned long long)1024 * 1024 * 1024 * 1024;
const unsigned long long kBitSize_GB_TAG = (unsigned long long)1024 * 1024 * 1024;
const unsigned long long kBitSize_MB_TAG = (unsigned long long)1024 * 1024;
const unsigned long long kBitSize_KB_TAG = (unsigned long long)1024;

@implementation NSString (WLTExt)
+ (NSString *)formatBitSizeWith:(unsigned long long)size
{
    NSDecimalNumber *tb_tag;
    NSString *subString;
    if (size >= kBitSize_TB_TAG) {
        tb_tag= [[NSDecimalNumber alloc]initWithUnsignedLongLong:kBitSize_TB_TAG];
        subString = @"TB";
    }else if (size >= kBitSize_GB_TAG){
        tb_tag= [[NSDecimalNumber alloc]initWithUnsignedLongLong:kBitSize_GB_TAG];
        subString = @"GB";
    }else if (size >= kBitSize_MB_TAG){
        tb_tag= [[NSDecimalNumber alloc]initWithUnsignedLongLong:kBitSize_MB_TAG];
        subString = @"MB";
    }else if (size >= kBitSize_KB_TAG){
        tb_tag= [[NSDecimalNumber alloc]initWithUnsignedLongLong:kBitSize_KB_TAG];
        subString = @"KB";
    }else if (size >= 0){
        tb_tag= [[NSDecimalNumber alloc]initWithUnsignedLongLong:1];
        subString = @"B";
    }
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *sizeNum = [[NSDecimalNumber alloc]initWithUnsignedLongLong:size];
    NSDecimalNumber *result = [sizeNum decimalNumberByDividingBy:tb_tag withBehavior:roundUp];
    return [NSString stringWithFormat:@"%.1f%@", [result floatValue], subString];
}
- (nullable NSString *)md5{
    if (!self) return nil;
    
    const char *cStr = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}
- (NSString *)urlPath
{
    return [NSURL URLWithString:self].path;
}

/**
 对文件重命名
  @return 新路径
 */
- (NSString *)filePathIfisExitAndRename{
    if (![[NSFileManager defaultManager] fileExistsAtPath:self]) {
        return self;
    }
    //获取文件名： 视频.MP4
    NSString *lastPathComponent = [self lastPathComponent];
    //获取后缀：MP4
    NSString *pathExtension = [self pathExtension];
    NSString *name = [lastPathComponent stringByDeletingPathExtension];
    //用传过来的路径创建新路径 首先去除文件名
    NSString *pathNew = [self stringByReplacingOccurrencesOfString:lastPathComponent withString:@""];
    //然后拼接新文件名：新文件名为当前的：年月日时分秒 yyyyMMddHHmmss
    NSString *moveToPath = [NSString stringWithFormat:@"%@%@(1).%@",pathNew,name,pathExtension];
    return moveToPath;
}
@end

@implementation NSDate (WLTExt)
- (NSString *)formateDate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:self];
}
@end
