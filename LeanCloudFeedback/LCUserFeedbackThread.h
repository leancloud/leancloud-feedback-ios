//
//  AVUserFeedbackThread.h
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVConstants.h>
#import "LCUserFeedback.h"

@interface LCUserFeedbackThread : NSObject

@property(nonatomic, retain) LCUserFeedback *feedback;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *createAt;

+ (instancetype)feedbackThread:(NSString *)content
                         type:(NSString *)type
                 withFeedback:(LCUserFeedback *)feedback;

+ (void)saveFeedbackThread:(LCUserFeedbackThread *)feedbackThread;

+ (void)saveFeedbackThread:(LCUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)saveFeedbackThreadInBackground:(LCUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)fetchFeedbackThreadsInBackground:(LCUserFeedback *)feedback withBlock:(AVArrayResultBlock)block;

@end
