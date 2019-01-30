//
//  Header.h
//  Plague
//
//  Created by Sergey Devyatkin on 9/5/18.
//  Copyright © 2019 Plag. All rights reserved.
//

#import "PLChallengeDetailItemViewModel.h"
#import <PromisesObjC/FBLPromises.h>

@class PLChallenge, PLChallengeRequest, PLPrioritizedItemModel, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PLChallengeDetailViewController, PLChallengeDetailItemViewModel, PLPost, PLChallenge, PLChallengeDetailInteractor;

@protocol PLComposeViewControllerDelegate;


typedef enum : NSUInteger {
    PLChallengeDetailUIModelSectionHead,
    PLChallengeDetailUIModelSectionDescription,
    PLChallengeDetailUIModelSectionRewards,
    PLChallengeDetailUIModelSectionAuthor,
    PLChallengeDetailUIModelSectionParticipate,
    PLChallengeDetailUIModelSectionPosts,
    PLChallengeDetailUIModelSectionCount
} PLChallengeDetailUIModelSection;


typedef enum : NSUInteger {
    PLChallengeDetailPostsSortLatest,
    PLChallengeDetailPostsSortTop,
} PLChallengeDetailPostsSort;

@protocol PLChallengeDetailUIModelDelegate <NSObject>
    
- (void)pleaseReload;
- (void)pleaseShowLoader;
- (void)pleaseHideLoader;
- (void)pleaseVisualizeError:(NSError *) error;
- (void)pleaseShowSelectedCard;
- (void)pleaseShowCreatorProfile;
- (void)pleaseShowStateEmpty:(BOOL)isEmpty;
- (void)pleaseReloadPosts;
- (void)pleaseSetSubActive:(BOOL)isActive;
- (void)pleaseSetFollowActive:(BOOL)isActive;
- (void)pleaseInsertItmes:(NSArray <NSIndexPath *> *)indexes;
- (void)pleaseVisualizeComposeError:(NSError *)error;
- (void)pleaseShowCardComposing;
- (void)pleaseShowActivityView;
- (void)pleaseHideActivityView;
- (void)pleaseCloseDraft;
- (void)placseShowShareVc:(UIViewController *)vc;
@end


@protocol PLChallengeDetailUIModelEventHandlingProtocol <NSObject, PLComposeViewControllerDelegate>
    
- (void)rootViewDidLoadEvent;
- (void)rootViewWillApearEvent;
- (void)rootViewWillDisapearEvent;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexpath;
- (void)didSelectTop;
- (void)didSelectLatest;
- (void)didSelectFollow;
- (void)didSelectParicipate;
- (void)didSelectSubscribe;
- (void)didSelectShare;
@end


@protocol PLChallengeDetailUIModelDataProvidingProtocol <NSObject>
    
@property (nonatomic, readonly) PLChallenge *challenge;
@property (nonatomic, readonly) PLPost *selectedCard;
@property (nonatomic, readonly) PLUser *creatorUser;
@property (nonatomic, readonly) PLChallengeDetailPostsSort currentSort;
@property (nonatomic, readonly) PLChallengeDetailItemViewModel *viewModel;
@property (nonatomic, readonly) BOOL isMore;
@property (nonatomic, readonly) BOOL isCompetition;
    
- (NSInteger)itemsCount:(NSIndexPath *)indexPath;
- (PLPost *)cardViewModelForIndexPath:(NSIndexPath *)indexPath;
@end


@protocol PLChallengeDetailInteractorProtocol <NSObject>
    
@property (nonatomic, readonly) BOOL isMore;
@property (nonatomic, assign) PLChallengeDetailPostsSort sort;
    
- (FBLPromise<PLChallenge *> *)obtainChallengeWithId:(NSString *)challengeId;
- (FBLPromise<NSArray <PLPost *> *> *)loadPostsForChallenge:(NSString *)challengeId;
- (FBLPromise<PLChallengeMeta *> *)laodChallengeMeta:(NSString *)challengeId;
- (FBLPromise<PLChallengeMeta *> *)subsrcibeForChallenge:(NSString *)chid;
- (FBLPromise<PLChallengeMeta *> *)unsubsrcibeForChallenge:(NSString *)chid;
- (FBLPromise<PLPrioritizedItemModel *> *)follow:(BOOL)isAcivate
                                    forChallenge:(NSString *)chid;
@end


@protocol PLChallengeDetailUIModelSetupProtocol <NSObject>
    
@property (nonatomic, strong) PLChallenge *challenge;
@property (nonatomic, weak) id <PLChallengeDetailUIModelDelegate> delegate;
@property (nonatomic, strong) id <PLChallengeDetailInteractorProtocol> interactor;
@end

@protocol PLChallengeDetailPresenterProtocol <NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
    
@property (nonatomic, strong) id <PLChallengeDetailUIModelDataProvidingProtocol> dataProvider;
@property (nonatomic, strong) id <PLChallengeDetailUIModelEventHandlingProtocol> eventHandler;
    
- (void)registerUICellsForCollectionView:(UICollectionView *)collectionView;
- (void)setupVisualsForViewController:(PLChallengeDetailViewController *)vc; //should be over protocol binding
- (UIViewController *)preapareCreatorVC;
- (UIViewController *)preapareCardVC;
- (UIViewController *)preapareCardComposingVCForIndex;
@end

