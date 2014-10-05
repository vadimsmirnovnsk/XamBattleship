//
//  BSMenuVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSMenuVC.h"
#import "UIColor+iOS7Colors.h"
#import "Preferences.h"
#import "BSBattleVC.h"
#import "BSBattleWithFriendsVC.h"


#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

static NSString *const kUsernamePlaceholder = @"Please enter new Username!";

#pragma mark - BSMenuVC Extension

@interface BSMenuVC () <BSBattleVCDelegate, BSBattleWithFriendsVCDelegate, BSServerAPIControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) BSBattleVC *prepareBattle;

@end


#pragma mark - BSMenuVC Implementation

@implementation BSMenuVC

#pragma mark BSMenuVC Custom Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [BSServerAPIController sharedController].delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self loadUserProfile];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadUserProfile
{
    self.usernameLabel.text = [Preferences standardPreferences].username;
}


- (IBAction)logout:(id)sender
{
    [self.delegate menuVCWillLogout:self];
}

- (IBAction)prepareGame:(id)sender
{
    BSBattleVC *const battleVC = [[BSBattleVC alloc] init];
    battleVC.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:battleVC];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)battleWithFriends:(id)sender
{
    BSBattleWithFriendsVC *const battleWithFriendsVC = [[BSBattleWithFriendsVC alloc]init];
    battleWithFriendsVC.delegate = self;
    
    UINavigationController *const navigationController =
        [[UINavigationController alloc]initWithRootViewController:battleWithFriendsVC];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark BSPrepareBattleVC Protocol Methods
- (void) battleVCWillDismissed:(BSBattleVC *)sender
{
    [sender dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark BSBattleWithFriendsDelegate Protocol
- (void) battleWithFriendsVCWillDissmised:(BSBattleWithFriendsVC *)sender
{
    [sender dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark BSServerAPIControllerDelagate Protocol Methods
- (void)connectionDidLost:(BSServerAPIController *)controller
{
    [self.delegate connectionDidLost:controller];
}

@end
