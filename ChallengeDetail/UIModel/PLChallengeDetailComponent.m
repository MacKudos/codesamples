//
//  PLChallengeDetailComponent.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengeDetailComponent.h"
#import "PLChallengeDetailInteractor.h"
#import "PLChallengeDetailUIModel.h"
#import "PLChallengeDetailViewController.h"
#import "PLChallengeDetailPresenter.h"


@interface PLChallengeDetailComponent ()
    
@property (nonatomic, readwrite) id model;
@property (nonatomic, readwrite) UIViewController *vc;
@property (nonatomic, readwrite) id presenter;
@end

@implementation PLChallengeDetailComponent

+ (instancetype)initWithChallenge:(PLChallenge *)challenge {
    
    PLChallengeDetailComponent *component = [PLChallengeDetailComponent new];
    PLChallengeDetailUIModel *UIModel = [PLChallengeDetailUIModel new];
    [UIModel setChallenge:challenge];
    [UIModel setInteractor:[PLChallengeDetailInteractor new]];
    
    PLChallengeDetailViewController *vc = [PLChallengeDetailViewController new];
 
    UIModel.delegate = vc;
    vc.viewPresenter = [PLChallengeDetailPresenter new];
    vc.eventHandler = UIModel;
    vc.viewPresenter.eventHandler = UIModel;
    vc.viewPresenter.dataProvider = UIModel;
    
    component.vc = vc;
    component.model = UIModel;
    component.presenter = vc.viewPresenter;
    
    return component;
}
@end
