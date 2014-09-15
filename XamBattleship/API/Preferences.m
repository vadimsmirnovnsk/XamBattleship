//
//  Preferences.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "Preferences.h"

static NSString *const kUsersArrayKey = @"users";


#pragma mark - Preferences Extansion

@interface Preferences ()

- (void)registerUserDefaultsFromSettingsBundle;

@end


#pragma mark Preferences Implementation

@implementation Preferences

#pragma mark Class methods
+ (instancetype)standardPreferences
{
    static dispatch_once_t onceToken = 0;
    static Preferences *standardPreferences_ = nil;
    dispatch_once(&onceToken, ^{
        standardPreferences_ = [[self alloc] init];
    });

    return standardPreferences_;
}

#pragma mark Initialization
- (id)init
{
    if ((self = [super init])) {
        [self registerUserDefaultsFromSettingsBundle];
    }
    return self;
}

#pragma mark Getters
- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUsernameKey];
}

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kTokenKey];
}

- (NSString *)userid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];
}

- (NSArray *)users
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kUsersArrayKey];
}

#pragma mark Setters
- (void)setUsername:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserid:(NSString *)userid
{
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:kUserIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUsers:(NSArray *)users
{
    [[NSUserDefaults standardUserDefaults] setObject:users forKey:kUsersArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Registering settings bundle
- (void)registerUserDefaultsFromSettingsBundle
{
    NSString *const settingsBundlePath =
        [[NSBundle mainBundle] pathForResource:@"Settings"
                                        ofType:@"bundle"];

    NSMutableDictionary *const defaultsToRegister = [NSMutableDictionary dictionary];
    if (settingsBundlePath) {
        NSString *const rootPlistPath =
            [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *const preferences =
            [NSDictionary dictionaryWithContentsOfFile:rootPlistPath];
        NSArray *const preferenceSpecifiers =
            [preferences objectForKey:@"PreferenceSpecifiers"];
        for (NSDictionary *specifier in preferenceSpecifiers) {
            NSString *const key = [specifier objectForKey:@"Key"];
            if (key) {
                [defaultsToRegister setValue:[specifier objectForKey:@"DefaultValue"]
                                      forKey:key];
            }
        }
    }
    [defaultsToRegister setObject:@""
                           forKey:kUsernameKey];
    
    [defaultsToRegister setObject:@""
                           forKey:kUsernameKey];
    
    [defaultsToRegister setObject:@""
                           forKey:kUserIDKey];
    
    [defaultsToRegister setObject:@[]
                           forKey:kUsersArrayKey];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
