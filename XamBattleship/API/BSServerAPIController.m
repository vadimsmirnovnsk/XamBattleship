//
//  BSServerAPIController.m
//  XamBattleship
//
//  Created by Wadim on 11/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSServerAPIController.h"
#import "SRWebSocket.h"

static NSString *const kBaseAPIURL = @"ws://178.62.133.63:8008"; // @"ws://echo.websocket.org";//
static NSString *const kEventField = @"event";
static NSString *const kEventFieldParameterSignIn = @"signin";

static NSString *const kMessageField = @"message";
static NSString *const kMessageFieldParameterSignedIn = @"successfuly signed in";
static NSString *const kMessageFieldParameterSignedUp = @"A new user created for you";
static NSString *const kMessageFieldParameterInvalidToken = @"invalid token";

static NSString *const kUserIDField = @"_id";
static NSString *const kUserNameField = @"name";
static NSString *const kTokenField = @"token";


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
    });
    return sharedController;
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

- (void)openConnection
{
    self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:kBaseAPIURL]];
    self.webSocket.delegate = self;
    NSLog(@"Opening websocket connection...");
    [self.webSocket open];
}

- (void)closeConnection
{
    [self.webSocket close];
}

- (void)signUpWithUsername:(NSString *)username token:(NSString *)token
{
    NSDictionary *jsonDict = @{
        kEventField : kEventFieldParameterSignIn,
     kUserNameField : username,
        kTokenField : token};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    NSString *jsonString = [[NSString alloc]initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    [self.webSocket send:jsonString];
}

#pragma mark SRWebSocketDelegate Protocol Methods
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSError *__autoreleasing error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:
        [message dataUsingEncoding:NSUTF8StringEncoding]
        options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Web socket did receive the message: %@",message);
    if ([jsonResponse[kEventField] isEqualToString:kEventFieldParameterSignIn]) {
        if ([jsonResponse[kMessageField] isEqualToString: kMessageFieldParameterSignedIn]) {
                _token = jsonResponse[kTokenField];
                _username = jsonResponse[kUserNameField];
                if ([self.delegate respondsToSelector:@selector(didSignedIn:)]) {
                    [self.delegate didSignedIn:self];
                }
        }
        else if ([jsonResponse[kMessageField] isEqualToString: kMessageFieldParameterSignedUp]) {
            _token = jsonResponse[kTokenField];
            _username = jsonResponse [kUserNameField];
            _userid = jsonResponse [kUserIDField];
            if ([self.delegate respondsToSelector:@selector(didSignedUp:)]) {
                [self.delegate didSignedUp:self];
            }
        }
        else if ([jsonResponse[kMessageField] isEqualToString:
            kMessageFieldParameterInvalidToken]) {
            if ([self.delegate respondsToSelector:@selector(didSignedUp:)]) {
                [self.delegate didSignInFailed:self];
            }
        }
        else {
            // Message is undefined
        }
    }
    else if (![jsonResponse[kEventField] isEqualToString:kEventFieldParameterSignIn]) {
        // No event
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
    reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Web socket did closed with code: %ld, reason: %@", (long)code, reason);
    if ([self.delegate respondsToSelector:@selector(connectionDidLost:)]) {
        [self.delegate connectionDidLost:self];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Web socket did fail with error: %@", error);
    if ([self.delegate respondsToSelector:@selector(connectionDidLost:)]) {
        [self.delegate connectionDidLost:self];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Socket %@ is opened",webSocket);
    if ([self.delegate respondsToSelector:@selector(connectionDidEstablished:)]) {
        [self.delegate connectionDidEstablished:self];
    }
}


@end
