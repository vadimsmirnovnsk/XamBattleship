//
//  BSServerAPIController
//  XamBattleship
//
//  Created by Wadim on 11/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - BSServerAPIControllerDelegate Protocol

@class BSServerAPIController;
@protocol BSServerAPIControllerDelegate <NSObject>

- (void)connectionDidEstablished:(BSServerAPIController *)controller;
- (void)didSignedIn:(BSServerAPIController *)controller;
- (void)didSignedUp:(BSServerAPIController *)controller;

@end


#pragma mark - BSServerAPIController Interface

@interface BSServerAPIController : NSObject

@property (nonatomic, weak) id<BSServerAPIControllerDelegate> delegate;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *userid;

+ (instancetype) sharedController;
- (void)signUpWithUsername:(NSString *)username token:(NSString *)token;
- (void)reconnect;

@end
