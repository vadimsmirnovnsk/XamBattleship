//
//  SEFigureKit.m
//  XamBattleship
//
//  Created by Wadim on 07/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "SEFigureKit.h"

typedef NS_ENUM(NSUInteger, BucketType) {
    bucketTypeEmpty = 0,
    bucketTypeBlock = 1
};


@interface SEFigure ()

@property (nonatomic, copy) NSMutableArray /* of NSNumbers with Int */ *modelArray;
@property (nonatomic, copy) NSMutableArray /* of UIViews */ *viewsArray;
@property (nonatomic, weak) SEFigureKit *kit;
@property (nonatomic, strong) UIColor *figureColor;

@end


@implementation SEFigure

- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        _modelArray = [array mutableCopy];
        _viewsArray = [@[]mutableCopy];
        _view = [[UIView alloc]init];
        _view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma Getters
- (NSArray *)modelArray
{
    return [_modelArray copy];
}

// Lazy getter of the figure view
- (UIView *)view
{
    if (![self.viewsArray count]) {
        [self redrawView];
    }
    return _view;
}

- (void)redrawView
{
    if (self.viewsArray) {
        for (UIView *block in self.viewsArray) {
            [block removeFromSuperview];
        }
        [self.viewsArray removeAllObjects];
    }
    // Let's create new views for figure
    NSUInteger squareFactor = (int)sqrt((double)[self.modelArray count]);
    _view.frame = (CGRect) {
        0,
        0,
        self.kit.templateBlock.frame.size.width * squareFactor,
        self.kit.templateBlock.frame.size.height * squareFactor
    };
    for (NSUInteger y = 0; y < squareFactor; y++) {
        for (NSUInteger x = 0; x < squareFactor; x++) {
            if ([self.modelArray[y*squareFactor + x] intValue] == bucketTypeBlock) {
                CGRect newFrame = (CGRect) {
                    x * self.kit.templateBlock.frame.size.width,
                    y * self.kit.templateBlock.frame.size.height,
                    self.kit.templateBlock.frame.size.width,
                    self.kit.templateBlock.frame.size.height
                };
                UIView *newBlock = [[UIView alloc]initWithFrame:newFrame];
                if (self.figureColor) {
                    newBlock.backgroundColor = self.figureColor;
                }
                else {
                    newBlock.backgroundColor = self.kit.templateBlock.backgroundColor;
                }
                newBlock.layer.cornerRadius = self.kit.templateBlock.layer.cornerRadius;
                newBlock.layer.borderWidth = self.kit.templateBlock.layer.borderWidth;
                newBlock.layer.borderColor = self.kit.templateBlock.layer.borderColor;
                [self.viewsArray addObject:newBlock];
                [_view addSubview:newBlock];
            }
        }
    }
}

- (void)rotate
{
#warning TODO: Make universal rotate for any figure.
    NSLog(@"Rotate figure");
}

- (void)centerWithRect:(CGRect)rect
{
    [self view];
    CGRect newFrame = (CGRect) {
        rect.size.width/2 - _view.frame.size.width/2,
        rect.size.height/2 - _view.frame.size.height/2,
        _view.frame.size
    };
    _view.frame = newFrame;
}

@end


@implementation SEFigureKit

+ (SEFigureKit *)sharedKit
{
    static SEFigureKit *sharedKit;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedKit = [[SEFigureKit alloc]init];
    });
    return sharedKit;
}

+ (NSArray *)arrayOfModelsForNumberOfBlocks:(NSNumber *)numberOfBlocks
{
    static NSDictionary *figures;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        figures = @{@(1): @[@[@(1)]],
                    @(2): @[@[@(0), @(0),
                              @(1), @(1)],
                            @[@(0), @(1),
                              @(0), @(1)]],
                    @(3): @[@[@(0), @(0), @(0),
                              @(1), @(1), @(1),
                              @(0), @(0), @(0)],
                            @[@(0), @(1), @(0),
                              @(0), @(1), @(1),
                              @(0), @(0), @(0)]],
                    @(4): @[@[@(0), @(0), @(0), @(0),
                              @(1), @(1), @(0), @(0),
                              @(0), @(1), @(1), @(0),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(0), @(1), @(1), @(0),
                              @(1), @(1), @(0), @(0),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(1), @(0), @(0), @(0),
                              @(1), @(1), @(1), @(0),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(0), @(0), @(1), @(0),
                              @(1), @(1), @(1), @(0),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(0), @(0), @(0), @(0),
                              @(1), @(1), @(1), @(1),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(0), @(1), @(0), @(0),
                              @(1), @(1), @(1), @(0),
                              @(0), @(0), @(0), @(0)],
                            @[@(0), @(0), @(0), @(0),
                              @(1), @(1), @(0), @(0),
                              @(1), @(1), @(0), @(0),
                              @(0), @(0), @(0), @(0)]]
                    };
    });
    if (figures[numberOfBlocks]) {
        return figures[numberOfBlocks];
    }
    else return nil;
}

- (SEFigure *)figureWithNumberOfBlocks:(NSNumber *)numberOfBlocks color:(UIColor *)figureColor
{
    NSArray *const figureArray = [SEFigureKit arrayOfModelsForNumberOfBlocks:numberOfBlocks];
    SEFigure *newFigure = nil;
    if (figureArray) {
        NSUInteger randomIndex = (int)arc4random()%[figureArray count];
        newFigure = [[SEFigure alloc]initWithArray:
            figureArray[randomIndex]];
        newFigure.kit = self;
        newFigure.figureColor = figureColor;
    }
    return newFigure;
}

@end
