//
//  PLChallengeHeadCollectionViewCell.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengeHeadCollectionViewCell.h"
#import "UIColor+Utils.h"
#import "UIView+NUI.h"
#import <Masonry.h>
#import "UIImage+Additions.h"
#import "PLChallengeService.h"

@interface PLChallengeHeadCollectionViewCell () <UITextFieldDelegate>
@property (nonatomic, weak) UIButton *followButton;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *infoLabel;
@property (nonatomic, weak) UILabel *typeLabel;
@end


@implementation PLChallengeHeadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProButton];
        [self layoutViews];
    }
    return self;
}

- (void)setupProButton {
    
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightRegular];
    nameLabel.nuiClass = @"TextLabel";
    nameLabel.numberOfLines = 2;
    [self.contentView addSubview:nameLabel];
    
    UIButton *followButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.followButton = followButton;
    UIImage *image = [[UIImage imageNamed:@"border"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 30, 15, 30) resizingMode:UIImageResizingModeStretch] ;
    [self.followButton setBackgroundImage:[image imageWithOverlay:[NUISettings getColor:@"font-color" withClass:@"ActionButtonBordered"]] forState:UIControlStateNormal];
    [self.contentView addSubview:self.followButton];
    [self.followButton addTarget:self action:@selector(tappedAction) forControlEvents:UIControlEventTouchUpInside];
    self.followButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.followButton.hidden = YES;
    
    UIColor *textColor = [NUISettings getColor:@"font-color" withClass:@"ActivityTimeText"];
    UILabel *typeLabel = [UILabel new];
    self.typeLabel = typeLabel;
    self.typeLabel.font = [UIFont systemFontOfSize:13];
    self.typeLabel.textColor = textColor;
    typeLabel.numberOfLines = 1;
    self.typeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:typeLabel];
    
    UILabel *infoLabel = [UILabel new];
    self.infoLabel = infoLabel;
    infoLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    infoLabel.nuiClass = @"TextLabel";
    infoLabel.numberOfLines = 1;
    [self.contentView addSubview:infoLabel];
}

- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_equalTo(24);
        make.left.equalTo(self.contentView).mas_offset(16);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-100);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.height.mas_equalTo(34);
        make.left.equalTo(self.nameLabel.mas_right).mas_offset(8);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).mas_equalTo(5);
        make.left.equalTo(self.contentView).mas_offset(16);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).mas_equalTo(5);
        make.left.equalTo(self.contentView).mas_offset(16);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(PLChallenge *)model {
    
    self.nameLabel.text = model.name;
    self.typeLabel.text = (model.type == PLChallengeTypeCompetition)? NSLocalizedString(@"ch_Competition", @"") :  NSLocalizedString(@"ch_Collaboration", @"");
    
    NSString *dateInfo;
    NSString *rewardInfo = [NSString stringWithFormat:@"%li SOL", [model.reward integerValue]];
    
    if ([model.expiresAt timeIntervalSinceNow] > 0) {
        
        NSInteger days = [self numberOfDaysUntil:model.expiresAt] + 1;
        if (days > 7) days = 7;
        dateInfo = [NSString localizedStringWithFormat:NSLocalizedString(@"%dDayLeft", @"%dDayLeft"), (long)days];
        
    } else {
        dateInfo = NSLocalizedString(@"challenge_Finished", @"");
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@ • %@ • %@", rewardInfo, dateInfo, [NSString stringWithFormat:NSLocalizedString(@"%dcards", @"%dcards"), (int)[model.cardCount integerValue]]];
}

- (void)setMeta:(PLChallengeMeta *)meta {
    if (!meta) return;
    
    self.followButton.hidden = NO;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!meta.isPrioritized) {
            [self.followButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"ch_FOLLOW", @"") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"ActionButtonBordered"]}] forState:UIControlStateNormal];
        } else {
            [self.followButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"ch_UNFOLLOW", @"") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"ActionButtonBordered"]}] forState:UIControlStateNormal];
        }
    });
}

- (NSInteger)numberOfDaysUntil:(NSDate*)date {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:date options:0];
    return [components day];
}

- (void)tappedAction {
    
    if (self.tapped) {
        self.tapped();
    }
}

@end

