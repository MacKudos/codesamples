//
//  PLChallengeDetailItemViewModel.h
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLPost, PLChallenge, PLUser, PLChallengeMeta;

@interface PLChallengeDetailItemViewModel : NSObject

@property (nonatomic, strong) PLChallenge *challenge;
@property (nonatomic, strong) PLChallengeMeta *challengeMeta;
@property (nonatomic, strong) PLUser *author;

@end
