//
//  LCUserFeedbackImageViewController.m
//  LeanCloudFeedback
//
//  Created by lzw on 15/7/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackImageViewController.h"

@interface LCUserFeedbackImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LCUserFeedbackImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = self.image;
    }
    return _imageView;
}

@end
