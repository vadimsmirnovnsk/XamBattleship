//
//  BSServerAPIController.m
//  XamBattleship
//
//  Created by Wadim on 11/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSServerAPIController.h"
#import "SRWebSocket.h"

static NSString *const kBaseAPIURL = @"ws://178.62.133.173:8008";


#pragma mark - BSServerAPIController Extension

@interface BSServerAPIController () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@end


#pragma mark - BSServerAPIController Implementation

@implementation BSServerAPIController

#pragma mark Initializers
+ (instancetype)sharedController
{
    static BSServerAPIController *sharedController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[BSServerAPIController alloc]init];
        sharedController.webSocket = [[SRWebSocket alloc]initWithURL:
            [NSURL URLWithString:kBaseAPIURL]];
        sharedController.webSocket.delegate = sharedController;
        NSLog(@"Opening websocket connection...");
        [sharedController.webSocket open];
    });
    return sharedController;
}

- (instancetype)init
{
    NSLog(@"Please use the [BSServerAPIController sharedController] method");
    return nil;
}

#pragma mark Public Methods
-(void)reconnect
{
    [self.webSocket close];
    self.webSocket =[[SRWebSocket alloc]initWithURL:
        [NSURL URLWithString:kBaseAPIURL]];
    self.webSocket.delegate = self;
    NSLog(@"Opening websocket connection...");
    [self.webSocket open];
}

- (void)signUpWithUsername:(NSString *)username token:(NSString *)token
{
    NSDictionary *jsonDict = @{
             @"act" : @"signin",
        @"username" : username,
            @"token":token};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    NSString *jsonString = [[NSString alloc]initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    [self.webSocket send:jsonString];
}

#pragma mark SRWebSocketDelegate Protocol Methods
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
