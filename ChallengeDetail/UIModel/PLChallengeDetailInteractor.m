//
//  PLMutedTabInteractor.m
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import "PLChallengeDetailInteractor.h"

#import "PLServiceHolder.h"
#import "PLChallengeService.h"

@interface PLChallengeDetailInteractor()
@property (nonatomic, strong) PLChallengeRequest *params;
@end

@implementation PLChallengeDetailInteractor

@synthesize sort = _sort;
    
- (instancetype)init {
    self = [super init];
    self.params = [PLChallengeRequest new];
    self.params.limit = @(20);
    self.sort = PLChallengeDetailPostsSortTop;
    return self;
}

- (void)setSort:(PLChallengeDetailPostsSort)sort {
    
    _sort = sort;
    
    self.params.nextPage = nil;
    self.params.prevPage = nil;
    self.params.sort = (_sort == PLChallengeDetailPostsSortTop)? @"top" : @"latest";
}

- (BOOL)isMore {
    return self.params.nextPage != nil;
}
    
- (FBLPromise<PLChallenge *> *)obtainChallengeWithId:(NSString *)challengeId {
    
    self.params.chid = challengeId;
    
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
            {
                [[PLServiceHolder sharedInstance].challengeService obtainChallenge:self.params
                                                                    withCompletion:^(PLChallenge *challenge, NSError *error)
                 {
                     if (error) reject(error);
                     fulfill(challenge);
                 }];
            }];
}
    
- (FBLPromise<NSArray <PLPost *> *> *)loadPostsForChallenge:(NSString *)challengeId {
    
    self.params.chid = challengeId;
    
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
            {
                [[PLServiceHolder sharedInstance].challengeService loadPostsForChallenge:self.params withCompletion:^(NSArray<PLPost *> *posts, NSError * error)
                 {
                      if (error) reject(error);
                      fulfill(posts);
               }];
            }];
}

- (FBLPromise<PLChallengeMeta *> *)laodChallengeMeta:(NSString *)chid {
    
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
            {
                [[PLServiceHolder sharedInstance].challengeService laodChallengeMeta:chid
                                                              completion:^(PLChallengeMeta *meta, NSError *error)
                {
                    if (error) reject(error);
                    fulfill(meta);
                }];
            }];
}
    
- (FBLPromise<PLChallengeMeta *> *)unsubsrcibeForChallenge:(NSString *)chid {
    
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
            {
                [[PLServiceHolder sharedInstance].challengeService unSubsrcibeForChallenge:chid
                                                                                completion:^(id item, NSError *error)
                 {
                     if (error) reject(error);
                     fulfill(nil);
                 }];
            }];
}
    
- (FBLPromise<PLChallengeMeta *> *)subsrcibeForChallenge:(NSString *)chid {
   
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
    {
        [[PLServiceHolder sharedInstance].challengeService subsrcibeForChallenge:chid
                                                                  completion:^(id item, NSError *error)
        {
            if (error) reject(error);
            fulfill(nil);
        }];
    }];
}
    
- (FBLPromise<PLPrioritizedItemModel *> *)follow:(BOOL)isAcivate forChallenge:(NSString *)chid {
        
    return [FBLPromise onQueue:dispatch_get_main_queue()
                         async:^(FBLPromiseFulfillBlock fulfill,
                                 FBLPromiseRejectBlock reject)
            {
                [[PLServiceHolder sharedInstance].challengeService  prioritize:isAcivate
                                                                     challenge:chid completion:^(PLPrioritizedItemModel *item, NSError *error)
                 {
                     if (error) reject(error);
                     fulfill(nil);
                 }];
            }];
}

@end
