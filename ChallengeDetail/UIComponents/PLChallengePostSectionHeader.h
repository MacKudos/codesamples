//
//  PLSearchSectionHeader.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
#import "UIView+NUI.h"

@interface PLChallengePostSectionHeader : UICollectionReusableView

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIButton *sortByPopularButton;
@property (nonatomic, weak) UIButton *sortByNewButton;

@property (nonatomic, copy) void(^popularTapped)(void);
@property (nonatomic, copy) void(^newTapped)(void);

@end
