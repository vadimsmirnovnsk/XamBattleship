//
//  BSSplashScreenVC.m
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSSplashScreenVC.h"
#import "UIColor+iOS7Colors.h"
#import "BSSpinner.h"
#import "BSServerAPIController.h"
#import "Preferences.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


static CGRect const kTetrisImageStartFrame =   (CGRect){0.f, 160.f, 320.f, 45.f};
static CGRect const kBattleShipStartFrame =    (CGRect){0.f, 250.f, 320.f, 20.f};
static CGRect const kStatusLabelFrameiPhone5 = (CGRect){0.f, 518.f, 320.f, 30.f};
static CGRect const kStatusLabelFrameiPhone =  (CGRect){0.f, 430.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone5 =     (CGRect){0.f, 458.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone =      (CGRect){0.f, 370.f, 320.f, 30.f};

static NSTimeInterval const kAmazingRotationMinInterval = 1.0f;


@interface BSSplashScreenVC () <BSServerAPIControllerDelegate>

@property (nonatomic, strong) UIImageView *tetrisImage;
@property (nonatomic, strong) UIImageView *battleShipImage;
@property (nonatomic, strong) BSSpinner *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSTimer *showSpinnerTimer;
@property (nonatomic, readwrite) BOOL isConnected;
@property (nonatomic, readwrite) BOOL isSignedIn;

@end


@implementation BSSplashScreenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [BSServerAPIController sharedController].delegate = self;
    }
    return self;
}

+ (CGRect)spinnerFrame
{
    if (isiPhone5) {
        return kSpinnerFrameiPhone5;
    }
    else {
        return kSpinnerFrameiPhone;
    }
}

+ (CGRect)statusLabelFrame
{
    if (isiPhone5) {
        return kStatusLabelFrameiPhone5;
    }
    else {
        return kStatusLabelFrameiPhone;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rhythmusLedOnColor];
    self.tetrisImage =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tetris"]];
    self.tetrisImage.frame = kTetrisImageStartFrame;
    [self.view addSubview:self.tetrisImage];
    self.battleShipImage =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"battleship"]];
    self.battleShipImage.frame = kBattleShipStartFrame;
    [self.view addSubview:self.tetrisImage];
    [self.view addSubview:self.battleShipImage];
    
    self.statusLabel = [[UILabel alloc]initWithFrame:
        [BSSplashScreenVC statusLabelFrame]];
    [self.statusLabel setTextColor:[UIColor mineShaftColor]];
    self.statusLabel.text = @"Connecting to server...";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
    self.spinner = [BSSpinner animatedSpinnerWithFrame:
        [BSSplashScreenVC spinnerFrame]];
    [self.view addSubview:self.spinner];
    
    self.showSpinnerTimer = [NSTimer scheduledTimerWithTimeInterval:kAmazingRotationMinInterval
        target:self selector:@selector(checkServerConnection) userInfo:nil repeats:YES];
}

- (void)animateImages
{
    [self.spinner stopAnimation];
    [UIView animateWithDuration:0.75 delay:0.15 usingSpringWithDamping:0.3f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tetrisImage.frame = (CGRect){0, 60, 320, 45};
        self.battleShipImage.frame = (CGRect){0, 130, 320, 20};
    } completion:^(BOOL finished) {
        NSLog(@"Animation Did Finished!");
    }];
}

- (void)checkServerConnection
{
    if (self.isConnected) {
        [self.showSpinnerTimer invalidate];
        self.statusLabel.text = @"Signing in...";
    }
}

- (void)checkSigningIn
{
    if (self.isSignedIn) {
        [self.showSpinnerTimer invalidate];
        self.statusLabel.text = [NSString stringWithFormat:
            @"Welcome, %@!", [Preferences standardPreferences].username];
        [self.showSpinnerTimer invalidate];
        self.showSpinnerTimer = [NSTimer scheduledTimerWithTimeInterval:kAmazingRotationMinInterval
            target:self selector:@selector(animateImages) userInfo:nil repeats:NO];
    }
}

- (void)connectionDidEstablished:(BSServerAPIController *)controller
{
    self.isConnected = YES;
    if ([Preferences standardPreferences].username.length > 0) {
        // Not first enter
        [[BSServerAPIController sharedController]signUpWithUsername:
        [Preferences standardPreferences].username
        token:[Preferences standardPreferences].token];
        [self.showSpinnerTimer invalidate];
        self.showSpinnerTimer = [NSTimer scheduledTimerWithTimeInterval:kAmazingRotationMinInterval
            target:self selector:@selector(checkSigningIn) userInfo:nil repeats:YES];
    }
    else {
        // First enter
    }
}

- (void)didSignedIn:(BSServerAPIController *)controller
{
    self.isSignedIn = YES;
}

@end
