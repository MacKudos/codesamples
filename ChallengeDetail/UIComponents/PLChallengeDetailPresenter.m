//
//  PLChallengeDetailPresenter.m
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import "PLChallengeDetailPresenter.h"
#import "PLChallengeDetailUIModel.h"
#import "PLChallengeDetailViewController.h"

#import "PLAnotherUserProfileUIModel.h"
#import "PLAnotherUserProfileViewPresenter.h"
#import "PLAnotherUserProfileViewController.h"

#import "PLAnotherChannelProfileUIModel.h"
#import "PLAnotherChannelProfileViewPresenter.h"
#import "PLAnotherChannelProfileViewController.h"

#import "PLChallengeDetailItemViewModel.h"
#import "PLChannel.h"
#import "PLImagePostThumbCollectionCell.h"

#import "PLChallengeRewardCollectionViewCell.h"
#import "PLChallengeDescriptionCollectionViewCell.h"
#import "PLChallengeParticipateCollectionViewCell.h"
#import "PLChallengeAuthorCollectionViewCell.h"
#import "PLChallengeHeadCollectionViewCell.h"
#import "PLChallengeRewardCollectionViewCell.h"
#import "PLChallengePostSectionHeader.h"

#import "PLTopicTopComponent.h"
#import "PLSession.h" //!!

#import <Masonry.h>
#import "UIView+NUI.h"

#import "PLComposeViewController.h"
#import "PLCardContentViewController.h"
#import "PLConcreteSearchComponent.h"

@implementation PLChallengeDetailPresenter
    
@synthesize dataProvider = _dataProvider;
@synthesize eventHandler = _eventHandler;
    
#pragma mark - PLChallengeDetailPresenterProtocol

