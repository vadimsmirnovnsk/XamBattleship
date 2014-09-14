//
//  BSMenuVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSMenuVC.h"
#import "SRWebSocket.h"
#import "BSBattleVC.h"
#import "Preferences.h"
#import "BSServerAPIController.h"
#import "UIColor+iOS7Colors.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


static NSString *const kUsernamePlaceholder = @"Please enter new Username!";

#pragma mark - BSMenuVC Extension

@interface BSMenuVC () <UITextFieldDelegate, BSBattleVCDelegate, BSServerAPIControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) BSBattleVC *prepareBattle;

@end


#pragma mark - BSMenuVC Implementation

@implementation BSMenuVC

#pragma mark BSMenuVC Custom Methods
+ (UIImage*)backImage
{
    UIImage *backImg;
    if (isiPhone5)
    {
        backImg = [UIImage imageNamed:@"Default-568h~iphone"];
    } else
    {
        backImg = [UIImage imageNamed:@"Default~iphone"];
    }
    return backImg;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [BSServerAPIController sharedController].delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rhythmusBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    [self prepareControlsWithUsername];
}

- (IBAction)didTouchBackButton:(id)sender
{
    if (([self.textField.text isEqualToString:[Preferences standardPreferences].username]) &&
        (![self.textField.text isEqualToString:@""])) {
        [self.signInButton setTitle:@"Sign In!" forState:UIControlStateNormal];
    }
    else {
        [self.signInButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    }
    [self.textField resignFirstResponder];
}

- (IBAction)didTouchSignUpButton:(id)sender
{
    if ([self.textField.text isEqualToString:@""]) {
        // Empty text field
        if ([self.textField.placeholder isEqualToString:kUsernamePlaceholder]) {
            // Empty user defaults
            NSLog(@"Please enter new login name for entering o the game!");
        }
        else {
            // User with user defaults
            [self prepareControlsWithUsername];
            NSLog(@"Connecting to server with username: %@", self.textField.placeholder);
            [[BSServerAPIController sharedController] signUpWithUsername:[Preferences standardPreferences].username token:[Preferences standardPreferences].token];
        }
    }
    else {
        // Trying to creating new user
        [self prepareControlsWithUsername];
        NSLog(@"New username is: %@, trying to conecting to server", self.textField.text);
        [[BSServerAPIController sharedController] signUpWithUsername:self.textField.text
            token:@""];
    }
}

- (void)prepareControlsWithUsername
{
    if ([Preferences standardPreferences].username.length == 0) {
        self.textField.placeholder = kUsernamePlaceholder;
        [self.signInButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    }
    else {
        self.textField.placeholder = [Preferences standardPreferences].username;
        [self.signInButton setTitle:@"Sign In!" forState:UIControlStateNormal];
    }
}

- (IBAction)prepareGame:(id)sender
{
    BSBattleVC *const battleVC = [[BSBattleVC alloc] init];
    battleVC.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:battleVC];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark UITextFieldDelegate Methods
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.signInButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark BSPrepareBattleVC Methods
- (void) battleVCWillDismissed:(BSBattleVC *)sender
{
    [sender dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark BSServerAPIControllerDelagate Protocol Methods
- (void) connectionDidEstablished:(BSServerAPIController *)controller
{
    NSLog(@"Connection with server did established!!!");
}

- (void) didSignedIn:(BSServerAPIController *)controller
{
    NSLog(@"We are the champions and signed in with username: %@, token: %@", controller.username, controller.token);
}

- (void) didSignedUp:(BSServerAPIController *)controller
{
//    username: New Awesome User,
//    token: ff26b4ca1aeb78a978ec0239b308ac71e8cbfd72

//    name = "New User";
//    token = b85e445f60044c26c53dc928d018cf9dfb200a6e;

    NSLog(@"We are the champions and signed UP with username: %@, token: %@", controller.username, controller.token);
    [[Preferences standardPreferences] setToken:controller.token];
    [[Preferences standardPreferences] setUsername:controller.username];
    [[Preferences standardPreferences] setUserid:controller.userid];
    [self prepareControlsWithUsername];
}

@end
