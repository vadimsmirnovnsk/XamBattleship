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


static NSString *const kUsernamePlaceholder = @"Please enter new Username!";

#pragma mark - BSMenuVC Extension

@interface BSMenuVC () <UITextFieldDelegate, BSBattleVCDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([Preferences standardPreferences].username.length == 0) {
        self.textField.placeholder = kUsernamePlaceholder;
    }
    else {
        self.textField.placeholder = [Preferences standardPreferences].username;
    }
}

- (IBAction)sendMessage:(id)sender
{
    [[Preferences standardPreferences] setUsername:self.textField.text];
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

@end
