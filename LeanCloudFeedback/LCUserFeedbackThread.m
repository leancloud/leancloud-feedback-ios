//
//  AVUserFeedbackThread.m
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedbackThread.h"
#import "LCUserFeedback.h"
#import "LCHttpClient.h"
#import "LCUtils.h"

@implementation LCUserFeedbackThread

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
                 withFeedback:(LCUserFeedback *)feedback{
    
    LCUserFeedbackThread *feedbackThread = [[LCUserFeedbackThread alloc] init];
    feedbackThread.content = content;
    feedbackThread.type = type;
    feedbackThread.feedback = feedback;
    return feedbackThread;
}

+ (void)saveFeedbackThread:(LCUserFeedbackThread *)feedbackThread {
    [self saveFeedbackThread:feedbackThread withBlock:nil];
}

+ (void)saveFeedbackThread:(LCUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] postObject:[LCUserFeedbackThread myObjectPath:feedbackThread.feedback.objectId]
                               withParameters:[feedbackThread postData]
                                        block:^(id object, NSError *error) {
                                            [LCUtils callIdResultBlock:block object:object error:error];
                                        }];
}

+ (void)saveFeedbackThreadInBackground:(LCUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [LCUserFeedbackThread saveFeedbackThread:feedbackThread withBlock:block];
    });
}

+(void)fetchFeedbackThreadsInBackground:(LCUserFeedback *)feedback withBlock:(AVArrayResultBlock)block {
    [[LCHttpClient sharedInstance] getObject:[LCUserFeedbackThread myObjectPath:feedback.objectId]
                              withParameters:nil
                                       block:^(id object, NSError *error) {
                                           NSArray *results = [object objectForKey:@"results"];
                                           [LCUtils callArrayResultBlock:block array:[LCUserFeedbackThread processResults:results] error:error];
                                       }];
}

+ (NSMutableArray *)processResults:(NSArray *)results {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in results) {
        LCUserFeedbackThread *feedbackThread = [[LCUserFeedbackThread alloc] init];
        feedbackThread.content = [dict objectForKey:@"content"];
        feedbackThread.type = [dict objectForKey:@"type"];
        feedbackThread.createAt = [dict objectForKey:@"createdAt"];
        
        [array addObject:feedbackThread];
    }
    
    return array;
}

@end
