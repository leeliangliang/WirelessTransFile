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
@end
