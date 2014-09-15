//
//  Preferences.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kUsernameKey = @"username";
static NSString *const kTokenKey = @"token";
static NSString *const kUserIDKey = @"id";

#pragma mark - Preferences Interface

@interface Preferences : NSObject

/**
 *  Returns the username and token that stored for user.
 */
@property (nonatomic, readwrite) NSString *username;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) NSString *userid;
@property (nonatomic, readwrite) NSArray /* of NSDictionary's */ *users;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
