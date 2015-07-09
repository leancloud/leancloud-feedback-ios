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

@interface LCUserFeedbackReply ()

@property(nonatomic, copy, readwrite) NSString *createAt;

@end

@implementation LCUserFeedbackReply

- (NSDictionary *)dictionary {
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];

    [data setObject:self.content forKey:@"content"];
    [data setObject:self.type forKey:@"type"];

    return [data copy];
}

+ (instancetype)feedbackReplyWithContent:(NSString *)content type:(NSString *)type {
    LCUserFeedbackReply *feedbackThread = [[LCUserFeedbackReply alloc] init];

    feedbackThread.content = content;
    feedbackThread.type = type;

    return feedbackThread;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];

    feedbackReply.content = [dictionary objectForKey:@"content"];
    feedbackReply.createAt = [dictionary objectForKey:@"createdAt"];
    feedbackReply.type = [dictionary objectForKey:@"type"];

    return feedbackReply;
}

@end
