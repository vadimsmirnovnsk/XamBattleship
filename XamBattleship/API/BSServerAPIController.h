//
//  BSServerAPIController
//  XamBattleship
//
//  Created by Wadim on 11/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - BSServerAPIController Interface

@interface BSServerAPIController : NSObject

+ (instancetype) sharedController;
- (void)signUpWithUsername:(NSString *)username token:(NSString *)token;
- (void)reconnect;

@end
