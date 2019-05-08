//
//  NSString+Ext.m
//  AFNetworking
//
//  Created by Lee on 2019/4/30.
//

#import "NSString+WLTExt.h"
const unsigned long long kBitSize_TB_TAG = (unsigned long long)1024 * 1024 * 1024 * 1024;
const unsigned long long kBitSize_GB_TAG = (unsigned long long)1024 * 1024 * 1024;
const unsigned long long kBitSize_MB_TAG = (unsigned long long)1024 * 1024;
const unsigned long long kBitSize_KB_TAG = (unsigned long long)1024;

@implementation NSString (WLTExt)
+ (NSString *)formatBitSizeWith:(unsigned long long)size
{
    if (size >= kBitSize_TB_TAG) {
        
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
        NSDecimalNumber *sizeNum = [[NSDecimalNumber alloc]initWithUnsignedLongLong:size];
        NSDecimalNumber *tb_tag = [[NSDecimalNumber alloc]initWithUnsignedLongLong:kBitSize_TB_TAG];
        NSDecimalNumber *result = [tb_tag decimalNumberByDividingBy:sizeNum withBehavior:roundUp];
        return [NSString stringWithFormat:@"%.1f", [result floatValue]];
    }
    return nil;
}
@end
