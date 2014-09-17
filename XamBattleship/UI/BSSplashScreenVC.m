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
#import "BSSignupVC.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


static CGRect const kTetrisImageStartFrame =     (CGRect){0.f, 160.f, 320.f, 45.f};
static CGRect const kBattleShipStartFrame =      (CGRect){0.f, 250.f, 320.f, 20.f};
static CGRect const kStatusLabelFrameiPhone5 =   (CGRect){0.f, 518.f, 320.f, 30.f};
static CGRect const kStatusLabelFrameiPhone =    (CGRect){0.f, 430.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone5 =       (CGRect){0.f, 458.f, 320.f, 30.f};
static CGRect const kSpinnerFrameiPhone =        (CGRect){0.f, 370.f, 320.f, 30.f};
static CGRect const kConnectButtonFrameiPhone5 = (CGRect){30.f, 380.f, 260.f, 50.f};
static CGRect const kConnectButtonFrameiPhone =  (CGRect){30.f, 320.f, 260.f, 50.f};

static CGPoint const kSignupViewOriginiPhone =   (CGPoint){0.f, 290.f};
static CGPoint const kSignupViewOriginiPhone5 =  (CGPoint){0.f, 378.f};
static CGPoint const kSignupViewStartOrigin =    (CGPoint){0.f, 570.f};
static CGFloat const kSignupViewOriginYShift =   75.f;

static NSTimeInterval const kAmazingRotationMinInterval = 1.0f;
static NSInteger const kTimerRepeats = 7;


#pragma mark - BSSplashScreenVC Extansion

@interface BSSplashScreenVC () <BSServerAPIControllerDelegate, BSSignupVCDelegate>

@property (nonatomic, strong) UIImageView *tetrisImage;
@property (nonatomic, strong) UIImageView *battleShipImage;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) BSSpinner *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSTimer *showSpinnerTimer;
@property (nonatomic, readwrite) BOOL isConnected;
@property (nonatomic, readwrite) BOOL isSignedIn;
@property (nonatomic, readwrite) NSInteger timerRepeats;
@property (nonatomic, strong) BSSignupVC *signupVC;

@end


#pragma mark - BSSplashScreenVC Implementation

@implementation BSSplashScreenVC

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [BSServerAPIController sharedController].delegate = self;
//        {"token":"1c1a7ca1a5bb67cf9c764b507b87e827d1013269",
//         "event":"signin",
//         "name":"First Test Username",
//         "_id":"54189ae5b7171b4a1eae85fb",
//         "message":"A new user created for you",
//         "status":2}

//        {"token":"10297306f01cf13905aa8fe0aa0925ebc0315d31",
//         "event":"signin",
//          "name":"Second Test Username",
//           "_id":"54189e1ab7171b4a1eae85fc",
//       "message":"A new user created for you",
//        "status":2}
        NSDictionary *firstUsername = @{kUsernameKey:@"First Test Username",
            kUserIDKey: @"54189ae5b7171b4a1eae85fb",
            kTokenKey: @"1c1a7ca1a5bb67cf9c764b507b87e827d1013269"};
        NSDictionary *secondUsername = @{kUsernameKey:@"Second Test Username",
            kUserIDKey: @"54189e1ab7171b4a1eae85fc",
            kTokenKey: @"10297306f01cf13905aa8fe0aa0925ebc0315d31"};
        NSArray *users = @[firstUsername, secondUsername];
        [Preferences standardPreferences].users = users;
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

+ (CGFloat)imagesOriginYShift
{
    if (isiPhone5) {
        return 0.f;
    }
    else {
        return 75.f;
    }
}

+ (CGPoint)signupViewOrigin
{
    if (isiPhone5) {
        return kSignupViewOriginiPhone5;
    }
    else {
        return kSignupViewOriginiPhone;
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
    
    self.signupVC = [[BSSignupVC alloc]init];
    self.signupVC.delegate = self;
    self.signupVC.view.frame = (CGRect) {
        kSignupViewStartOrigin,
        self.signupVC.view.frame.size
    };

    [self connectToServer];
}

- (void)animateImages
{
    [self.spinner stopAnimation];
    [UIView animateWithDuration:0.75 delay:0.15 usingSpringWithDamping:0.3f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tetrisImage.frame = (CGRect){0, 60, 320, 45};
        self.battleShipImage.frame = (CGRect){0, 130, 320, 20};
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.statusLabel.alpha = 0.f;
        }];
    }];
}

- (void)connectToServer
{
    [BSServerAPIController sharedController].delegate = self;
    [[BSServerAPIController sharedController] openConnection];
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
    [[BSServerAPIController sharedController]closeConnection];
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
        self.tetrisImage.frame = kTetrisImageStartFrame;
        self.battleShipImage.frame = kBattleShipStartFrame;
    }];
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

- (void)checkServerConnection
{
    if (self.isConnected) {
        if ([Preferences standardPreferences].username.length > 0) {
            // Not first enter
            [self loginWithUsername:[Preferences standardPreferences].username
                token:[Preferences standardPreferences].token];
        }
        else {
            // First enter
            self.timerRepeats = 0;
            [self.showSpinnerTimer invalidate];
            [self getSignupScreen];
        }
    }
    else {
        self.timerRepeats = self.timerRepeats + 1;
        if (self.timerRepeats > kTimerRepeats) {
            [self lostConnection];
        }
    }
}

