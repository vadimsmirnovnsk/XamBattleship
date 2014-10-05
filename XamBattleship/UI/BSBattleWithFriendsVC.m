//
//  BSBattleWithFriendsVC.m
//  XamBattleship
//
//  Created by Wadim on 19/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSBattleWithFriendsVC.h"
#import "BSFriendsListVC.h"
#import "BSFindFriendVC.h"
#import "BSInviteFriendVC.h"
#import "UIColor+iOS7Colors.h"

@interface BSBattleWithFriendsVC ()

@end

@implementation BSBattleWithFriendsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor mercuryColor];
    // Tune the Navigation Controller
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem =
            [[UIBarButtonItem alloc]initWithTitle:@"Back to Menu"
                style:UIBarButtonItemStyleBordered target:self
                action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        [cancelBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor mineShaftColor]];

    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    BSFriendsListVC *friendsVC = [[BSFriendsListVC alloc]init];
    BSFindFriendVC *findFriendVC = [[BSFindFriendVC alloc]init];
    BSInviteFriendVC *inviteFriendVC = [[BSInviteFriendVC alloc]init];
    [tabBarController setViewControllers:@[friendsVC, findFriendVC, inviteFriendVC]];
    [self addChildViewController:tabBarController];
    [self.view addSubview:tabBarController.view];
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate battleWithFriendsVCWillDissmised:self];
}


@end
