//
//  PLChallengeAuthorCollectionViewCell.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengeAuthorCollectionViewCell.h"
#import <Masonry.h>
#import "UIView+NUI.h"
#import "PLPost.h"
#import "UIImage+Additions.h"
#import "NSString+Counters.h"
#import "PLChallengeService.h"
#import "PLUser.h"

@interface PLChallengeAuthorCollectionViewCell ()

@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *location;

@end

@implementation PLChallengeAuthorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createViews];
        [self layoutViews];
    }
    return self;
}

- (void)createViews {
    
    UIColor *textColor = [NUISettings getColor:@"font-color" withClass:@"ActivityTimeText"];
    UIColor *activeColor = [NUISettings getColor:@"font-color" withClass:@"CardControl"];
    
    self.name.translatesAutoresizingMaskIntoConstraints = NO;
    self.name.backgroundColor = [UIColor clearColor];
    UILabel *name = [UILabel new];
    self.name = name;
    self.name.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.name.textColor = activeColor;
    [self.contentView addSubview:name];
    
    UILabel *location = [UILabel new];
    self.location = location;
    self.location.font = [UIFont systemFontOfSize:13];
    self.location.textColor = textColor;
    self.location.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:location];
}

- (void)layoutViews {
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(15);
        make.left.equalTo(self.contentView).mas_offset(16);
    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).mas_offset(5);
        make.left.equalTo(self.contentView).mas_offset(16);
        make.width.mas_equalTo(290);
        make.bottom.equalTo(self.contentView).mas_offset(-15);
    }];
}

- (void)setModel:(PLChallenge *)model {
    
    self.name.text = model.user.name;
    self.location.text =  model.user.country;
}

@end
