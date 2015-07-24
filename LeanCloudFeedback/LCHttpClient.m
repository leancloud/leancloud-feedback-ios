//
//  LCHttpClient.m
//  Feedback
//
//  Created by Feng Junwen on 5/15/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "LCHttpClient.h"
#import "LCUtils.h"

@interface LCHttpClient ()

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

@property (nonatomic, strong) NSURL *baseURL;
//
//@property (nonatomic, copy) NSString * applicationId;
//@property (nonatomic, copy) NSString * applicationKey;
//
//@property (nonatomic, copy) NSString * applicationIdField;
//@property (nonatomic, copy) NSString * applicationKeyField;
//@property (nonatomic, copy) NSString * sessionTokenField;
//@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) NSOperationQueue *operationQueue;


@end

@implementation LCHttpClient

+ (LCHttpClient*)sharedInstance {
    static dispatch_once_t once;
    static LCHttpClient * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.baseURL = [NSURL URLWithString:@"https://api.leancloud.cn/1.1/"];
        sharedInstance.operationQueue = [[NSOperationQueue alloc] init];
    });
    return sharedInstance;
}

- (dispatch_queue_t)completionQueue {
    if (!_completionQueue) {
        _completionQueue = dispatch_queue_create("com.leancloud.completionQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _completionQueue;
}

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *queries = [[NSMutableString alloc] init];
    BOOL first = YES;
    for (NSString *key in [parameters allKeys]) {
        if (first) {
            first = NO;
        } else {
            [queries appendString:@"&"];
        }
        NSString *value = [parameters valueForKey:key];
        [queries appendFormat:@"%@=%@", key, value];
    }
    return [queries stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[AVOSCloud getApplicationId] forHTTPHeaderField:@"X-AVOSCloud-Application-Id"];
    
    NSString *timestamp=[NSString stringWithFormat:@"%.0f",1000*[[NSDate date] timeIntervalSince1970]];
    NSString *sign=[LCUtils calMD5:[NSString stringWithFormat:@"%@%@",timestamp,[AVOSCloud getClientKey]]];
    NSString *headerValue=[NSString stringWithFormat:@"%@,%@",sign,timestamp];
    [request setValue:headerValue forHTTPHeaderField:@"X-AVOSCloud-Request-Sign"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:kAVDefaultNetworkTimeoutInterval];
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"GET"] || [method isEqualToString:@"DELETE"]) {
        url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:@"?%@", [self queryStringFromParameters:parameters]]];
        [request setURL:url];
    } else {
        [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
        NSError *error;
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
        if (error) {
            NSLog(@"%@ error : %@", [self class], error);
        }
    }
    return request;
}

- (void)goRequest:(NSURLRequest *)request block:(AVIdResultBlock)block {
    NSLog(@"request url : %@", request.URL);
    NSLog(@"request headers : %@", [request allHTTPHeaderFields]);
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            block(nil, connectionError);
        } else {
            if (response && data) {
                NSError *error;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"reponse : %@", responseString);
                    block(nil, error);
                } else {
                    block(dictionary, nil);
                }
            }
        }
    }];
}

- (NSDictionary *)whereDictionaryFromConditions:(NSDictionary *)conditions {
    NSDictionary *where = [NSDictionary dictionary];
    if (conditions.count>0) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:conditions options:0 error:nil];
        NSString *conditionString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        where = @{@"where":conditionString};
    }
    return where;
}

-(void)getObject:(NSString *)path
  withParameters:(NSDictionary *)parameters
           block:(AVIdResultBlock)block {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:[self whereDictionaryFromConditions:parameters]];
    [self goRequest:request block:block];
}

-(void)postObject:(NSString *)path
   withParameters:(NSDictionary *)parameters
            block:(AVIdResultBlock)block
{
    NSMutableURLRequest *request= [self requestWithMethod:@"POST" path:path parameters:parameters];
    [self goRequest:request block:block];
}

-(void)putObject:(NSString *)path
  withParameters:(NSDictionary *)parameters
           block:(AVIdResultBlock)block {
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    [self goRequest:request block:block];
}

-(void)deleteObject:(NSString *)path
     withParameters:(NSDictionary *)parameters
              block:(AVIdResultBlock)block {
    NSMutableURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    [self goRequest:request block:block];
}

@end
