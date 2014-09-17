//
//  BSMenuVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSMenuVC.h"
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
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
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
- (void)connectionDidLost:(BSServerAPIController *)controller
{
}

@end
