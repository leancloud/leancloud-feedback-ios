//
//  AVUserFeedback.m
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedback.h"
#import "LCHttpClient.h"
#import "LCUtils.h"
#import "LCUserFeedback_Internal.h"

#define kUserFeedbackCache @"/1/feedback/cache/path"
#define kMaxCacheAge 24*3600

@interface LCUserFeedback()

@property(nonatomic, retain) NSString *appSign;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *remarks;
@property(nonatomic, retain) NSString *iid;

@end

@implementation LCUserFeedback

+(NSString *)myObjectPath {
    return @"https://api.leancloud.cn/1.1/feedback";
}

- (instancetype)init {
    if ((self = [super init])) {
        self.iid = [AVInstallation currentInstallation].objectId;
    }
    return self;
}

-(NSMutableDictionary *)postData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (_content) {
        [data setObject:self.content forKey:@"content"];
    }
    
    if (_contact) {
        [data setObject:self.contact forKey:@"contact"];
    }
    
    if (_status) {
        [data setObject:self.status forKey:@"status"];
    }
    
    if (_remarks) {
        [data setObject:self.remarks forKey:@"remarks"];
    }
    
    if (_iid) {
        [data setObject:self.iid forKey:@"iid"];
    }
    
    return data;
}

+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                    create:(BOOL)create
                 withBlock:(AVIdResultBlock)block {
    if (create) {
        LCUserFeedback *feedback = [[LCUserFeedback alloc] init];
        feedback.content = content;
        feedback.contact = contact;
        
        LCHttpClient *client = [LCHttpClient sharedInstance];
        [client postObject:[LCUserFeedback myObjectPath] withParameters:[feedback postData] block:^(id object, NSError *error) {
            if (!error) {
                feedback.objectId = [(NSDictionary *)object objectForKey:@"objectId"];
                
                [LCUtils callIdResultBlock:block object:feedback error:error];
            } else {
                [LCUtils callIdResultBlock:block object:nil error:error];
            }
        }];
    } else {
        [LCUtils callIdResultBlock:block object:nil error:[NSError new]];
    }
}

+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                 withBlock:(AVIdResultBlock)block {
    [self feedbackWithContent:content contact:contact create:YES withBlock:block];
}


+(void)updateFeedback:(LCUserFeedback *)feedback withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] putObject:[NSString stringWithFormat:@"%@%@%@", [LCUserFeedback myObjectPath], @"/", feedback.objectId]
                              withParameters:[feedback postData]
                                       block:^(id object, NSError *error) {
                                           [LCUtils callIdResultBlock:block object:object error:error];
                                       }];
}

+(void)deleteFeedback:(LCUserFeedback *)feedback withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] deleteObject:[NSString stringWithFormat:@"%@%@%@", [LCUserFeedback myObjectPath], @"/", feedback.objectId]
                                 withParameters:nil
                                          block:^(id object, NSError *error) {
                                              [LCUtils callIdResultBlock:block object:object error:error];
                                          }];
}

@end
