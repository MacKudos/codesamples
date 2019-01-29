//
//  PLChallengeDetailViewController.h
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLActivityCollectionView.h"
#import "PLChallengeDetailProtocols.h"

@interface PLChallengeDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PLChallengeDetailUIModelDelegate>

@property (nonatomic, strong) id <PLChallengeDetailPresenterProtocol> viewPresenter;
@property (nonatomic, strong) id <PLChallengeDetailUIModelEventHandlingProtocol> eventHandler;
@property (nonatomic, strong) PLActivityCollectionView *collectionView;

- (instancetype)init;
@end
