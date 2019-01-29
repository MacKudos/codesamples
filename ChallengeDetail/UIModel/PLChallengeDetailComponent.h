//
//  PLChallengeDetailComponent.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLChallenge;

@interface PLChallengeDetailComponent : NSObject
@property (nonatomic, readonly) id model;
@property (nonatomic, readonly) UIViewController *vc;
@property (nonatomic, readonly) id presenter;

+ (instancetype)initWithChallenge:(PLChallenge *)challenge;
@end



