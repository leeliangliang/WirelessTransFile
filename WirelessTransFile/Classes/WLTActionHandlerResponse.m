//
//  WLTActionResponse.m
//  AFNetworking
//
//  Created by Lee on 2019/4/28.
//

#import "WLTActionHandlerResponse.h"
@interface WLTActionHandlerResponse ()
@property (nonatomic, copy, readwrite) NSDictionary *param;
@end

@implementation WLTActionHandlerResponse
- (instancetype)initWithParams:(NSDictionary *)params
{
    if(self = [super initWithData:nil])
    {
        self.param = params;
        [self _transformJsonDataWith:[self _handlerRequest]];
    }
    return self;
}

- (NSDictionary *)_handlerRequest{
    NSString *action = self.param[@"action"];
    if([action isEqualToString:@"Auth"])
    {
        return [self _responseSucessDictWith:nil];
    }
    return nil;
}
- (NSDictionary *)_responseSucessDictWith:(NSDictionary *)dict{
    NSMutableDictionary *resData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"RESULT",nil];
    [resData setObject:@[@"videos", @"musics", @"picture", @"documents", @"skins", @"compressed", @"others"] forKey:@"BASICDIRS"];
    if(dict){
        [resData addEntriesFromDictionary:dict];
    }
    return resData;
}
- (void)_transformJsonDataWith:(NSDictionary *)dict{
    
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
    if (isYes) {
        /* JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.
         */
        data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    }
}
@end
