//
//  WLTHTTPConnection.m
//  AFNetworking
//
//  Created by Lee on 2019/4/25.
//

#import "WLTHTTPConnection.h"
#import <CocoaHTTPServer/HTTPAsyncFileResponse.h>

@implementation WLTHTTPConnection
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    // Use HTTPConnection's filePathForURI method.
    // This method takes the given path (which comes directly from the HTTP request),
    // and converts it to a full path by combining it with the configured document root.
    //
    // It also does cool things for us like support for converting "/" to "/index.html",
    // and security restrictions (ensuring we don't serve documents outside configured document root folder).
    if ([path hasPrefix:@"/-_-"]) {
        NSString *newPath = [path substringFromIndex:4];
        NSString *filePath = [self filePathForURI:newPath];
        return [[HTTPAsyncFileResponse alloc]initWithFilePath:filePath forConnection:self];
    }
    NSDictionary *param = [self parseGetParams];
    
    // Convert to relative path
    NSObject<HTTPResponse> * response = [super httpResponseForMethod:method URI:path];
    return response ?:[[HTTPAsyncFileResponse alloc]initWithFilePath:[self filePathForURI:@"/404.html"] forConnection:self];
}

@end
