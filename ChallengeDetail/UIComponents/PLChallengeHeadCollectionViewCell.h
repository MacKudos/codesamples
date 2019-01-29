//
//  PLChallengeHeadCollectionViewCell.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLChallenge, PLChallengeMeta;

@interface PLChallengeHeadCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) PLChallenge *model;
@property (nonatomic, strong) PLChallengeMeta *meta;
@property (nonatomic, copy) void(^tapped)(void);
@end
