//
//  PLChallengeRewardCollectionViewCell.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLChallenge;

@interface PLChallengeRewardCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) PLChallenge *model;
@property (nonatomic, assign) BOOL isActiveMode;
@end
