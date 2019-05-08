//
//  WLTFileManager.m
//  AFNetworking
//
//  Created by Lee on 2019/4/25.
//

#import "WLTFileManager.h"
#import <AFNetworking/AFNetworking.h>
#import <CocoaHTTPServer/HTTPServer.h>
#import <CocoaHTTPServer/HTTPLogging.h>
#import "WLTHTTPConnection.h"
#include "WLTSystemTool.h"

#ifdef DEBUG
static const int httpLogLevel = HTTP_LOG_LEVEL_INFO;
#else
static const int httpLogLevel = HTTP_LOG_LEVEL_INFO;
#endif

@interface WLTFileManager ()
{
    BOOL _needRestart;//标记用于重新启动服务
}
@property (nonatomic, strong) HTTPServer *httpServer;
@end
@implementation WLTFileManager
+ (instancetype)sharedInstance {
    static WLTFileManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [WLTFileManager new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHttpServer];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark method
/**
 初始化服务器
 */
- (void)initHttpServer{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // Create server using our custom MyHTTPServer class
    _httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [_httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [_httpServer setPort:8080];
    
    // Tell server to use our custom MyHTTPConnection class.
    [_httpServer setConnectionClass:[WLTHTTPConnection class]];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] pathForResource:@"WirelessTransFile" ofType:@"bundle"] stringByAppendingPathComponent:@"Web"];
//    HTTPLogInfo(@"Setting document root: %@", webPath);
    [_httpServer setDocumentRoot:webPath];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillActivate) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)appWillActivate
{
    if(_needRestart)
    {
        [self start];
    }
}
- (void)appDidEnterBackground
{
    [self.httpServer stop];
}
- (NSError *)start{
    if (self.httpServer.isRunning){
        return nil;
    }
    NSError *error;
    if([self.httpServer start:&error])
    {
        _needRestart = YES;
        HTTPLogInfo(@"Started HTTP Server on port %hu", [self.httpServer listeningPort]);
    }
    else
    {
        _needRestart = NO;
        HTTPLogError(@"Error starting HTTP Server: %@", error);
    }
    return error;
}
- (void)stop{
    _needRestart = NO;
    [self appDidEnterBackground];
}
#pragma mark Public
+ (BOOL)startServer
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        HTTPLogError(@"应用进入后台");
        return NO;
    }
    return ![[WLTFileManager sharedInstance] start];
}
+ (void)stopServer
{
    [[WLTFileManager sharedInstance] stop];
}
- (BOOL)isRuning
{
    return [self.httpServer isRunning];
}
+ (NSString *)ipAddress
{
    return [WLTSystemTool WLT_getIPAddresses];
}
+ (NSString *)serverUrl{
    NSString *ip = [self ipAddress];
    if (!ip){
        return nil;
    }
    return [NSString stringWithFormat:@"%@:%hu", ip, [[WLTFileManager sharedInstance].httpServer listeningPort]];
}
@end
