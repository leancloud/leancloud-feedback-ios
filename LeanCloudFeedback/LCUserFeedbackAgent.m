//
//  LCUserFeedbackAgent.m
//  Feedback
//
//  Created by yang chaozhong on 4/22/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackAgent.h"
#import "LCUserFeedbackThread.h"
#import "LCUserFeedbackReply.h"
#import "LCUserFeedbackViewController.h"
#import "LCUtils.h"

@interface LCUserFeedbackAgent()
    
@property(nonatomic, retain) LCUserFeedbackThread *userFeedback;

@end

@implementation LCUserFeedbackAgent

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static LCUserFeedbackAgent * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)showConversations:(UIViewController *)viewController title:(NSString *)title contact:(NSString *)contact{
    LCUserFeedbackViewController *feedbackViewController = [[LCUserFeedbackViewController alloc] init];
    feedbackViewController.feedbackTitle = title;
    feedbackViewController.contact = contact;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [viewController presentViewController:navigationController animated:YES completion:^{
        ;
    }];
}

- (void)syncFeedbackThreadsWithBlock:(NSString *)title contact:(NSString *)contact block:(AVArrayResultBlock)block {
    [LCUserFeedbackThread feedbackWithContent:title contact:contact withBlock:^(id object, NSError *error) {
        if (!error) {
            self.userFeedback = (LCUserFeedbackThread *)object;
            [LCUserFeedbackReply fetchFeedbackThreadsInBackground:_userFeedback withBlock:^(NSArray *objects, NSError *error) {
                [LCUtils callArrayResultBlock:block array:objects error:error];
            }];
        } else {
            [LCUtils callIdResultBlock:block object:object error:error];
        }
    }];
}

- (void)postFeedbackThread:(NSString *)content block:(AVIdResultBlock)block {
    if (_userFeedback) {
        LCUserFeedbackReply *feedbackThread = [LCUserFeedbackReply feedbackThread:content type:@"user" withFeedback:_userFeedback];
        [LCUserFeedbackReply saveFeedbackThread:feedbackThread withBlock:^(id object, NSError *error) {
            [LCUtils callIdResultBlock:block object:object error:error];
        }];
    } else {
        [LCUserFeedbackThread feedbackWithContent:content contact:nil withBlock:^(id object, NSError *error) {
            self.userFeedback = (LCUserFeedbackThread *)object;
            [self postFeedbackThread:content block:block];
        }];
    }
}

@end
