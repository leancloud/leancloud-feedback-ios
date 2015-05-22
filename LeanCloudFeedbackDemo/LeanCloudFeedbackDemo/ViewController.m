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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startFeedbackView:(id)sender {
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
    [agent showConversations:self title:@"提点意见" contact:@"热心用户"];
}

@end
