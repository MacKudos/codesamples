//
//  PLChallengeDetailUIModel.m
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import "PLChallengeDetailUIModel.h"
#import "PLMutedItemModel.h"
#import "PLMutedTabInteractor.h"
#import "PLSession.h"
#import "PLMutedItemViewModel.h"
#import "PLChannel.h"
#import "PLUser.h"
#import "PLServiceHolder.h"
#import "PLChallengeService.h"

#import "PLChallengeDetailItemViewModel.h"
#import "PLChallengeDetailInteractor.h"

@interface PLChallengeDetailUIModel ()
@property (nonatomic, strong) NSArray <PLPost *> *posts;
@property (nonatomic, strong) PLChallengeMeta *challengeMeta;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (atomic, assign) BOOL isMoreLoading;
@end

@implementation PLChallengeDetailUIModel
    
@synthesize challenge = _challenge;
@synthesize delegate = _delegate;
@synthesize interactor = _interactor;
    
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.posts = @[];
    }
    return self;
}

- (void)performDataLoading {
    
    self.posts = @[];
    [self.delegate pleaseReload];
    [self.delegate pleaseShowLoader];
    
    [self.interactor  obtainChallengeWithId:self.challenge.chid].then(^id (PLChallenge *challenge) {
        
        self.challenge = challenge;
        return [self.interactor laodChallengeMeta:self.challenge.chid];
        
    }).then(^id (PLChallengeMeta *meta) {
        
        self.challengeMeta = meta;
        [self.delegate pleaseSetSubActive:meta.isSubscribed];
        
        return [self.interactor loadPostsForChallenge:self.challenge.chid];
        
    }).then(^id (NSArray <PLPost *> *posts) {
        
        self.posts = [posts copy];
        return nil;
        
    }).catch(^(NSError * _Nonnull error) {
        
        [self.delegate pleaseVisualizeError:error];
        
    }).always(^{
        
        [self.delegate pleaseHideLoader];
        [self.delegate pleaseReload];
    });
}

- (void)reloadPosts {
    
    self.posts = @[];
    [self.delegate pleaseReload];
    [self.delegate pleaseShowLoader];
    
    [self.interactor loadPostsForChallenge:self.challenge.chid].then(^id (NSArray <PLPost *> *posts) {
        
        self.posts = [posts copy];
        if ([self.posts count] == 0) {
            [self.delegate pleaseShowStateEmpty:YES];
        }
        return nil;
        
    }).catch(^(NSError * _Nonnull error) {
        
        [self.delegate pleaseVisualizeError:error];
        [[PLSession session] showError:error catchCode:NO];
        
    }).always(^{
        
        [self.delegate pleaseHideLoader];
        [self.delegate pleaseReload];
    });
    
}

- (void)loadMore {
    
    if (![self isMore]) return;
    if (self.isMoreLoading) return;
    self.isMoreLoading = YES;
    
    [self.interactor loadPostsForChallenge:self.challenge.chid].then(^id (NSArray <PLPost *> *posts) {
        
        NSInteger resultsSize = [self.posts count];
        self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
        self.isMoreLoading = NO;
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        
        for (NSInteger i = resultsSize; i < resultsSize + posts.count; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:PLChallengeDetailUIModelSectionPosts]];
        }
        [self.delegate pleaseInsertItmes:arrayWithIndexPaths];
        
        return nil;
        
    }).catch(^(NSError * _Nonnull error) {
        //
    }).always(^{
        [self.delegate pleaseHideLoader];
        [self.delegate pleaseReload];
    });
}


#pragma mark - PLChallengeDetailUIModelEventHandlingProtocol

- (void)rootViewDidLoadEvent {
    [self performDataLoading];
}

- (void)rootViewWillDisapearEvent {
    //
}

