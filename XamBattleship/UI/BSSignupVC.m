//
//  BSSignupVC.m
//  XamBattleship
//
//  Created by Wadim on 15/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSSignupVC.h"
#import "UIColor+iOS7Colors.h"
#import "Preferences.h"
#import "DTCustomColoredAccessory.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

static NSString *const kUsernamePlaceholder = @"Please enter new Username!";

static CGRect const kTextFieldFrame =            (CGRect){10.f, 10.f, 300.f, 30.f};
static CGRect const kSignupButtonFrame =         (CGRect){10.f, 50.f, 300.f, 50.f};
static CGRect const kFoldedTableViewFrame =      (CGRect){10.f, 110.f, 300.f, 90.f};
static CGRect const kUnfoldedTableViewFrame_5 =  (CGRect){10.f, 10.f, 300.f, 258.f};
static CGRect const kUnfoldedTableViewFrame_4 =  (CGRect){10.f, 10.f, 300.f, 170.f};

static CGFloat const kTableViewCellHeight = 50;

static NSString *const userCellId = @"UserCellId";

@interface BSSignupVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *expandedSections;

@end

@implementation BSSignupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.expandedSections = [[NSMutableIndexSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor mineShaftColor];
    self.view.bounds = (CGRect){0, 0, 320, 320};
    self.textField = [[UITextField alloc]initWithFrame:kTextFieldFrame];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.textField setTextAlignment:NSTextAlignmentCenter];
    self.textField.delegate = self;
    self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:self.textField];
    
    self.signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signupButton.frame = kSignupButtonFrame;
    self.signupButton.backgroundColor = [UIColor doveGrayColor];
    [self.signupButton setTitle:@"Connect!" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor rhythmusLedOnColor] forState:UIControlStateHighlighted];
    [self.signupButton addTarget:self action:@selector(didTouchSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signupButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:kFoldedTableViewFrame
        style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    if ([[Preferences standardPreferences].users count]>0) {
        [self.view addSubview:self.tableView];
    }
    
    [self prepareControlsWithUsername];
}

- (void)prepareControlsWithUsername
{
    if ([Preferences standardPreferences].username.length == 0) {
        self.textField.placeholder = kUsernamePlaceholder;
        [self.signupButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    }
    else {
        self.textField.placeholder = [Preferences standardPreferences].username;
        [self.signupButton setTitle:@"Sign In!" forState:UIControlStateNormal];
    }
}

- (void)didTouchSignUpButton:(UIButton *)sender
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
            [self.delegate signupVC:self willSignInWithUserName:
                [Preferences standardPreferences].username
                token:[Preferences standardPreferences].token];
        }
    }
    else {
        // Trying to creating new user
        [self prepareControlsWithUsername];
        NSLog(@"New username is: %@, trying to conecting to server", self.textField.text);
        [self.delegate signupVC:self willSignInWithUserName:self.textField.text token:nil];
    }
}

- (void)unfoldTable
{
    self.tableView.scrollEnabled = YES;
    if (isiPhone5) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat height = (kUnfoldedTableViewFrame_5.size.height < (CGFloat)
                ([[Preferences standardPreferences].users count]+1)*kTableViewCellHeight?
                kUnfoldedTableViewFrame_5.size.height:
                ([[Preferences standardPreferences].users count]+1)*kTableViewCellHeight);
            self.tableView.frame = (CGRect){
                kUnfoldedTableViewFrame_5.origin,
                kUnfoldedTableViewFrame_5.size.width,
                height
            };
            self.signupButton.alpha = 0.f;
            self.textField.alpha = 0.f;
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat height = (kUnfoldedTableViewFrame_4.size.height < (CGFloat)
                ([[Preferences standardPreferences].users count]+1)*kTableViewCellHeight?
                kUnfoldedTableViewFrame_4.size.height:
                ([[Preferences standardPreferences].users count]+1)*kTableViewCellHeight);
            self.tableView.frame = (CGRect){
                kUnfoldedTableViewFrame_4.origin,
                kUnfoldedTableViewFrame_4.size.width,
                height
            };
//            self.tableView.frame = kUnfoldedTableViewFrame_4;
            self.signupButton.alpha = 0.f;
            self.textField.alpha = 0.f;
        }];
    }
}

- (void)foldTable
{
    self.tableView.scrollEnabled = NO;
    if (isiPhone5) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFoldedTableViewFrame;
            self.signupButton.alpha = 1.f;
            self.textField.alpha = 1.f;
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFoldedTableViewFrame;
            self.signupButton.alpha = 1.f;
            self.textField.alpha = 1.f;
        }];
    }
}

#pragma mark UITextFieldDelegate Protocol Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate signupVCWillShowKeyboard:self];
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [self.delegate signupVCWillHideKeyboard:self];
//    [textField resignFirstResponder];
//    return YES;
//}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate signupVCWillHideKeyboard:self];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITableViewDataSource Protocol methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell;
    tableViewCell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:userCellId];
    }
    
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        if (!indexPath.row) {
            if(indexPath.section == 0){
                tableViewCell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
                tableViewCell.detailTextLabel.text = @"My Logins";
                tableViewCell.detailTextLabel.textColor = [UIColor darkTextColor];
                tableViewCell.backgroundColor = [UIColor mercuryColor];
                if ([self.expandedSections containsIndex:indexPath.section]) {
                    tableViewCell.accessoryView = [DTCustomColoredAccessory
                        accessoryWithColor:[UIColor grayColor]
                        type:DTCustomColoredAccessoryTypeUp];
                }
                else {
                    tableViewCell.accessoryView = [DTCustomColoredAccessory
                        accessoryWithColor:[UIColor grayColor]
                        type:DTCustomColoredAccessoryTypeDown];
                }
            }
        }
        else {
            if(indexPath.section == 0) {
                NSDictionary *user = [Preferences standardPreferences].users[indexPath.row - 1];
                tableViewCell.detailTextLabel.text = user[kUsernameKey];
            }
        }
    }
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([self.expandedSections containsIndex:section])
        {
            if(section == 0){
                return [[Preferences standardPreferences].users count]+1;
            }
        }
            
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

#pragma mark UITableViewDelegate Protocol methods
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        if (!indexPath.row) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSInteger rows;
            NSMutableArray *tmpArray = [NSMutableArray array];
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [self.expandedSections containsIndex:section];
            if (currentlyExpanded) {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [self.expandedSections removeIndex:section];
                [self foldTable];
            }
            else {
                [self.expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [self unfoldTable];
            }
            for (NSUInteger i = 1; i < rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationFade];
                cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
        } else {
            if(indexPath.section == 0){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                NSLog(@"Something with : %ld",(long)indexPath.row);
                NSDictionary *selectedUser =
                    [[Preferences standardPreferences].users[indexPath.row-1] copy];
                [Preferences standardPreferences].username = selectedUser[kUsernameKey];
                [Preferences standardPreferences].token = selectedUser[kTokenKey];
                [Preferences standardPreferences].userid = selectedUser[kUserIDKey];
                [self.delegate signupVC:self willSignInWithUserName:selectedUser[kUsernameKey] token:selectedUser[kTokenKey]];
            }
        }
    }
}


@end
