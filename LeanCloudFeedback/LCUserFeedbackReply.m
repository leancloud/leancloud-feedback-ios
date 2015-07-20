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
    if (self.attachment) {
        [data setObject:self.attachment.url forKey:@"attachment"];
    }
    return [data copy];
}

+ (instancetype)feedbackReplyWithContent:(NSString *)content type:(NSString *)type {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    feedbackReply.content = content;
    feedbackReply.type = type;
    return feedbackReply;
}

+ (instancetype)feedbackReplyWithImage:(UIImage *)image type:(NSString *)type {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    AVFile *attachment = [AVFile fileWithData:UIImageJPEGRepresentation(image, 0.8)];
    feedbackReply.attachment = attachment;
    feedbackReply.type = type;
    return feedbackReply;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    feedbackReply.content = [dictionary objectForKey:@"content"];
    feedbackReply.createAt = [dictionary objectForKey:@"createdAt"];
    feedbackReply.type = [dictionary objectForKey:@"type"];
    NSString *attachmentUrl = [dictionary objectForKey:@"attachment"];
    if (attachmentUrl) {
        AVFile *attachment = [AVFile fileWithURL:attachmentUrl];
        feedbackReply.attachment = attachment;
    }
    return feedbackReply;
}

@end
