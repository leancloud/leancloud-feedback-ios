//
//  ViewController.m
//  LeanCloudFeedbackDemo
//
//  Created by Feng Junwen on 5/22/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import "ViewController.h"
#import <LeanCloudFeedback/LeanCloudFeedback.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *unreadTipLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.unreadTipLabel.text = nil;
    [[LCUserFeedbackAgent sharedInstance] countUnreadFeedbackThreadsWithBlock:^(NSInteger number, NSError *error) {
        if (!error) {
            [self setUnreads:number];
        } else {
            [self setUnreads:0];
        }
    }];
}

- (void)setUnreads:(NSInteger)unreads {
    self.unreadTipLabel.text = [NSString stringWithFormat:@"您有 %ld 条未读反馈", unreads];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentFeedbackView:(id)sender {
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
//    [agent showConversations:self title:nil contact:@"goodman@leancloud.cn"];
    [agent showConversations:self title:nil contact:nil];
    
    [self setUnreads:0];
}

- (IBAction)pushFeedbackView:(id)sender {
    LCUserFeedbackViewController *feedbackViewController = [[LCUserFeedbackViewController alloc] init];
    feedbackViewController.feedbackTitle = nil;
    feedbackViewController.contact = nil;
    
    // 隐藏联系人表头
    feedbackViewController.contactHeaderHidden = YES;
    
    // 决定返回按钮和样式
    feedbackViewController.presented = NO;
    
    // 不设置导航栏样式
    feedbackViewController.navigationBarStyle = LCUserFeedbackNavigationBarStyleNone;
    
    [self.navigationController pushViewController:feedbackViewController animated:YES];
    
    [self setUnreads:0];
}

@end
