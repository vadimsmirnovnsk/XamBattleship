//
//  SEGamingCard.h
//  XamBattleship
//
//  Created by Wadim on 09/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEFigureKit.h"


@class SEGamingCard;
@protocol SEGamingCardDelegate <NSObject>

- (void)cardWillDelete:(SEGamingCard *)card;

@end


@interface SEGamingCard : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) SEFigure *figure;
@property (nonatomic, weak) id<SEGamingCardDelegate> delegate;

+ (SEGamingCard *)cardWithFigure:(SEFigure *)figure frame:(CGRect)frame;

@end
