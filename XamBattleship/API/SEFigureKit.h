//
//  SEFigureKit.h
//  XamBattleship
//
//  Created by Wadim on 07/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEFigure : NSObject

@property (nonatomic, strong) UIView *view;

- (instancetype)initWithArray:(NSArray *)array;
- (NSArray *)modelArray;
- (void)rotate;
- (void)centerWithRect:(CGRect)rect;

@end


@interface SEFigureKit : NSObject

@property (nonatomic, strong) UIView *templateBlock;

+ (SEFigureKit *)sharedKit;
- (SEFigure *)figureWithNumberOfBlocks:(NSNumber /* with UInt < 5 */*)numberOfBlocks
    color:(UIColor *)figureColor;

@end
