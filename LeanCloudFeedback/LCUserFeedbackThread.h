//
//  LCUserFeedbackThread.h
//  Feedback
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVConstants.h>

@class LCUserFeedbackThread;

typedef void (^LCUserFeedbackBlock)(LCUserFeedbackThread *feedback, NSError *error);

@interface LCUserFeedbackThread : NSObject

@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *contact;

+(void)fetchFeedbackWithBlock:(LCUserFeedbackBlock)block;
+(void)fetchFeedbackWithContact:(NSString*)contact withBlock:(AVIdResultBlock)block;
+(void)feedbackWithContent:(NSString *)content contact:(NSString *)contact withBlock:(AVIdResultBlock)block;

+(void)updateFeedback:(LCUserFeedbackThread *)feedback withBlock:(AVIdResultBlock)block;

+(void)deleteFeedback:(LCUserFeedbackThread *)feedback withBlock:(AVIdResultBlock)block;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