- (void)rootViewWillApearEvent {
    //
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexpath {
    
    if (indexpath.section == PLChallengeDetailUIModelSectionAuthor) {
        [self.delegate pleaseShowCreatorProfile];
    }
    if (indexpath.section == PLChallengeDetailUIModelSectionPosts) {
        
        self.selectedIndexPath = indexpath;
        [self.delegate pleaseShowSelectedCard];
    }
}

- (void)didSelectFollow {

    BOOL isAcivate;
    
    if (self.viewModel.challengeMeta.isPrioritized) {
        isAcivate = NO;
    } else {
        isAcivate = YES;
    }
    
    [self.interactor follow:isAcivate forChallenge:self.challenge.chid].then(^id (id value) {
        self.viewModel.challengeMeta.isPrioritized = isAcivate;
        [self.delegate pleaseSetFollowActive:isAcivate];
        return nil;
    });
}

- (void)didSelectParicipate {
    [self.delegate pleaseShowCardComposing];
}


- (void)didSelectSubscribe {
    
    if (!self.viewModel.challengeMeta.isSubscribed) {
        
        [self.interactor subsrcibeForChallenge:self.challenge.chid].then(^id (id value) {
          self.viewModel.challengeMeta.isSubscribed = YES;
          [self.delegate pleaseSetSubActive:YES];
          return nil;
        });
        
    } else {
        
        [self.interactor unsubsrcibeForChallenge:self.challenge.chid].then(^id (id value) {
            self.viewModel.challengeMeta.isSubscribed = YES;
            [self.delegate pleaseSetSubActive:YES];
            return nil;
        });
    }
}

- (void)didSelectShare {
    
    NSString *slug = [NSString stringWithFormat:@"https://sola.ai/challenges/%@?r=%@", self.challenge.slug, [[PLServiceHolder sharedInstance].sessionService obtainCurrentUser].slug];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = slug;

//    PLInviteComponent *cmp = [[PLInviteComponent alloc] initWithLink:slug];
//    cmp.vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//
//    [self.delegate placseShowShareVc:cmp.vc];
}

- (void)didSelectLatest {
    
    self.interactor.sort = PLChallengeDetailPostsSortLatest;
    [self reloadPosts];
}

- (void)didSelectTop {

    self.interactor.sort = PLChallengeDetailPostsSortTop;
    [self reloadPosts];
}


#pragma mark - PLChallengeDetailUIModelDataProvidingProtocol

- (NSInteger)itemsCount:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case PLChallengeDetailUIModelSectionPosts:
            return [self.posts count];
            break;
        case PLChallengeDetailUIModelSectionParticipate:
            return ([self.challenge.uid isEqualToString:[PLServiceHolder sharedInstance].sessionService.obtainCurrentUser.uid] || !([self.challenge.expiresAt timeIntervalSinceNow] > 0))? 0 : 1;
            break;
        default:
            return 1;
    }
}

- (PLChallengeDetailItemViewModel *)viewModel {
    
    PLChallengeDetailItemViewModel *model = [PLChallengeDetailItemViewModel new];
    model.challenge = self.challenge;
    model.challengeMeta = self.challengeMeta;
    return model;
}

- (PLPost *)cardViewModelForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != PLChallengeDetailUIModelSectionPosts) return nil;
    
    if (indexPath.row >= self.posts.count - 10) {
        [self loadMore];
    }
    
    if (indexPath.row > [self.posts count])
        return nil;
    
    PLPost *post = self.posts[indexPath.row];
    
    if ([post hasPoll])
        post.needLoad = YES;
    
    return post;
}

- (PLPost *)selectedCard {
    
    if (self.selectedIndexPath.section == PLChallengeDetailUIModelSectionPosts)
        return [self cardViewModelForIndexPath:self.selectedIndexPath];
    
    return nil;
}

- (PLUser *)creatorUser {
    return self.challenge.user;
}


- (BOOL)isMore {
    return self.interactor.isMore;
}

- (PLChallengeDetailPostsSort)currentSort {
    return self.interactor.sort;
}

- (BOOL)isCompetition {
    return self.challenge.type == PLChallengeTypeCompetition;
}
    
    
#pragma mark - PLComposeViewControllerDelegate
    
- (void)composeViewController:(PLComposeViewController *)ctrl didSendPost:(PLPost*)post {
    [self.delegate pleaseShowActivityView];
}
    
- (void)composeViewControllerDidFinishSend:(PLComposeViewController *)ctrl {
    
    [self.delegate pleaseHideActivityView];
    [self.delegate pleaseCloseDraft];
}
    
- (void)composeViewController:(PLComposeViewController *)ctrl didSendWithError:(NSError*)error {
    
    [self.delegate pleaseVisualizeComposeError:error];
    [self.delegate pleaseHideActivityView];
}
    
- (void)composeViewController:(PLComposeViewController *)ctrl didSendWithProgress:(float)progress {
    
}
    
- (void)composeViewControllerDidCancel:(PLComposeViewController *)ctrl {
    [self.delegate pleaseCloseDraft];
}
    
- (void)composeViewController:(PLComposeViewController *)ctrl updateProgress:(CGFloat)progress {
    
}
@end
