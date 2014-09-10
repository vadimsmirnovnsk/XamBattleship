//
//  SEGamingCard.m
//  XamBattleship
//
//  Created by Wadim on 09/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "SEGamingCard.h"
#import "UIColor+iOS7Colors.h"

static NSUInteger const gameCardCornerRadius = 7;


@interface SEGamingCard ()

@property (nonatomic, strong) UIButton *button;

@end


@implementation SEGamingCard

+ (SEGamingCard *)cardWithFigure:(SEFigure *)figure frame:(CGRect)frame
{
    SEGamingCard *newCard = [[SEGamingCard alloc]init];
    newCard.figure = figure;
    newCard.view = [[UIView alloc]initWithFrame:frame];
    newCard.view.backgroundColor = [UIColor rhythmusBackgroundColor];
    newCard.view.layer.cornerRadius = gameCardCornerRadius;
    newCard.view.layer.borderWidth = 0.7;
    // newCard.view.layer.borderColor = [UIColor silverColor].CGColor;
    [figure centerWithRect:newCard.view.frame];
    [newCard.view addSubview:figure.view];
    UIButton *cardButton = [[UIButton alloc]initWithFrame:newCard.view.bounds];
    cardButton.backgroundColor = [UIColor clearColor];
    [cardButton addTarget:newCard action:@selector(didTouchCard:) forControlEvents:UIControlEventTouchDown];
    [cardButton addTarget:newCard action:@selector(didTouchCancelCard:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [cardButton addTarget:newCard action:@selector(didMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    [newCard.view addSubview:cardButton];
    [cardButton didMoveToSuperview];
    return newCard;
}

- (void)didTouchCard:(UIButton *)sender
{
    self.figure.canDrop = NO;
    UIView *templateBlock = [[UIView alloc]initWithFrame:(CGRect){0, 0, 31, 31}];
    templateBlock.backgroundColor = [UIColor magentaColor];
    templateBlock.layer.cornerRadius = 8;
    templateBlock.layer.borderWidth = 0.7;
    templateBlock.layer.borderColor = [UIColor clearColor].CGColor;
    [self.figure scaleToTemplateBlock:templateBlock];
    [self.figure centerWithRect:self.view.frame];
}

- (void)didTouchCancelCard:(UIButton *)sender
{
    if ([[SEFigureKit sharedKit].dragDropDelegate figureWillDrope:self.figure]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self.delegate cardWillDelete:self];
        }];
    }
    else {
        UIView *templateBlock = [[UIView alloc]initWithFrame:(CGRect){0, 0, 15, 15}];
        templateBlock.backgroundColor = [UIColor magentaColor];
        templateBlock.layer.cornerRadius = 5;
        templateBlock.layer.borderWidth = 0.7;
        templateBlock.layer.borderColor = [UIColor clearColor].CGColor;
        [self.figure scaleToTemplateBlock:templateBlock];
        [self.figure centerWithRect:self.view.frame];
    }
}

- (void)didMoved:(UIButton *)sender withEvent:(UIEvent *)event
{
    UIControl *control = sender;

    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];

    CGPoint center = self.figure.view.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    self.figure.view.center = center;
    [[SEFigureKit sharedKit].dragDropDelegate figureDidMove:self.figure];
}



@end
