//
//  BSSpinner.h
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSSpinner : UIView

+ (BSSpinner *)animatedSpinnerWithFrame:(CGRect)frame;
+ (BSSpinner *)animatedSpinnerWithFrame:(CGRect)frame speed:(CGFloat/* 0..1 */)speed;
- (void)startAnimation;
- (void)stopAnimation;

@end
