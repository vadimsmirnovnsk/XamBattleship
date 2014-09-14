//
//  Preferences.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Preferences Interface

@interface Preferences : NSObject

/**
 *  Returns the username and token that stored for user.
 */
@property (nonatomic, readwrite) NSString *username;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) NSString *userid;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
