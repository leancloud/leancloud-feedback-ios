//
//  LCUserFeedbackCell.h
//
//  Created by yang chaozhong on 4/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserFeedbackReply.h"

@interface LCUserFeedbackReplyCell : UITableViewCell

@property (nonatomic, strong) UIFont *cellFont UI_APPEARANCE_SELECTOR;;

- (id)initWithFeedbackReply:(LCUserFeedbackReply *)reply reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configuareCellWithFeedbackReply:(LCUserFeedbackReply *)reply;

@end
