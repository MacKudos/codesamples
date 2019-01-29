//
//  PLUserProfileBioCollectionViewCell.m
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/17.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import "PLChallengeDescriptionCollectionViewCell.h"
#import <Masonry.h>
#import "UIView+NUI.h"
#import "PLAutoSizingLabel.h"
#import <SafariServices/SafariServices.h>
#import "PLAppDelegate.h"
#import "PLLinkHandler.h"
#import "PLChallengeService.h"

@interface PLChallengeDescriptionCollectionViewCell () <UITextViewDelegate>
@property (nonatomic, weak) UITextView *bioLabel;
@end

@implementation PLChallengeDescriptionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        [self makeLayout];
    }
    return self;
}

- (void)createViews {
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:textView];
    self.bioLabel = textView;
    
    self.bioLabel.backgroundColor = [UIColor clearColor];
    self.bioLabel.scrollEnabled = NO;
    self.bioLabel.bounces = NO;
    self.bioLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    self.bioLabel.nuiClass = @"TextLabel";
    self.bioLabel.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
    self.bioLabel.delegate = self;
    self.bioLabel.scrollEnabled = NO;
    self.bioLabel.editable = NO;
    self.bioLabel.selectable = YES;
    self.bioLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    
    UIColor *linkColor = UIColorFromRGB(0x7AC4FF);
    
    self.bioLabel.linkTextAttributes =  @{ NSForegroundColorAttributeName : linkColor};
    
    UIEdgeInsets textViewInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.bioLabel.contentInset = textViewInsets;
    self.bioLabel.scrollIndicatorInsets = textViewInsets;
}

- (void)makeLayout {
    
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.greaterThanOrEqualTo(@1);
    }];
}

- (void)setModel:(PLChallenge *)model {
    
    _model = model;
    self.bioLabel.text = model.descrip;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL absoluteString] containsString:@"http"]) {
    
        PLAppDelegate *delegate = (PLAppDelegate*) [UIApplication sharedApplication].delegate;

        PLLinkHandler *linkHandler = [PLLinkHandler new];
        [linkHandler openUrl:URL fromParentController:[delegate topMostController] navigationController:nil];
        
        return NO;
    }
    return YES;
}

@end
