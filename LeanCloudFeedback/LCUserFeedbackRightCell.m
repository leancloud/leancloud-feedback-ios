//
//  AVUserFeedbackRightCell.m
//  paas
//
//  Created by yang chaozhong on 4/25/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedbackRightCell.h"

#define TOP_MARGIN 20.0f


@interface LCUserFeedbackRightCell() {
    UIImageView *_messageBackgroundView;
}

@end

@implementation LCUserFeedbackRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            self.textLabel.backgroundColor = [UIColor whiteColor];
        }
        
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.textColor = [UIColor blackColor];
        
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = UITextAlignmentCenter;
        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.font = [UIFont systemFontOfSize:9.0f];
        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);
        
        [self.contentView addSubview:_timestampLabel];
        
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.y = 20;
        textLabelFrame.size.width = self.bounds.size.width - 50;
        self.textLabel.frame = textLabelFrame;
        
        _messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        _messageBackgroundView.image = [[UIImage imageNamed:@"bg_2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:16];
        [self.contentView insertSubview:_messageBackgroundView belowSubview:self.textLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = 226;
    self.textLabel.frame = textLabelFrame;
    
    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                       constrainedToSize:CGSizeMake(226, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    textLabelFrame.size.height = labelSize.height + 6;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    textLabelFrame.origin.x = self.bounds.size.width - labelSize.width - 20;
    self.textLabel.frame = textLabelFrame;
    
    _messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - 8, textLabelFrame.origin.y - 2, labelSize.width + 16, labelSize.height + 18);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
