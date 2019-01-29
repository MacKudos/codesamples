//
//  PLChallengeParticipateCollectionViewCell.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLChallengeParticipateCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void(^tapped)(void);
@end
