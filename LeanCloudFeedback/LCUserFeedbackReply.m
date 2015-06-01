//
//  LCUserFeedbackReply.m
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackReply.h"
#import "LCUserFeedbackThread.h"
#import "LCHttpClient.h"
#import "LCUtils.h"

@implementation LCUserFeedbackReply

+ (NSString *)myObjectPath:(NSString *)feedbackObjectId {
    return [NSString stringWithFormat:@"https://api.leancloud.cn/1.1/feedback/%@/threads", feedbackObjectId];
}

- (NSMutableDictionary *)postData {
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:self.content forKey:@"content"];
    [data setObject:self.type forKey:@"type"];
    [data setObject:self.feedback.objectId forKey:@"feedback"];
    
    return data;
}

+ (instancetype)feedbackThread:(NSString *)content
                         type:(NSString *)type
                 withFeedback:(LCUserFeedbackThread *)feedback{
    
    LCUserFeedbackReply *feedbackThread = [[LCUserFeedbackReply alloc] init];
    feedbackThread.content = content;
    feedbackThread.type = type;
    feedbackThread.feedback = feedback;
    return feedbackThread;
}

+ (void)saveFeedbackThread:(LCUserFeedbackReply *)feedbackThread {
    [self saveFeedbackThread:feedbackThread withBlock:nil];
}

+ (void)saveFeedbackThread:(LCUserFeedbackReply *)feedbackThread withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] postObject:[LCUserFeedbackReply myObjectPath:feedbackThread.feedback.objectId]
                               withParameters:[feedbackThread postData]
                                        block:^(id object, NSError *error) {
                                            [LCUtils callIdResultBlock:block object:object error:error];
                                        }];
}

+ (void)saveFeedbackThreadInBackground:(LCUserFeedbackReply *)feedbackThread withBlock:(AVIdResultBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [LCUserFeedbackReply saveFeedbackThread:feedbackThread withBlock:block];
    });
}

+(void)fetchFeedbackThreadsInBackground:(LCUserFeedbackThread *)feedback withBlock:(AVArrayResultBlock)block {
    [[LCHttpClient sharedInstance] getObject:[LCUserFeedbackReply myObjectPath:feedback.objectId]
                              withParameters:nil
                                       block:^(id object, NSError *error) {
                                           NSArray *results = [object objectForKey:@"results"];
                                           [LCUtils callArrayResultBlock:block array:[LCUserFeedbackReply processResults:results] error:error];
                                       }];
}

+ (NSMutableArray *)processResults:(NSArray *)results {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in results) {
        LCUserFeedbackReply *feedbackThread = [[LCUserFeedbackReply alloc] init];
        feedbackThread.content = [dict objectForKey:@"content"];
        feedbackThread.type = [dict objectForKey:@"type"];
        feedbackThread.createAt = [dict objectForKey:@"createdAt"];
        
        [array addObject:feedbackThread];
    }
    
    return array;
}

@end
