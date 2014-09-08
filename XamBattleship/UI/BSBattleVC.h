//
//  BSBattleVC.h
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - BSBattleVCDelegate Protocol

@class BSBattleVC;
@protocol BSBattleVCDelegate <NSObject>

- (void)battleVCWillDismissed:(BSBattleVC *)sender;

@end


#pragma mark - BSBattleVC Interface

@interface BSBattleVC : UIViewController

@property (nonatomic, weak) id<BSBattleVCDelegate> delegate;

@end
