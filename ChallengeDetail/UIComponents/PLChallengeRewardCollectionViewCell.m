//
//  PLChallengeRewardCollectionViewCell.m
//  Plague
//
//  Created by Sergey Devyatkin on 9/12/18.
//  Copyright © 2018 Plag. All rights reserved.
//

#import "PLChallengeRewardCollectionViewCell.h"
#import <Masonry.h>
#import "UIView+NUI.h"
#import "PLAutoSizingLabel.h"
#import <SafariServices/SafariServices.h>
#import "PLAppDelegate.h"
#import "PLLinkHandler.h"
#import "PLChallengeService.h"
#import "PLServiceHolder.h"

@interface PLChallengeRewardCollectionViewCell () <UITextViewDelegate>
@property (nonatomic, weak) UITextView *commonLabel;
@property (nonatomic, assign) BOOL isHeightCalculated;
@end

@implementation PLChallengeRewardCollectionViewCell

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
    self.commonLabel = textView;
    
    self.commonLabel.backgroundColor = [UIColor clearColor];
    self.commonLabel.scrollEnabled = NO;
    self.commonLabel.bounces = NO;
    self.commonLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular];
    self.commonLabel.nuiClass = @"ActivityTimeText";
    self.commonLabel.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
    self.commonLabel.delegate = self;
    self.commonLabel.scrollEnabled = NO;
    self.commonLabel.editable = NO;
    self.commonLabel.selectable = YES;
    self.commonLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    
    UIColor *linkColor = [NUISettings getColor:@"font-color" withClass:@"DefaultTextLabel"];
    
    self.commonLabel.linkTextAttributes =  @{ NSForegroundColorAttributeName : linkColor};
    
    UIEdgeInsets textViewInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.commonLabel.contentInset = textViewInsets;
    self.commonLabel.scrollIndicatorInsets = textViewInsets;
}

- (void)makeLayout {
    
    [self.commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
}

- (void)setIsActiveMode:(BOOL)isActiveMode {
    _isActiveMode = isActiveMode;
    self.commonLabel.nuiClass = (!isActiveMode)? @"ActivityTimeText" : @"TextLabel";
    [self.commonLabel applyNUI];
}

- (void)setModel:(PLChallenge *)model {
    
    _model = model;
    if (_model.type == PLChallengeTypeCollaboration) {
        [self setupCollaboration];
    } else if (_model.type == PLChallengeTypeCompetition) {
        [self setupCompetion];
    }
}

- (void)setupCompetion {
    
    PLChallengeService *serv = [PLServiceHolder sharedInstance].challengeService;
    
    if ([self.model.expiresAt timeIntervalSinceNow] > 0 || self.isActiveMode) {
        NSString *text = NSLocalizedString(@"challenge_reward_1", @"");
        NSInteger first = [self.model.reward integerValue] * [serv.competMeta.firstPlace floatValue];
        NSInteger second = [self.model.reward integerValue] * [serv.competMeta.secondPlace floatValue];
        NSInteger third = [self.model.reward integerValue] * [serv.competMeta.thirdPlace floatValue];
        NSInteger random = [self.model.reward integerValue] * [serv.competMeta.random floatValue];
        
        text = [text stringByReplacingOccurrencesOfString:@"<1th>" withString:[@(first) stringValue]];
        text = [text stringByReplacingOccurrencesOfString:@"<2th>" withString:[@(second) stringValue]];
        text = [text stringByReplacingOccurrencesOfString:@"<3th>" withString:[@(third) stringValue]];
        text = [text stringByReplacingOccurrencesOfString:@"<4th>" withString:[@(random) stringValue]];
        self.commonLabel.text = text;
        
    } else {
        
        NSArray <PLChallengeWinner *> *winners = self.model.winners;
        if (winners.count == 0) return;
        
        NSString *text = NSLocalizedString(@"challenge_reward_1_finish", @"");
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"ActivityTimeText"]}];
        
        for (PLChallengeWinner *winner in winners) {
            
            NSInteger i = 0;
            
            if ([winner.position containsString:@"1st"]) {
                i = 1;
            } else if ([winner.position containsString:@"2nd"]) {
                i = 2;
            } else if ([winner.position containsString:@"3rd"]) {
                i = 3;
            } else if ([winner.position containsString:@"random"]) {
                i = 4;
            }
            
            NSString *indexReward= [NSString stringWithFormat:@"<%lith>", i];
            NSString *indexPlace = [NSString stringWithFormat:@"<%lith_u>", i];
            NSString *reward = [@([winner.reward integerValue]/1000000) stringValue];
            [title replaceCharactersInRange:[title.string rangeOfString:indexReward] withString:reward];
            
            if (winner.user.name) {
                [title replaceCharactersInRange:[title.string rangeOfString:indexPlace] withString:winner.user.name];
                [title setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"DefaultTextLabel"]} range:[title.string rangeOfString:winner.user.name]];
                
                [title addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"http://sola.ai/%@", winner.user.slug]  range:[title.string rangeOfString:winner.user.name]];
            }
        }
        
        self.commonLabel.attributedText = title;
    }
}

- (void)setupCollaboration {
    
    PLChallengeService *serv = [PLServiceHolder sharedInstance].challengeService;
    
    if ([self.model.expiresAt timeIntervalSinceNow] > 0 || self.isActiveMode) {
        
        NSString *text = NSLocalizedString(@"challenge_reward_2", @"");
        NSInteger random = [self.model.reward integerValue] * [serv.competMeta.random floatValue];
        text = [text stringByReplacingOccurrencesOfString:@"<4th>" withString:[@(random) stringValue]];
        text = [text stringByReplacingOccurrencesOfString:@"<SOL>" withString:[self.model.reward stringValue]];
        
        self.commonLabel.text = text;
    } else {

        PLChallengeWinner *winner = [self.model.winners firstObject];
        NSString *text = NSLocalizedString(@"challenge_reward_2_finish", @"");
        NSNumber *random = @([winner.reward integerValue]/1000000);
        NSString *stringName = winner.user.name;
        if (!stringName) stringName = @"";
        text = [text stringByReplacingOccurrencesOfString:@"<4th_u>" withString:stringName];
        text = [text stringByReplacingOccurrencesOfString:@"<4th>" withString:[random stringValue]];
        text = [text stringByReplacingOccurrencesOfString:@"<SOL>" withString:[self.model.reward stringValue]];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"ActivityTimeText"]}];
        
        if (winner.user.name) {
            [title setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [NUISettings getColor:@"font-color" withClass:@"DefaultTextLabel"]} range:[title.string rangeOfString:stringName]];
            
            [title addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"http://sola.ai/%@", winner.user.slug]  range:[title.string rangeOfString:stringName]];
        }
        
        self.commonLabel.attributedText = title;
    }
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

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    layoutAttributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    if (!self.isHeightCalculated) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
        CGRect newFrame = layoutAttributes.frame;
        // note: don't change the width
        newFrame.size.height = ceilf(size.height);
        layoutAttributes.frame = newFrame;
        self.isHeightCalculated = YES;
    }
    
    return layoutAttributes;
}

@end
