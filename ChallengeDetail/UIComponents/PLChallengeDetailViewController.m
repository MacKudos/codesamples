//
//  PLChallengeDetailViewController.m
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import "PLChallengeDetailViewController.h"
#import <Masonry.h>
#import "UIView+NUI.h"

#import "PLServiceHolder.h"
#import "PLSession.h"
#import "PLLinkHandler.h"
#import "PLComposeViewController.h"
#import "PLActivityView.h"

@interface PLChallengeDetailViewController ()
@property (nonatomic, strong) UIBarButtonItem *subsribeBarButtonItem;
@property (nonatomic, strong) PLActivityView *activityView;
@property (nonatomic, strong) PLComposeViewController *draftComposeViewController;
@end

@implementation PLChallengeDetailViewController

- (instancetype)init {
    
    self = [super init];
    self.hidesBottomBarWhenPushed = YES;
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createViews];
    [self createLayout];
    
    [self.viewPresenter registerUICellsForCollectionView:self.collectionView];
    [self.viewPresenter setupVisualsForViewController:self];
    
    [self.eventHandler rootViewDidLoadEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.eventHandler rootViewWillApearEvent];
}

- (void)createViews {
    
    if ([self.navigationController.viewControllers count] <= 1) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-close-icon"]
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(closeClicked)];
        self.navigationItem.leftBarButtonItem = doneButton;
    }
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(1, 1);
    
    self.collectionView = [[PLActivityCollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.nuiClass = @"BackgroundView";
    self.collectionView.emptyPlaceHolder = NSLocalizedString(@"SearchNoResult", @"");
    [self.collectionView applyNUI];
    
    [self.view addSubview:self.collectionView];
    
    self.navigationController.navigationBar.nuiClass = @"TopToolbar";
    [self.navigationController.navigationBar applyNUI];
    
    NSString *style = [[PLServiceHolder sharedInstance].sessionService obtainCurrentSession].UIStylesheetName;
    self.collectionView.loadingIndicatorStyle = ([style isEqualToString:@"style-light"])?  UIActivityIndicatorViewStyleGray : UIActivityIndicatorViewStyleWhite;
    
    _subsribeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-subscribe-ic.png"] style:UIBarButtonItemStylePlain target:self.eventHandler action:@selector(didSelectSubscribe)];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-share-ic.png"] style:UIBarButtonItemStylePlain target:self.eventHandler action:@selector(didSelectShare)];
    self.navigationItem.rightBarButtonItems = @[shareItem, _subsribeBarButtonItem];
}

- (void)createLayout {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(0);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)closeClicked {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewPresenter numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewPresenter collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewPresenter collectionView:(UICollectionView *)collectionView  cellForItemAtIndexPath:(NSIndexPath *)indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewPresenter collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [self.viewPresenter collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.viewPresenter collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    return  [self.viewPresenter  collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return  [self.viewPresenter  collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self.viewPresenter collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.eventHandler didSelectItemAtIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - PLUserActivityUIModelDelegate

- (void)pleaseReload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)pleaseShowLoader {
    self.collectionView.activityStatus = PLActivityCollectionViewStatusLoading;
}

- (void)pleaseHideLoader {
    self.collectionView.activityStatus = PLActivityCollectionViewStatusDefault;
}

- (void)pleaseVisualizeError:(NSError *)error {
    self.collectionView.activityStatus = error.code == kCFURLErrorNotConnectedToInternet ? PLActivityTableViewStatusInternetError : PLActivityTableViewStatusServerError;
}

- (void)pleaseShowCreatorProfile {
    
    UIViewController *vc = [self.viewPresenter preapareCreatorVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pleaseShowSelectedCard {
    
    UIViewController *vc = [self.viewPresenter preapareCardVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pleaseReloadPosts {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:PLChallengeDetailUIModelSectionPosts]];
    });
}


- (void)pleaseShowStateEmpty:(BOOL)isEmpty {
    
    if (isEmpty)
        self.collectionView.activityStatus = PLActivityCollectionViewStatusEmpty;
    else
        self.collectionView.activityStatus = PLActivityCollectionViewStatusDefault;
}

- (void)pleaseInsertItmes:(NSArray <NSIndexPath *> *)indexes {
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexes];
    } completion:^(BOOL finished) {
    }];
}

- (void)pleaseSetSubActive:(BOOL)isActive {

    _subsribeBarButtonItem.image = [UIImage imageNamed:isActive ? @"nav-unsubscribe-ic.png": @"nav-subscribe-ic.png"];
}

- (void)pleaseSetFollowActive:(BOOL)isActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:PLChallengeDetailUIModelSectionHead]];
    });
}

- (void)pleaseVisualizeComposeError:(NSError *)error {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Error", @"")
                                 message:error.localizedDescription
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"")style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    [_draftComposeViewController presentViewController:alert animated:YES completion:nil];
}

- (void)pleaseShowCardComposing {
    self.draftComposeViewController = [self.viewPresenter preapareCardComposingVCForIndex];
    if (!self.draftComposeViewController) return;
    
    self.draftComposeViewController.delegate = self.eventHandler;
    [self presentViewController:(UIViewController * _Nonnull )self.draftComposeViewController animated:YES completion:nil];
}

- (void)pleaseShowActivityView {
    
    if (!self.activityView) {
        self.activityView = [PLActivityView loadFromNIB];
    }
    
    [_activityView showInView:_draftComposeViewController.view];
}

- (void)pleaseHideActivityView {
    [self.activityView hide];
}

- (void)pleaseCloseDraft {
    [self dismissViewControllerAnimated:YES completion:^{
        self.draftComposeViewController = nil;
    }];
}

- (void)placseShowShareVc:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

@end
