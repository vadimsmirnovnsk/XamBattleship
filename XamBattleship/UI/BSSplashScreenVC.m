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


static CGRect const kTetrisImageStartFrame =     (CGRect){0.f, 160.f, 320.f, 45.f};
static CGRect const kBattleShipStartFrame =      (CGRect){0.f, 250.f, 320.f, 20.f};
static CGRect const kStatusLabelFrameiPhone5 =   (CGRect){0.f, 518.f, 320.f, 30.f};
static CGRect const kStatusLabelFrameiPhone =    (CGRect){0.f, 430.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone5 =       (CGRect){0.f, 458.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone =        (CGRect){0.f, 370.f, 320.f, 30.f};
static CGRect const kConnectButtonFrameiPhone5 = (CGRect){30.f, 380.f, 260.f, 50.f};
static CGRect const kConnectButtonFrameiPhone =  (CGRect){30.f, 320.f, 260.f, 50.f};

static NSTimeInterval const kAmazingRotationMinInterval = 1.0f;
static NSInteger const kTimerRepeats = 7;


#pragma mark - BSSplashScreenVC Extansion

@interface BSSplashScreenVC () <BSServerAPIControllerDelegate>

@property (nonatomic, strong) UIImageView *tetrisImage;
@property (nonatomic, strong) UIImageView *battleShipImage;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) BSSpinner *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSTimer *showSpinnerTimer;
@property (nonatomic, readwrite) BOOL isConnected;
@property (nonatomic, readwrite) BOOL isSignedIn;
@property (nonatomic, readwrite) NSInteger timerRepeats;

@end


#pragma mark - BSSplashScreenVC Implementation

@implementation BSSplashScreenVC

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [BSServerAPIController sharedController].delegate = self;
        
        //    username: New Awesome User,
        //    token: ff26b4ca1aeb78a978ec0239b308ac71e8cbfd72

        //    name = "New User";
        //    token = b85e445f60044c26c53dc928d018cf9dfb200a6e;
//        NSDictionary *firstUser = @{kUsernameKey:[Preferences standardPreferences].username,
//                                       kTokenKey:[Preferences standardPreferences].token};
//        NSDictionary *secondUser = @{kUsernameKey:@"New Awesome User",
//                                        kTokenKey:@"ff26b4ca1aeb78a978ec0239b308ac71e8cbfd72"};
//        NSDictionary *thirdUser = @{kUsernameKey:@"New User",
//                                       kTokenKey:@"b85e445f60044c26c53dc928d018cf9dfb200a6e"};
//        NSArray *users = @[firstUser, secondUser, thirdUser];
//        [[Preferences standardPreferences] setUsers:users];
//        NSLog(@"Users Array: %@", [Preferences standardPreferences].users);
    }
    return self;
}

#pragma mark Resolution Dependent Frames
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

+ (CGRect)connectButtonFrame
{
    if (isiPhone5) {
        return kConnectButtonFrameiPhone5;
    }
    else {
        return kConnectButtonFrameiPhone;
    }
}

#pragma mark Private Methods
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
    
    self.connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.connectButton.frame = [BSSplashScreenVC connectButtonFrame];
    self.connectButton.backgroundColor = [UIColor mineShaftColor];
    [self.connectButton setTitle:@"Connect!" forState:UIControlStateNormal];
    [self.connectButton setTitleColor:[UIColor rhythmusLedOnColor] forState:UIControlStateNormal];
    [self.connectButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.connectButton addTarget:self action:@selector(didTouchConnectButton:) forControlEvents:UIControlEventTouchUpInside];

    [self connectToServer];
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

- (void)connectToServer
{
    self.statusLabel.text = @"Connecting to server...";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
    self.spinner = [BSSpinner animatedSpinnerWithFrame:
        [BSSplashScreenVC spinnerFrame]];
    [self.view addSubview:self.spinner];
    
    self.showSpinnerTimer = [NSTimer scheduledTimerWithTimeInterval:kAmazingRotationMinInterval
        target:self selector:@selector(checkServerConnection) userInfo:nil repeats:YES];
}

- (void)didTouchConnectButton:(UIButton *)sender
{
    [sender setEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        sender.alpha = 0.f;
    }];
    [[BSServerAPIController sharedController]reconnect];
    [self connectToServer];
}

- (void)lostConnection
{
    self.timerRepeats = 0;
    [self.showSpinnerTimer invalidate];
    [self.spinner stopAnimation];
    self.statusLabel.text = @"Server is unreachable.";
    self.connectButton.alpha = 0.f;
    [self.connectButton setEnabled:YES];
    [self.view addSubview:self.connectButton];
    [UIView animateWithDuration:0.3 animations:^{
        self.connectButton.alpha = 1.f;
    }];
}

- (void)checkServerConnection
{
    if (self.isConnected) {
        self.timerRepeats = 0;
        [self.showSpinnerTimer invalidate];
        if ([Preferences standardPreferences].username.length > 0) {
            // Not first enter
            self.statusLabel.text = @"Signing in...";
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
    else {
        self.timerRepeats = self.timerRepeats + 1;
        if (self.timerRepeats > kTimerRepeats) {
            [self lostConnection];
        }
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
        else {
        self.timerRepeats = self.timerRepeats + 1;
        if (self.timerRepeats > kTimerRepeats) {
            [self lostConnection];
        }
    }
}

#pragma mark BSServerAPIControllerDelegate Methods
- (void)connectionDidEstablished:(BSServerAPIController *)controller
{
    self.isConnected = YES;
}

- (void)didSignedIn:(BSServerAPIController *)controller
{
    self.isSignedIn = YES;
}

@end
