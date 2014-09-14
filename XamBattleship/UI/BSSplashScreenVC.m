//
//  BSSplashScreenVC.m
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSSplashScreenVC.h"
#import "UIColor+iOS7Colors.h"
#import "SEFigureKit.h"


@interface BSSplashScreenVC ()

@property (nonatomic, strong) UIImageView *tetrisImage;
@property (nonatomic, strong) UIImageView *battleShipImage;
@property (nonatomic, strong) UIView *spinner;
@property (nonatomic, strong) NSTimer *spinnerTimer;
@property (nonatomic, readwrite) CGFloat spinnerAngle;
@property (nonatomic, strong) UILabel *statusLabel;

@end


@implementation BSSplashScreenVC

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
    [self createSpinner];
    self.spinner.frame = (CGRect){self.spinner.frame.origin.x, 370, self.spinner.frame.size};
    [self.view addSubview:self.spinner];
    [self startSpinner];
    self.view.backgroundColor = [UIColor rhythmusLedOnColor];
    self.tetrisImage =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tetris"]];
    self.tetrisImage.frame = (CGRect){0, 160, 320, 45};
    [self.view addSubview:self.tetrisImage];
    self.battleShipImage =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"battleship"]];
    self.battleShipImage.frame = (CGRect){0, 250, 320, 20};
    [self.view addSubview:self.tetrisImage];
    [self.view addSubview:self.battleShipImage];
    
    self.statusLabel = [[UILabel alloc]initWithFrame:(CGRect){0,430,320,30}];
    self.statusLabel.tintColor = [UIColor mineShaftColor];
    self.statusLabel.text = @"Connecting to server...";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
}

- (void)animateImages
{
    [UIView animateWithDuration:1 animations:^{
        self.tetrisImage.frame = (CGRect){0, 60, 320, 45};
        self.battleShipImage.frame = (CGRect){0, 130, 320, 20};
    } completion:^(BOOL finished) {
        NSLog(@"Animation Did Finished!");
    }];
}

- (void)createSpinner
{
    UIView *templateBlock = [[UIView alloc]initWithFrame:(CGRect){0, 0, 15, 15}];
    templateBlock.backgroundColor = [UIColor magentaColor];
    templateBlock.layer.cornerRadius = 5;
    templateBlock.layer.borderWidth = 0.7;
    templateBlock.layer.borderColor = [UIColor clearColor].CGColor;
    [SEFigureKit sharedKit].templateBlock = templateBlock;
    SEFigure *newSpinner = [[SEFigureKit sharedKit]figureWithNumberOfBlocks:@(4) color:[UIColor randomColor]];
    [newSpinner centerWithRect:self.view.frame];
    self.spinner = newSpinner.view;
}

- (void)startSpinner
{
    self.spinnerTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateSpinner) userInfo:nil repeats:YES];
}

- (void)animateSpinner
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.spinner.transform = CGAffineTransformMakeRotation(self.spinnerAngle - 3.14/6);
        self.spinnerAngle -= 3.14/4;
    } completion:^(BOOL finished) {
        nil;
    }];
}

@end
