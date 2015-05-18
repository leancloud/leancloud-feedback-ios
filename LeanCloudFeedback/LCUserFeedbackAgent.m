//
//  AVUserFeedbackAgent.m
//  paas
//
//  Created by yang chaozhong on 4/22/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedbackAgent.h"
#import "LCUserFeedback.h"
#import "LCUserFeedbackThread.h"
#import "LCUserFeedbackViewController.h"
#import "LCUtils.h"

@interface LCUserFeedbackAgent()
    
@property(nonatomic, retain) LCUserFeedback *userFeedback;

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
    [viewController presentModalViewController:navigationController animated:YES];
}

- (void)syncFeedbackThreadsWithBlock:(NSString *)title contact:(NSString *)contact block:(AVArrayResultBlock)block {
    [LCUserFeedback feedbackWithContent:title contact:contact withBlock:^(id object, NSError *error) {
        if (!error) {
            self.userFeedback = (LCUserFeedback *)object;
            [LCUserFeedbackThread fetchFeedbackThreadsInBackground:_userFeedback withBlock:^(NSArray *objects, NSError *error) {
                [LCUtils callArrayResultBlock:block array:objects error:error];
            }];
        } else {
            [LCUtils callIdResultBlock:block object:object error:error];
        }
    }];
}

- (void)postFeedbackThread:(NSString *)content block:(AVIdResultBlock)block {
    if (_userFeedback) {
        LCUserFeedbackThread *feedbackThread = [LCUserFeedbackThread feedbackThread:content type:@"user" withFeedback:_userFeedback];
        [LCUserFeedbackThread saveFeedbackThread:feedbackThread withBlock:^(id object, NSError *error) {
            [LCUtils callIdResultBlock:block object:object error:error];
        }];
    } else {
        [LCUserFeedback feedbackWithContent:content contact:nil withBlock:^(id object, NSError *error) {
            self.userFeedback = (LCUserFeedback *)object;
            [self postFeedbackThread:content block:block];
        }];
    }
}

@end
