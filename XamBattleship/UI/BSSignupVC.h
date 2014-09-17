//
//  BSSignupVC.h
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSignupVC;
@protocol BSSignupVCDelegate <NSObject>

- (void)signupVC:(BSSignupVC *)sender willSignInWithUserName:(NSString *)username
    token:(NSString *)token;
- (void)signupVCWillShowKeyboard:(BSSignupVC *)sender;
- (void)signupVCWillHideKeyboard:(BSSignupVC *)sender;

@end


@interface BSSignupVC : UIViewController

@property (nonatomic, weak) id<BSSignupVCDelegate> delegate;

@end
