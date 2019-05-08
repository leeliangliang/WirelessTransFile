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
        return [NSString stringWithFormat:@"%.1f",size/kBitSize_TB_TAG];
    }
    return nil;
}
@end
