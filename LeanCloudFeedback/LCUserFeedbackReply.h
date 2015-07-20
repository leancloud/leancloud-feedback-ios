//
//  LCUserFeedbackReply.h
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVConstants.h>

@class LCUserFeedbackThread;

@interface LCUserFeedbackReply : NSObject

@property(nonatomic, retain) LCUserFeedbackThread *feedback;

@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) AVFile *attachment;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy, readonly) NSString *createAt;

+ (instancetype)feedbackReplyWithContent:(NSString *)content type:(NSString *)type;
+ (instancetype)feedbackReplyWithImage:(UIImage *)image type:(NSString *)type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

@end
