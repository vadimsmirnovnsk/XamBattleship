//
//  BSBattleWithFriendsVC.h
//  XamBattleship
//
//  Created by Wadim on 19/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSBattleWithFriendsVC;
@protocol BSBattleWithFriendsVCDelegate <NSObject>

- (void)battleWithFriendsVCWillDissmised:(BSBattleWithFriendsVC *)sender;

@end


@interface BSBattleWithFriendsVC : UIViewController

@property (nonatomic, weak) id<BSBattleWithFriendsVCDelegate> delegate;

@end
