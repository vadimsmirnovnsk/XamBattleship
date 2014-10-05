//
//  BSFindFriendVC.m
//  XamBattleship
//
//  Created by Wadim on 19/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSFindFriendVC.h"

@interface BSFindFriendVC ()

@end

@implementation BSFindFriendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Find Friends";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *navigationBGView = [[UIView alloc]initWithFrame:(CGRect){0, 0, 320, 44}];
    [self.view addSubview:navigationBGView];
}


@end
