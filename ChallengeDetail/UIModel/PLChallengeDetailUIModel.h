//
//  PLChallengeDetailUIModel.h
//  Sola
//
//  Created by Sergey Devyatkin on 9/7/18.
//  Copyright © 2017 We Heart Pics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLChallengeDetailProtocols.h"

@interface PLChallengeDetailUIModel : NSObject <PLChallengeDetailUIModelDataProvidingProtocol, PLChallengeDetailUIModelEventHandlingProtocol, PLChallengeDetailUIModelSetupProtocol>
@end
