//
//  AVUserFeedbackLeftCell.m
//  paas
//
//  Created by yang chaozhong on 4/24/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "LCUserFeedbackLeftCell.h"

#define TOP_MARGIN 20.0f

@interface LCUserFeedbackLeftCell() {
    UIImageView *_messageBackgroundView;
}
@end

@implementation LCUserFeedbackLeftCell

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
        
        self.timestampLabel = [[UILabel alloc] init];
        self.timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.timestampLabel.textAlignment = UITextAlignmentCenter;
        self.timestampLabel.backgroundColor = [UIColor clearColor];
        self.timestampLabel.font = [UIFont systemFontOfSize:9.0f];
        self.timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        self.timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);
        [self.contentView addSubview:_timestampLabel];
        
        _messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        _messageBackgroundView.image = [[UIImage imageNamed:@"bg_1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        [self.contentView insertSubview:_messageBackgroundView belowSubview:self.textLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 18;
    textLabelFrame.size.width = 226;
    
    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                       constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    textLabelFrame.size.height = labelSize.height;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    self.textLabel.frame = textLabelFrame;
    
    _messageBackgroundView.frame = CGRectMake(10, textLabelFrame.origin.y - 12, labelSize.width + 16, labelSize.height + 18);;
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
