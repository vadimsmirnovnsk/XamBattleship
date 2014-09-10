//
//  SEGameCell.h
//  XamBattleship
//
//  Created by Wadim on 10/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, GameCellState) {
    gameStateEmpty = 0,
    gameStateBusy = 1
};


@interface SEGameCell : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, readwrite) GameCellState state;

@end
