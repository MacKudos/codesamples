//
//  PLChallengeParticipateCollectionViewCell.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/8/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengeParticipateCollectionViewCell.h"
#import "UIColor+Utils.h"
#import "UIView+NUI.h"
#import <Masonry.h>
#import "UIImage+Additions.h"
#import "PLButton.h"

@interface PLChallengeParticipateCollectionViewCell () <UITextFieldDelegate>
@property (weak, nonatomic) PLButton *actionButton;
@end


@implementation PLChallengeParticipateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProButton];
        [self layoutViews];
    }
    return self;
}

- (void)setupProButton {
    
    PLButton *actionButton = [[PLButton alloc] initWithType:PLButtonTypeDefault];
    [self.contentView addSubview: actionButton];
    self.actionButton = actionButton;
    
    [actionButton setTitle:NSLocalizedString(@"challenge_participate", @"") forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(tappedAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
}

- (void)tappedAction {
    
    if (self.tapped) {
        self.tapped();
    }
}

@end