- (void)registerUICellsForCollectionView:(UICollectionView *)collectionView {
    

    NSString *reuseId = NSStringFromClass([PLChallengeHeadCollectionViewCell class]);
    [collectionView registerClass:[PLChallengeHeadCollectionViewCell class] forCellWithReuseIdentifier:reuseId];

    reuseId = NSStringFromClass([PLChallengeDescriptionCollectionViewCell class]);
    [collectionView registerClass:[PLChallengeDescriptionCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    reuseId = NSStringFromClass([PLChallengeRewardCollectionViewCell class]);
    [collectionView registerClass:[PLChallengeRewardCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    
    reuseId = NSStringFromClass([PLChallengeAuthorCollectionViewCell class]);
    [collectionView registerClass:[PLChallengeAuthorCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    reuseId = NSStringFromClass([PLChallengeParticipateCollectionViewCell class]);
    [collectionView registerClass:[PLChallengeParticipateCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    reuseId = NSStringFromClass([PLImagePostThumbCollectionCell class]);
    [collectionView registerNib:[UINib nibWithNibName:reuseId bundle:nil] forCellWithReuseIdentifier:[reuseId stringByAppendingString:@"style-light"]];
    [collectionView registerNib:[UINib nibWithNibName:reuseId bundle:nil] forCellWithReuseIdentifier:[reuseId stringByAppendingString:@"style-dark"]];

    [collectionView registerClass:[PLChallengePostSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PLChallengePostSectionHeader class])];
}

- (UIViewController *)preapareCardVC {
    
    PLPost *post = [self.dataProvider selectedCard];
    
    if (post) {
        PLCardContentViewController *ctrl = [[PLCardContentViewController alloc] initWithPost:post];
        return ctrl;
    }
    
    return [UIViewController new];
}

- (UIViewController *)preapareCreatorVC {
    
    PLUser *user = [self.dataProvider creatorUser];
    
    if (user) {
        
        PLAnotherUserProfileViewController *vc = [PLAnotherUserProfileViewController new];
        PLAnotherUserProfileUIModel *UIModel = [PLAnotherUserProfileUIModel new];
        UIModel.delegate = vc;
        vc.viewPresenter = [PLAnotherUserProfileViewPresenter new];
        vc.eventHandler = UIModel;
        vc.viewPresenter.dataProvider = UIModel;
        
        [UIModel setUser:user];
        return vc;
    }
    
    return [UIViewController new];

}

- (void)setupVisualsForViewController:(PLChallengeDetailViewController *)vc {
    
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return PLChallengeDetailUIModelSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataProvider itemsCount:[NSIndexPath indexPathForRow:0 inSection:section]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *collectionCell;
    
    if (indexPath.section == PLChallengeDetailUIModelSectionHead) {
        
        PLChallengeHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLChallengeHeadCollectionViewCell class]) forIndexPath:indexPath];
        
        __weak typeof(self) weakself = self;
        cell.tapped = ^() {
            [weakself.eventHandler didSelectFollow];
        };
        [cell setModel:self.dataProvider.viewModel.challenge];
        [cell setMeta:self.dataProvider.viewModel.challengeMeta];
        collectionCell = cell;
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionDescription) {
        
        PLChallengeDescriptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLChallengeDescriptionCollectionViewCell class]) forIndexPath:indexPath];
        
        [cell setModel:self.dataProvider.viewModel.challenge];
        collectionCell = cell;
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionRewards) {
        
        PLChallengeRewardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLChallengeRewardCollectionViewCell class]) forIndexPath:indexPath];
        
        [cell setIsActiveMode:NO];
        [cell setModel:self.dataProvider.viewModel.challenge];
        collectionCell = cell;
        
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionAuthor) {
        
        PLChallengeAuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLChallengeAuthorCollectionViewCell class]) forIndexPath:indexPath];
        
        [cell setModel:self.dataProvider.viewModel.challenge];
        collectionCell = cell;
        
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionParticipate) {
        
        PLChallengeParticipateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLChallengeParticipateCollectionViewCell class]) forIndexPath:indexPath];
        
        __weak typeof(self) weakself = self;
        cell.tapped = ^() {
            [weakself.eventHandler didSelectParicipate];
        };
        
        collectionCell = cell;
        
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionPosts) {
        
        PLImagePostThumbCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSStringFromClass([PLImagePostThumbCollectionCell class]) stringByAppendingString:[PLSession session].UIStylesheetName] forIndexPath:indexPath];
        
        collectionCell = cell;
        [self fillCardCell:cell forIndex:indexPath];
    }
    
    return collectionCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    
    if (indexPath.section == PLChallengeDetailUIModelSectionPosts) {
        
        CGFloat side = floorf((width - 16*2 - 10) / 2);
        return CGSizeMake(side, side * 1.4);
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionHead) {
        
        return [self calculateSizeForIndexPath:indexPath forCollectionView:collectionView];
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionDescription) {
        
        return [self calculateSizeForIndexPath:indexPath forCollectionView:collectionView];
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionRewards) {
        
        return [self calculateSizeForIndexPath:indexPath forCollectionView:collectionView];
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionParticipate) {
        
        return CGSizeMake(width, 50);
    }
    
    if (indexPath.section == PLChallengeDetailUIModelSectionAuthor) {
        
        return CGSizeMake(width, 70);
    }
    
    return CGSizeMake(width, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == PLChallengeDetailUIModelSectionPosts) {
        return UIEdgeInsetsMake(22, 16, 22, 16);
    }
    
    if (section == PLChallengeDetailUIModelSectionRewards) {
        return UIEdgeInsetsMake(0, 13, 5, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == PLChallengeDetailUIModelSectionPosts)
        return 10;
    
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        if (indexPath.section == PLChallengeDetailUIModelSectionPosts) {
            
            PLChallengePostSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([PLChallengePostSectionHeader class]) forIndexPath:indexPath];
            
                headerView.sortByNewButton.hidden = NO;
                headerView.sortByPopularButton.hidden = NO;

                headerView.sortByNewButton.selected = (self.dataProvider.currentSort == PLChallengeDetailPostsSortTop);
                headerView.sortByPopularButton.selected = (self.dataProvider.currentSort == PLChallengeDetailPostsSortLatest);
                
                __weak typeof(self) weakSelf = self;
                headerView.popularTapped = ^() {
                    [weakSelf.eventHandler didSelectTop];
                };
                headerView.newTapped = ^() {
                    [weakSelf.eventHandler didSelectLatest];
                };
            
            view = headerView;
        }
    }
    
    return view;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    NSInteger count = [self.dataProvider itemsCount:[NSIndexPath indexPathForRow:0 inSection:section]];

    if (section == PLChallengeDetailUIModelSectionPosts) {
        if (count > 0) return CGSizeMake(width, 44);
    }
    
    return CGSizeMake(width, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(0, 0);
}


