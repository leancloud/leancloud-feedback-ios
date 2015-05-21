//
//  AVUserFeedback.h
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVConstants.h>

@interface LCUserFeedback : NSObject

@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *contact;

+(void)fetchFeedbackWithContact:(NSString*)contact withBlock:(AVIdResultBlock)block;
+(void)feedbackWithContent:(NSString *)content contact:(NSString *)contact withBlock:(AVIdResultBlock)block;

+(void)updateFeedback:(LCUserFeedback *)feedback withBlock:(AVIdResultBlock)block;

+(void)deleteFeedback:(LCUserFeedback *)feedback withBlock:(AVIdResultBlock)block;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
