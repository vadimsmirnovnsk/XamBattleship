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

@end


@interface SEFigureKit : NSObject

+ (SEFigureKit *)sharedKit;

- (SEFigure *)figureWithNumberOfBuckets:(NSNumber /* with UInt < 5 */*)numberOfBuckets;

@end
