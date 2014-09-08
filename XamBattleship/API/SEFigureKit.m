//
//  SEFigureKit.m
//  XamBattleship
//
//  Created by Wadim on 07/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "SEFigureKit.h"


@interface SEFigure ()

@property (nonatomic, copy) NSMutableArray *modelArray;

@end


@implementation SEFigure

- (instancetype) initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        _modelArray = [array mutableCopy];
        _view = [[UIView alloc]init];
        _view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSArray *)modelArray
{
    return [_modelArray copy];
}

- (void)rotate
{
#warning TODO: Make universal rotate for any figure.
    NSLog(@"Rotate figure");
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

+ (NSArray *)arrayOfModelsForNumberOfBuckets:(NSNumber *)numberOfBuckets
{
    static NSDictionary *figures;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        figures = @{@(1): @[@(1)],
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
    if (figures[numberOfBuckets]) {
        return figures[numberOfBuckets];
    }
    else return nil;
}

- (SEFigure *)figureWithNumberOfBuckets:(NSNumber *)numberOfBuckets
{
    NSArray *const figureArray = [SEFigureKit arrayOfModelsForNumberOfBuckets:numberOfBuckets];
    SEFigure *newFigure = nil;
    if (figureArray) {
        newFigure = [[SEFigure alloc]initWithArray:
            figureArray[arc4random()%[figureArray count]]];
    }
    return newFigure;
}

@end
