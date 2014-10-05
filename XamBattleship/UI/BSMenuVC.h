//
//  BSMenuVC.h
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSServerAPIController.h"

@class BSMenuVC;
@protocol BSMenuVCDelegate <NSObject>

- (void)menuVCWillHide:(BSMenuVC *)sender;
- (void)menuVCWillLogout:(BSMenuVC *)sender;

@end


@interface BSMenuVC : UIViewController

@property (nonatomic, weak) id<BSMenuVCDelegate, BSServerAPIControllerDelegate> delegate;
- (void)loadUserProfile;

@end
