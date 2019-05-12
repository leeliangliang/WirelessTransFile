//
//  WLTHTTPConnection.m
//  AFNetworking
//
//  Created by Lee on 2019/4/25.
//

#import "WLTHTTPConnection.h"
#import <CocoaHTTPServer/HTTPFileResponse.h>
#import <CocoaHTTPServer/HTTPAsyncFileResponse.h>
#import "WLTActionHandlerResponse.h"
#import <CocoaHTTPServer/HTTPMessage.h>

#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"
#import "WLTSystemTool.h"
#import "HTTPMessage+Ext.h"
#import "NSString+WLTExt.h"

@interface WLTHTTPConnection ()
{
    MultipartFormDataParser*        parser;
    NSFileHandle*                   storeFile;
}
@end
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
        return [[HTTPFileResponse alloc]initWithFilePath:filePath forConnection:self];
    }
    NSDictionary *param = [self parseGetParams];
    if (param){
        if ([param[@"action"] isEqualToString:@"Download"]) {
            NSString* downFilePath = [[WLTSystemTool WLT_fileRootPath] stringByAppendingPathComponent:[path urlPath]];
            return [[HTTPAsyncFileResponse alloc] initWithFilePath:downFilePath forConnection:self];
        }
       return [[WLTActionHandlerResponse alloc] initWithParams:param withUriPath:path message:request];
    }
    // Convert to relative path
    NSObject<HTTPResponse> * response = [super httpResponseForMethod:method URI:path];
    return response ?:[[HTTPFileResponse alloc]initWithFilePath:[self filePathForURI:@"/404.html"] forConnection:self];
}

#pragma mark  -- MultipartFormData


- (BOOL)isMultipartFormDataRequestWith:(NSString *)method atPath:(NSString *)path
{
    NSDictionary *param = [self parseGetParams];
    if ([method isEqualToString:@"POST"] && [param[@"action"] isEqualToString:@"upload"])
    {
        return YES;
    }
    return NO;
}
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    // Add support for POST
    if ([self isMultipartFormDataRequestWith:method atPath:path])
    {
        return YES;
    }
    
    return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
    // Inform HTTP server that we expect a body to accompany a POST request
    
    if ([self isMultipartFormDataRequestWith:method atPath:path] && [request authCookieForUserLogin]){
        // here we need to make sure, boundary is set in header
        NSString* contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if( NSNotFound == paramsSeparator ) {
            return NO;
        }
        if( paramsSeparator >= contentType.length - 1 ) {
            return NO;
        }
        NSString* type = [contentType substringToIndex:paramsSeparator];
        if( ![type isEqualToString:@"multipart/form-data"] ) {
            // we expect multipart/form-data content type
            return NO;
        }
        
        // enumerate all params in content-type, and find boundary there
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];
            
            if( [paramName isEqualToString: @"boundary"] ) {
                // let's separate the boundary from content-type, to make it more handy to handle
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        // check if boundary specified
        if( nil == [request headerField:@"boundary"] )  {
            return NO;
        }
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
    // set up mime parser
    NSString* boundary = [request headerField:@"boundary"];
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;
}

- (void)processBodyData:(NSData *)postDataChunk
{
    // append data to the parser. It will invoke callbacks to let us handle
    // parsed data.
    [parser appendData:postDataChunk];
}


//-----------------------------------------------------------------
#pragma mark multipart form data parser delegate


- (void) processStartOfPartWithHeader:(MultipartMessageHeader*) header {
    // in this sample, we are not interested in parts, other then file parts.
    // check content disposition to find out filename
    
    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
    NSString* filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    
    if ( (nil == filename) || [filename isEqualToString: @""] ) {
        // it's either not a file part, or
        // an empty form sent. we won't handle it.
        return;
    }
    NSString* uploadDirPath = [[WLTSystemTool WLT_fileRootPath] stringByAppendingPathComponent:@"others"];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *oldfilePath = [uploadDirPath stringByAppendingPathComponent: filename];
    NSString *filePath  = [oldfilePath filePathIfisExitAndRename];
    
    if(![[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
        return;
    }
    storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    NSString *params = [request headerField:@"boundary"];
    [request setHeaderField:params value:@"1"];
}

- (void) processContent:(NSData*) data WithHeader:(MultipartMessageHeader*) header
{
    // here we just write the output from parser to the file.
    if( storeFile ) {
        [storeFile writeData:data];
    }
}

- (void) processEndOfPartWithHeader:(MultipartMessageHeader*) header
{
    // as the file part is over, we close the file.
    [storeFile closeFile];
    storeFile = nil;
}

- (void) processPreambleData:(NSData*) data
{
    // if we are interested in preamble data, we could process it here.
    
}

- (void) processEpilogueData:(NSData*) data
{
    // if we are interested in epilogue data, we could process it here.
    
}

@end
