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
#import "SEFigureKit.h"


#pragma mark - BSMenuVC Extension

@interface BSMenuVC () <SRWebSocketDelegate, UITextFieldDelegate, BSBattleVCDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) SRWebSocket *webSocket;
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
    self.webSocket = [[SRWebSocket alloc]initWithURL:
        [NSURL URLWithString:@"ws://echo.websocket.org"]];
    self.webSocket.delegate = self;
    NSLog(@"Opening connection...");
    [self.webSocket open];
}

- (IBAction)sendMessage:(id)sender
{
    [self.webSocket send:self.textField.text];
}

- (IBAction)prepareGame:(id)sender
{
    BSBattleVC *const battleVC = [[BSBattleVC alloc] init];
    battleVC.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:battleVC];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)createFigure:(id)sender
{
    SEFigure *newFigure = [[SEFigureKit sharedKit]figureWithNumberOfBuckets:@(4)];
    NSLog(@"New Figure Data model: %@",newFigure.modelArray);
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

#pragma mark SRWebSocketDelegate Methods

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Web socket did receive the message: %@",message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
    reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Web socket did closed with code: %d, reason: %@", code, reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Web socket did fail with error: %@", error);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Socket %@ is opened",webSocket);
}

@end
