//
//  BSSpinner.m
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSSpinner.h"
#import "SEFigureKit.h"
#import "UIColor+iOS7Colors.h"

static CGFloat const kDefaultSpeed = 0.4f; /* Every 0.25s angle += defaultSpeed*Pi */


@interface BSSpinner ()

@property (nonatomic, strong) SEFigure *figure;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, readwrite) CGFloat spinnerAngle;
@property (nonatomic, readwrite) CGFloat speed;
@property (atomic, readwrite) BOOL isAnimate;

@end


@implementation BSSpinner

+ (BSSpinner *)animatedSpinnerWithFrame:(CGRect)frame
{
    BSSpinner *newSpinner = [[BSSpinner alloc]initWithFrame:frame];
    [newSpinner startAnimation];
    return newSpinner;
}

+ (BSSpinner *)animatedSpinnerWithFrame:(CGRect)frame speed:(CGFloat)speed
{
    BSSpinner *newSpinner = [BSSpinner animatedSpinnerWithFrame:frame];
    newSpinner.speed = speed;
    return newSpinner;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *templateBlock = [[UIView alloc]initWithFrame:(CGRect){0, 0, 15, 15}];
        templateBlock.backgroundColor = [UIColor magentaColor];
        templateBlock.layer.cornerRadius = 5;
        templateBlock.layer.borderWidth = 0.7;
        templateBlock.layer.borderColor = [UIColor clearColor].CGColor;
        [SEFigureKit sharedKit].templateBlock = templateBlock;
        _figure = [[SEFigureKit sharedKit]figureWithNumberOfBlocks:@(4) color:[UIColor randomColor]];
        [_figure centerWithRect:self.frame];
        self.speed = kDefaultSpeed;
        [self addSubview:_figure.view];
    }
    return self;
}

- (void)startAnimation
{
    if (!self.isAnimate) {
        _figure.view.alpha = 0.f;
    [self addSubview:_figure.view];
    [UIView animateWithDuration:0.3 animations:^{
        _figure.view.alpha = 1.f;
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateSpinner) userInfo:nil repeats:YES];
    _isAnimate = YES;
    }
}

- (void)stopAnimation
{
    [self.timer invalidate];
        [self addSubview:_figure.view];
    [UIView animateWithDuration:0.3 animations:^{
        _figure.view.alpha = 0.f;
    }];
    _isAnimate = NO;
}

- (void)animateSpinner
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeRotation
            (self.spinnerAngle + 3.14 * self.speed);
        self.spinnerAngle += 3.14 * self.speed;
    } completion:^(BOOL finished) {
        nil;
    }];
}

@end
