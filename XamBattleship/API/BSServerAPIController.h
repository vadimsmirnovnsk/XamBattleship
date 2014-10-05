//
//  BSServerAPIController
//  XamBattleship
//
//  Created by Wadim on 11/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kBaseAPIURL = @"ws://178.62.133.63:8008"; // @"ws://echo.websocket.org";//

static NSString *const kEventField = @"event";
static NSString *const kEventFieldParameterSignIn = @"signin";
static NSString *const kEventFieldParameterStats = @"stats";
static NSString *const kEventFieldParameterReady = @"ready";

static NSString *const kDataField = @"data";
// "event" = "signin"
static NSString *const kDataFieldParameterName = @"name";
static NSString *const kDataFieldParameterToken = @"token";
static NSString *const kDataFieldParameterResult = @"result";
static NSString *const kDataFieldParameterResultFailed = @"failed";
static NSString *const kDataFieldParameterResultSignedIn = @"signedin";
static NSString *const kDataFieldParameterResultSignedUp = @"signedup";

//static NSString *const kMessageField = @"message";
//static NSString *const kMessageFieldParameterSignedIn = @"successfuly signed in";
//static NSString *const kMessageFieldParameterSignedUp = @"A new user created for you";
//static NSString *const kMessageFieldParameterInvalidToken = @"invalid token";

//static NSString *const kUserIDField = @"_id";
//static NSString *const kUserNameField = @"name";
//static NSString *const kTokenField = @"token";


#pragma mark - BSServerAPIControllerDelegate Protocol

@class BSServerAPIController;
@protocol BSServerAPIControllerDelegate <NSObject>

@required
- (void)connectionDidLost:(BSServerAPIController *)controller;

@optional
- (void)connectionDidEstablished:(BSServerAPIController *)controller;
- (void)didSignedIn:(BSServerAPIController *)controller;
- (void)didSignedUp:(BSServerAPIController *)controller;
- (void)didSignInFailed:(BSServerAPIController *)controller;

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
- (void)openConnection;
- (void)closeConnection;

@end
