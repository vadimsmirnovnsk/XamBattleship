//
//  SEFigureKit.m
//  XamBattleship
//
//  Created by Wadim on 07/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "SEFigureKit.h"

typedef NS_ENUM(NSUInteger, BlockType) {
    blockTypeEmpty = 0,
    blockTypeSolid = 1
};


#pragma mark - SEFigureBlock Implementation

@implementation SEFigureBlock
@end


#pragma mark - SEFigure Extansion

@interface SEFigure ()

@property (nonatomic, copy) NSMutableArray /* of NSNumbers with Int */ *modelArray;
@property (nonatomic, copy) NSMutableArray /* of SEFigureBlocks */ *viewsArray;
@property (nonatomic, weak) SEFigureKit *kit;
@property (nonatomic, strong) UIColor *figureColor;

@end


#pragma mark - SEFigure Implementation

@implementation SEFigure

#pragma Initializers
/**
 * Designated Initializer
 *
 * @input = NSArray with NSNumbers @(BlockType) that describes figure model
 *
 **/
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
        [self redrawViewWithTemplateBlock:self.kit.templateBlock];
    }
    return _view;
}

- (NSArray *)views
{
    return [_viewsArray copy];
}

- (BOOL)canDrop
{
    BOOL canDrop = YES;
    for (SEFigureBlock *block in self.viewsArray) {
        if (!block.canDrop) {
            canDrop = NO;
        }
    }
    return canDrop;
}

#pragma Public Methods
- (void)rotate:(NSUInteger)times
{
    NSMutableArray *newModelArray = [self.modelArray mutableCopy];
    NSUInteger squareFactor = (int)sqrt((double)[self.modelArray count]);
    for (NSUInteger time = 0; time < times; time++) {
        for (NSUInteger i = 0 ; i < squareFactor; i++) {
            for (NSUInteger j = 0; j < squareFactor; j++) {
                newModelArray[i*squareFactor + j] =
                    self.modelArray[(j+1) * squareFactor - 1 - i];
            }
        }
        self.modelArray = newModelArray;
    }
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

- (void)scaleToTemplateBlock:(UIView *)templateBlock
{
    [self redrawViewWithTemplateBlock:templateBlock];
}


#pragma Private Methods
- (void)redrawViewWithTemplateBlock:(UIView *)templateBlock
{
    if (self.viewsArray) {
        for (SEFigureBlock *block in self.viewsArray) {
            [block removeFromSuperview];
        }
        [self.viewsArray removeAllObjects];
    }
    // Let's create new views for figure
    NSUInteger squareFactor = (int)sqrt((double)[self.modelArray count]);
    CGRect newViewFrame = (CGRect){0,0,0,0};
    for (NSUInteger y = 0; y < squareFactor; y++) {
        for (NSUInteger x = 0; x < squareFactor; x++) {
            if ([self.modelArray[y*squareFactor + x] intValue] == blockTypeSolid) {
                CGRect newFrame = (CGRect) {
                    x * templateBlock.frame.size.width,
                    y * templateBlock.frame.size.height,
                    templateBlock.frame.size.width,
                    templateBlock.frame.size.height
                };
                if (!newViewFrame.size.width) {
                    newViewFrame = newFrame;
                }
                else {
                    newViewFrame = CGRectUnion(newViewFrame, newFrame);
                }
                SEFigureBlock *newBlock = [[SEFigureBlock alloc]initWithFrame:newFrame];
                if (self.figureColor) {
                    newBlock.backgroundColor = self.figureColor;
                    newBlock.surfaceColor = self.figureColor;
                }
                else {
                    newBlock.backgroundColor = templateBlock.backgroundColor;
                    newBlock.surfaceColor = templateBlock.backgroundColor;
                }
                newBlock.layer.cornerRadius = templateBlock.layer.cornerRadius;
                newBlock.layer.borderWidth = templateBlock.layer.borderWidth;
                newBlock.layer.borderColor = templateBlock.layer.borderColor;
                [self.viewsArray addObject:newBlock];
                [_view addSubview:newBlock];
            }
        }
    }
    for (UIView *block in self.viewsArray) {
        block.frame = (CGRect) {
            block.frame.origin.x - newViewFrame.origin.x,
            block.frame.origin.y - newViewFrame.origin.y,
            block.frame.size
        };
    }
    _view.frame = (CGRect){
        0,
        0,
        newViewFrame.size
    };
}

@end


#pragma mark - SEFigureKit Implementaion

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
