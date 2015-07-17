//
//  LCUserFeedbackCell.m
//
//  Created by yang chaozhong on 4/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackReplyCell.h"
#import "LCUserFeedbackReply.h"

#define TOP_MARGIN 20.0f

@interface LCUserFeedbackReplyCell()

@property (nonatomic, strong) UILabel *timestampLabel;

@property (nonatomic, strong) UIImageView *messageBackgroundView;

@property (nonatomic, strong) LCUserFeedbackReply *feedbackReply;

@end

@implementation LCUserFeedbackReplyCell

- (id)initWithFeedbackReply:(LCUserFeedbackReply *)reply reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self setupTextLabel];
    [self.contentView addSubview:self.timestampLabel];
    
    [self.contentView insertSubview:[self messageBackgroundView] belowSubview:self.textLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - property

- (void)setupTextLabel {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
        self.textLabel.backgroundColor = [UIColor whiteColor];
    }
    self.textLabel.font = [[LCUserFeedbackReplyCell appearance] cellFont];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.textColor = [UIColor blackColor];
}

- (UILabel *)timestampLabel {
    if (_timestampLabel == nil) {
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = NSTextAlignmentCenter;
        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.font = [UIFont systemFontOfSize:9.0f];
        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);
    }
    return _timestampLabel;
}

- (UIImageView *)messageBackgroundView {
    if (_messageBackgroundView == nil) {
            _messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
    }
    return _messageBackgroundView;
}

#pragma mark -

- (void)configuareCellWithFeedbackReply:(LCUserFeedbackReply *)reply {
    self.feedbackReply = reply;
    self.messageBackgroundView.image = [self backgroundImageForFeedbackReply:reply];
    self.textLabel.text = reply.content;
    self.timestampLabel.text = [self formatDateString:reply.createAt];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self caculateLabelSizeForText:self.feedbackReply.content];
    
    CGFloat textLabelOriginX = 18;
    if ([self isDevFeedbackReply:self.feedbackReply] == NO) {
        textLabelOriginX = self.bounds.size.width - textLabelOriginX - labelSize.width;
    }
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = textLabelOriginX;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    textLabelFrame.size.width = labelSize.width;
    textLabelFrame.size.height = labelSize.height;
    self.textLabel.frame = textLabelFrame;
    
    if ([self isDevFeedbackReply:self.feedbackReply]) {
        _messageBackgroundView.frame = CGRectMake(10, textLabelFrame.origin.y - 12, labelSize.width + 16, labelSize.height + 18);;
    } else {
        _messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - 8, textLabelFrame.origin.y - 5, labelSize.width + 16, labelSize.height + 18);
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.timestampLabel.text = nil;
    self.textLabel.text = nil;
    self.messageBackgroundView.image = nil;
}

#pragma mark - utils

- (CGSize)caculateLabelSizeForText:(NSString *)text {
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [[LCUserFeedbackReplyCell appearance] cellFont];
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.text = self.textLabel.text;
    CGSize maxiumLabelSize = CGSizeMake(226.0f, MAXFLOAT);
    return [gettingSizeLabel sizeThatFits:maxiumLabelSize];
}


- (BOOL)isDevFeedbackReply:(LCUserFeedbackReply *)reply {
    return [reply.type isEqualToString:@"dev"];
}

- (UIImage *)backgroundImageForFeedbackReply:(LCUserFeedbackReply *)reply {
    if ([self isDevFeedbackReply:reply]) {
        return [[UIImage imageNamed:@"bg_1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    } else {
        return [[UIImage imageNamed:@"bg_2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:16];;
    }
}

- (NSString *)formatDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark -

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
