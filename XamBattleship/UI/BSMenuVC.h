//
//  BSMenuVC.h
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSMenuVC;
@protocol BSMenuVCDelegate <NSObject>

- (void)connectionDidLost:(BSMenuVC *)sender;

@end

@interface BSMenuVC : UIViewController

@property (nonatomic, weak) id<BSMenuVCDelegate> delegate;

@end
