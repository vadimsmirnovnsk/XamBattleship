//
//  SEGameCell.m
//  XamBattleship
//
//  Created by Wadim on 10/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "SEGameCell.h"


#pragma mark - SEFameCell Implementation

@implementation SEGameCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = gameStateEmpty;
        _button = [[UIButton alloc]init];
    }
    return self;
}

@end
