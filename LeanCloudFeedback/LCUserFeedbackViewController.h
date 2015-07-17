//
//  LCUserFeedbackViewController.h
//
//  Created by yang chaozhong on 4/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCUserFeedbackNavigationBarStyleBlue = 0,
    LCUserFeedbackNavigationBarStyleNone,
} LCUserFeedbackNavigationBarStyle;

@interface LCUserFeedbackViewController : UIViewController

/**
 *  导航栏主题，默认是蓝色主题
 */
@property(nonatomic, assign) LCUserFeedbackNavigationBarStyle navigationBarStyle;

/**
 *  是否显示联系方式表头, 默认显示。假如不需要用户提供联系方式则可以不显示。
 */
@property(nonatomic, assign) BOOL showContactInputHeader;

/**
 *  设置字体。默认是大小为 16 的系统字体。
 */
@property(nonatomic, strong) UIFont *feedbackCellFont;

@property(nonatomic, retain) NSString *feedbackTitle;
@property(nonatomic, retain) NSString *contact;

@end
