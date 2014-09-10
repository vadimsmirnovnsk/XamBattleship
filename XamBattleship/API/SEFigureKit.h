//
//  SEFigureKit.h
//  XamBattleship
//
//  Created by Wadim on 07/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SEFigure;
@protocol SEFigureKitDragDropDelegate <NSObject>

- (void)figureDidMove:(SEFigure *)figure;
- (BOOL)figureWillDrope:(SEFigure *)figure;

@end


@interface SEFigureBlock : UIView

@property (nonatomic, strong) UIColor *surfaceColor;
@property (nonatomic, readwrite) BOOL canDrop;

@end


@interface SEFigure : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong, readonly) NSArray *views;
@property (nonatomic, readonly) BOOL canDrop;

- (instancetype)initWithArray:(NSArray *)array;
- (NSArray *)modelArray;
- (void)rotate:(NSUInteger)times;
- (void)centerWithRect:(CGRect)rect;
- (void)scaleToTemplateBlock:(UIView *)templateBlock;

@end


@interface SEFigureKit : NSObject

@property (nonatomic, strong) UIView *templateBlock;
@property (nonatomic, weak) id<SEFigureKitDragDropDelegate> dragDropDelegate;

+ (SEFigureKit *)sharedKit;
- (SEFigure *)figureWithNumberOfBlocks:(NSNumber /* with NSUInteger < 5 */*)numberOfBlocks
    color:(UIColor *)figureColor;

@end
