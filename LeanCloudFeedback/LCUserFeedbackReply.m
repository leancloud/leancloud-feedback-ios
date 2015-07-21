//
//  LCUserFeedbackReply.m
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackReply.h"
#import "LCUserFeedbackReply_Internal.h"
#import "LCUserFeedbackThread.h"
#import "LCHttpClient.h"
#import "LCUtils.h"

@interface LCUserFeedbackReply ()

@property(nonatomic, copy, readwrite) NSString *createAt;
@property(nonatomic, assign, readwrite) LCReplyType type;
@property(nonatomic, strong, readwrite) AVFile *attachment;
@property(nonatomic, copy, readwrite) NSString *content;

@end

@implementation LCUserFeedbackReply

- (NSDictionary *)dictionary {
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    
    if (self.type == LCReplyTypeUser) {
        [data setObject:@"user" forKey:@"type"];
    } else {
        [data setObject:@"dev" forKey:@"type"];
    }
    if (self.content) {
        [data setObject:self.content forKey:@"content"];
    }
    if (self.attachment) {
        [data setObject:self.attachment.url forKey:@"attachment"];
    }
    return [data copy];
}

+ (instancetype)feedbackReplyWithContent:(NSString *)content type:(LCReplyType)type {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    feedbackReply.content = content;
    feedbackReply.type = type;
    return feedbackReply;
}

+ (instancetype)feedbackReplyWithImage:(UIImage *)image type:(LCReplyType)type {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    AVFile *attachment = [AVFile fileWithName:@"feedback.png" data:UIImageJPEGRepresentation(image, 0.6)];
    feedbackReply.attachmentImage = image;
    feedbackReply.attachment = attachment;
    feedbackReply.type = type;
    return feedbackReply;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    LCUserFeedbackReply *feedbackReply = [[LCUserFeedbackReply alloc] init];
    feedbackReply.content = [dictionary objectForKey:@"content"];
    feedbackReply.createAt = [dictionary objectForKey:@"createdAt"];
    NSString *type = [dictionary objectForKey:@"type"];
    if ([type isEqualToString:@"user"]) {
        feedbackReply.type = LCReplyTypeUser;
    } else {
        feedbackReply.type = LCReplyTypeDev;
    }
    NSString *attachmentUrl = [dictionary objectForKey:@"attachment"];
    if (attachmentUrl) {
        AVFile *attachment = [AVFile fileWithURL:attachmentUrl];
        feedbackReply.attachment = attachment;
    }
    return feedbackReply;
}

- (LCContentType)contentType {
    if (self.attachment) {
        return LCContentTypeImage;
    } else {
        return LCContentTypeText;
    }
}

@end