- (void)loginWithUsername:(NSString *)username token:(NSString *)token
{
    self.timerRepeats = 0;
    [self.showSpinnerTimer invalidate];
    self.statusLabel.text = @"Signing in...";
    NSString *adaptedUsername = username;
    NSString *adaptedToken = token;
    if (!adaptedUsername) {
        adaptedUsername = @"";
    }
    if (!adaptedToken) {
        adaptedToken = @"";
    }
    [[BSServerAPIController sharedController]signUpWithUsername:adaptedUsername
        token:adaptedToken];
    if (!self.spinner.isAnimate) {
        [self.spinner startAnimation];
    }
    self.showSpinnerTimer = [NSTimer scheduledTimerWithTimeInterval:kAmazingRotationMinInterval
        target:self selector:@selector(checkSigningIn) userInfo:nil repeats:YES];
}

- (void)getSignupScreen
{
    [self.view addSubview:self.signupVC.view];
    [self addChildViewController:self.signupVC];
    [self.signupVC didMoveToParentViewController:self];
    [self.showSpinnerTimer invalidate];
    [self.spinner stopAnimation];
    [UIView animateWithDuration:0.3 animations:^{
        self.signupVC.view.frame = (CGRect) {
            [BSSplashScreenVC signupViewOrigin],
            self.signupVC.view.frame.size
        };
    }];
}

- (void)dropSignupScreen:(BSSignupVC *)screen
{
    [UIView animateWithDuration:0.3 animations:^{
        screen.view.frame = (CGRect) {
            kSignupViewStartOrigin,
            screen.view.frame.size
        };
    } completion:^(BOOL finished) {
        [self.signupVC.view removeFromSuperview];
        [self.signupVC removeFromParentViewController];
    }];
}

#pragma mark BSServerAPIControllerDelegate Methods
- (void)connectionDidEstablished:(BSServerAPIController *)controller
{
    self.isConnected = YES;
}

- (void)connectionDidLost:(BSServerAPIController *)controller
{
    self.isConnected = NO;
    self.isSignedIn = NO;
    [self dropSignupScreen:self.signupVC];
    [[BSServerAPIController sharedController]closeConnection];
    [self lostConnection];
}

- (void)didSignedIn:(BSServerAPIController *)controller
{
    self.isSignedIn = YES;
}

- (void)didSignedUp:(BSServerAPIController *)controller
{
    NSDictionary *newUser = @{kUsernameKey:controller.username,
                                kUserIDKey:controller.userid,
                                 kTokenKey:controller.token};
    NSMutableArray *newUsers = [[Preferences standardPreferences].users mutableCopy];
    [newUsers addObject:newUser];
    [Preferences standardPreferences].users = [newUsers copy];
    [Preferences standardPreferences].username = controller.username;
    [Preferences standardPreferences].userid = controller.userid;
    [Preferences standardPreferences].token = controller.token;
    self.isSignedIn = YES;
}

- (void)didSignInFailed:(BSServerAPIController *)controller
{
    [Preferences standardPreferences].username = @"";
    [Preferences standardPreferences].token = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signing In Fail!" message:@"Sorry, you can't sign in to server with this Username. Please try to sign in with other account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.timerRepeats = 0;
    [self.showSpinnerTimer invalidate];
    [self.spinner stopAnimation];
    self.statusLabel.text = @"Invalid Username/Token paar.";
}

#pragma mark BSSignupVCDelegate Methods
- (void) signupVC:(BSSignupVC *)sender willSignInWithUserName:(NSString *)username
    token:(NSString *)token
{
    [self dropSignupScreen:sender];
    [self loginWithUsername:username token:token];
}

- (void)signupVCWillShowKeyboard:(BSSignupVC *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tetrisImage.frame = (CGRect) {
            self.tetrisImage.frame.origin.x,
            self.tetrisImage.frame.origin.y - [BSSplashScreenVC imagesOriginYShift],
            self.tetrisImage.frame.size
        };
        self.battleShipImage.frame = (CGRect) {
            self.battleShipImage.frame.origin.x,
            self.battleShipImage.frame.origin.y - [BSSplashScreenVC imagesOriginYShift],
            self.battleShipImage.frame.size
        };
        sender.view.frame = (CGRect) {
            sender.view.frame.origin.x,
            sender.view.frame.origin.y - kSignupViewOriginYShift,
            sender.view.frame.size
        };
    }];
}

- (void)signupVCWillHideKeyboard:(BSSignupVC *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tetrisImage.frame = kTetrisImageStartFrame;
        self.battleShipImage.frame = kBattleShipStartFrame;
        sender.view.frame = (CGRect){
            [BSSplashScreenVC signupViewOrigin],
            sender.view.frame.size
        };
    }];
}

#pragma mark UIAlertViewDelegate Protocol
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self getSignupScreen];
}

@end
