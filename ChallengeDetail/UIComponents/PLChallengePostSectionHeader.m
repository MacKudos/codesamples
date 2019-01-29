//
//  PLSearchSectionHeader.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengePostSectionHeader.h"

@implementation PLChallengePostSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        [self createLayout];
    }
    return self;
}

- (void)createViews {
    
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    title.nuiClass = @"TextLabelDefault";
    title.text = NSLocalizedString(@"Cards", @"");
    self.title = title;
    [self addSubview:title];

    UIButton *popularButton = [UIButton new];
    popularButton.titleLabel.font = [UIFont systemFontOfSize:15];
    popularButton.nuiClass = @"SelectedTextButton";
    [popularButton setTitle:NSLocalizedString(@"ch_top", @"") forState:UIControlStateNormal];
    [popularButton addTarget:self action:@selector(popularTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.sortByPopularButton = popularButton;
    [self addSubview:popularButton];

    UIButton *newButton = [UIButton new];
    newButton.titleLabel.font = [UIFont systemFontOfSize:15];
    newButton.nuiClass = @"SelectedTextButton";
    [newButton setTitle:NSLocalizedString(@"ch_latest", @"") forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(newTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.sortByNewButton = newButton;
    [self addSubview:newButton];
}

- (void)createLayout {

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(16);
    }];

    [self.sortByNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).mas_offset(-16);
    }];

    [self.sortByPopularButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.sortByNewButton.mas_left).mas_offset(-16);
    }];
}

- (void)popularTapped:(UIButton *)sender {
    if (self.popularTapped)
        self.popularTapped();
}

- (void)newTapped:(UIButton *)sender {
    if (self.newTapped)
        self.newTapped();
}

@end