- (CGSize)calculateSizeForIndexPath:(NSIndexPath *)index
                  forCollectionView:(UICollectionView *)collectionView {
    
    UICollectionViewCell *celll;
    if (index.section == PLChallengeDetailUIModelSectionDescription) {
        
        PLChallengeDescriptionCollectionViewCell *cell = [[PLChallengeDescriptionCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, CGFLOAT_MAX)];
        
        [cell setModel:self.dataProvider.viewModel.challenge];
        celll = cell;
    }
    
    if (index.section == PLChallengeDetailUIModelSectionHead) {

        PLChallengeHeadCollectionViewCell *cell = [[PLChallengeHeadCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, CGFLOAT_MAX)];
        
        [cell setModel:self.dataProvider.viewModel.challenge];
        [cell setMeta:self.dataProvider.viewModel.challengeMeta];
        celll = cell;
    }
    
    if (index.section == PLChallengeDetailUIModelSectionRewards) {
        
        PLChallengeRewardCollectionViewCell *cell = [[PLChallengeRewardCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, CGFLOAT_MAX)];
        
        [cell setModel:self.dataProvider.viewModel.challenge];
        celll = cell;
        
        [celll setNeedsUpdateConstraints];
        [celll updateConstraintsIfNeeded];
        
        celll.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(collectionView.frame), CGFLOAT_MAX);
        
        [celll setNeedsLayout];
        [celll layoutIfNeeded];
        
        CGSize size = [celll.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 16, size.height);
    }
    
    if (!celll) return CGSizeZero;
    
    [celll setNeedsUpdateConstraints];
    [celll updateConstraintsIfNeeded];
    
    celll.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(collectionView.frame), CGFLOAT_MAX);
    
    [celll setNeedsLayout];
    [celll layoutIfNeeded];
    
    CGSize size = [celll.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), size.height);
}

- (void)fillCardCell:(PLImagePostThumbCollectionCell *) cell forIndex:(NSIndexPath *)indexPath {
    
    PLPost *post = [self.dataProvider cardViewModelForIndexPath:indexPath];
    
    cell.daysLeftView.hidden = NO;
    cell.infoView.hidden = YES;
    cell.countersHolder.hidden = NO;
    cell.commentCount = post.counters.commentsCount;
    cell.viewsCount = post.counters.viewsCount;
    cell.EPCount = @(post.votes);
    
    cell.daysLeftLabel.nuiClass = @"CardPreviewOverlayLabel";
    [cell.daysLeftLabel applyNUI];
    
    if ([post.expiresAt timeIntervalSinceNow] > 0) {
        
        NSInteger days = [self numberOfDaysUntil:post.expiresAt] + 1;
        if (days > 7) days = 7;
        cell.daysLeftLabel.text =  [NSString localizedStringWithFormat:NSLocalizedString(@"%dDayLeft", @"%dDayLeft"), (long)days];
        
    } else {
        cell.daysLeftLabel.text = NSLocalizedString(@"challenge_Finished", @"");
    }
    
    [cell displayPost:post];
}

- (NSInteger)numberOfDaysUntil:(NSDate *) date {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:date options:0];
    return [components day];
}

- (PLComposeViewController *)preapareCardComposingVCForIndex {
    
    PLComposeViewController *ctrl = [[PLComposeViewController alloc] initWithChallenge:self.dataProvider.viewModel.challenge];
    
    return ctrl;
}
@end
