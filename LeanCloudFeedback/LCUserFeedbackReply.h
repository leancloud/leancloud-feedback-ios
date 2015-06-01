//
//  LCUserFeedbackReply.h
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVConstants.h>
#import "LCUserFeedbackThread.h"

@interface LCUserFeedbackReply : NSObject

@property(nonatomic, retain) LCUserFeedbackThread *feedback;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *createAt;

+ (instancetype)feedbackThread:(NSString *)content
                         type:(NSString *)type
                 withFeedback:(LCUserFeedbackThread *)feedback;

+ (void)saveFeedbackThread:(LCUserFeedbackReply *)feedbackThread;

+ (void)saveFeedbackThread:(LCUserFeedbackReply *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)saveFeedbackThreadInBackground:(LCUserFeedbackReply *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)fetchFeedbackThreadsInBackground:(LCUserFeedbackThread *)feedback withBlock:(AVArrayResultBlock)block;

@end
