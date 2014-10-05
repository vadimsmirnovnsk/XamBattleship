//
//  BSBattleVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSBattleVC.h"
#import "UIColor+iOS7Colors.h"
#import "UIView+Hierarchy.h"
#import "SEFigureKit.h"
#import "SEGamingCard.h"
#import "SEGameCell.h"
#import "BSSpinner.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


#pragma mark - BSBattleVC Constants

static NSUInteger const kTopAsset = 0;// 20 + 44;
static NSUInteger const gameAreaWidth = 10;
static NSUInteger const gameAreaHeight = 10;
static NSUInteger const gameAreaTopAsset = 5 + kTopAsset;
static NSUInteger const gameAreaLeftAsset = 5;

static CGFloat const gameCellHeight = 31.f;
static CGFloat const gameCellWidth = 31.f;
static CGFloat const gameCellCornerRadius = 8.f;
static CGFloat const gameCellCornerWidth = 0.5f;

static CGFloat const gameCardWidth = 74.f;
static CGFloat const gameCardHeight = 86.f;
static CGFloat const gameCardHorizontalAsset = 5.f;
static CGFloat const gameCardVerticalAsset = 4.f;

static CGFloat const gameCardBlockHeight = 15.f;
static CGFloat const gameCardBlockWidth = 15.f;
static CGFloat const gameCardBlockCornerRadius = 3.f;


static NSUInteger const kCardsInRow = 4;
static NSUInteger const kShipsCount = 8;
static NSUInteger const kCardsCount = kShipsCount;


#pragma mark - BSPrepareBattleVCDelegate Protocol

@class BSPrepareBattleVC;
@protocol BSPrepareBattleVCDelegate <NSObject>
- (void)prepareButtleVCWillDissmissed:(BSPrepareBattleVC *)sender;
@end


#pragma mark - BSPrepareBattleVC Interface

@interface BSPrepareBattleVC : UIViewController

@property (nonatomic, weak) id<SEFigureKitDragDropDelegate> dragDropDelegate;
@property (nonatomic, weak) id<BSPrepareBattleVCDelegate> delegate;

@end


#pragma mark - BSPrepareBattleVC Extension

@interface BSPrepareBattleVC () <SEGamingCardDelegate>

@property (nonatomic, copy) NSMutableArray /* of SEGamingCards */ *cards;
@property (nonatomic, copy) NSMutableArray /* of SEGamingCards */ *deletedCards;

@end


#pragma mark - BSPrepareBattleVC Implementation

@implementation BSPrepareBattleVC

+ (CGRect)selfFrame
{
    if (isiPhone5)
     {
        return (CGRect) {
            0,
            320 + kTopAsset,
            320,
            248 - kTopAsset
        };
     }
     else
     {
        return (CGRect) {
            0,
            320 + kTopAsset,
            320,
            160 - kTopAsset
        };
     }
}

+ (CGRect)cardFrame
{
    if (isiPhone5)
     {
        return (CGRect) {
            0,
            0,
            gameCardWidth,
            gameCardHeight
        };
     }
     else
     {
        return (CGRect) {
            0,
            3,
            gameCardWidth,
            gameCardHeight
        };
     }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cards = [NSMutableArray arrayWithCapacity:kCardsCount];
        _deletedCards = [NSMutableArray arrayWithCapacity:kCardsCount];
    }
    return self;
}

- (void) viewDidLoad
{
    self.view.frame = [BSPrepareBattleVC selfFrame];
    self.view.backgroundColor = [UIColor mineShaftColor];

    NSArray *shipTubes = @[@(4), @(4), @(3), @(3), @(2), @(2), @(1), @(1)];
    UIView *templateBlock = [[UIView alloc]initWithFrame:(CGRect)
        {0, 0, gameCardBlockWidth, gameCardBlockHeight}];
    templateBlock.backgroundColor = [UIColor manateeColor];
    templateBlock.layer.cornerRadius = gameCardBlockCornerRadius;
    templateBlock.layer.borderWidth = 0.7;
    templateBlock.layer.borderColor = [UIColor clearColor].CGColor;
    [SEFigureKit sharedKit].templateBlock = templateBlock;
    [SEFigureKit sharedKit].dragDropDelegate = self.dragDropDelegate;
    // Create cards with figures.
    for (NSNumber *tubesNumber in shipTubes) {
        SEFigure *newFigure = [[SEFigureKit sharedKit]figureWithNumberOfBlocks:tubesNumber color:[UIColor randomColor]];
        [newFigure rotate:arc4random()%4];
        CGRect cardFrame = [BSPrepareBattleVC cardFrame];
        cardFrame = (CGRect)(CGRect) {
            cardFrame.origin.x + gameCardHorizontalAsset +
                (([_cards count]<kCardsInRow)?
                (cardFrame.size.width + gameCardHorizontalAsset) * [_cards count]
                :(cardFrame.size.width + gameCardHorizontalAsset) * ([_cards count]-4)),
            cardFrame.origin.y + gameCardVerticalAsset
            + (([_cards count]<kCardsInRow)? 0 : (gameCardVerticalAsset+gameCardHeight)),
            cardFrame.size
        };
        SEGamingCard *newCard = [SEGamingCard cardWithFigure:newFigure frame:cardFrame];
        newCard.delegate = self;
        [_cards addObject:newCard];
        [self.view addSubview:newCard.view];
    }
}


#pragma mark SEGamingCardDelegate Protocol
- (void)cardWillDelete:(SEGamingCard *)card
{
    [UIView animateWithDuration:0.3 animations:^{
        card.view.alpha = 0;
    } completion:^(BOOL finished) {
        NSUInteger indexOfDeletedCard = [self.cards indexOfObject:card];
        if (indexOfDeletedCard < kCardsInRow) {
            CGRect newFrame = card.view.frame;
            [UIView animateWithDuration:0.3 animations:^{
                [self.cards[kCardsInRow+indexOfDeletedCard] view].frame = newFrame;
            } completion:^(BOOL finished) {
                [card.view removeFromSuperview];
                [self.deletedCards addObject:card];
            }];
        }
        else {
            [card.view removeFromSuperview];
            [self.deletedCards addObject:card];
        }
        if ([self.deletedCards count] == kCardsCount) {
            UIButton *letsBattle = [UIButton buttonWithType:UIButtonTypeCustom];
            [letsBattle setFrame:(CGRect){
                self.view.bounds.origin.x + 10,
                self.view.bounds.origin.y + 10,
                self.view.bounds.size.height - 20,
                self.view.bounds.size.height - 20
            }];
            letsBattle.center = (CGPoint){
                self.view.bounds.size.width / 2,
                self.view.bounds.size.height / 2
            };
            letsBattle.layer.cornerRadius = (self.view.bounds.size.height - 20)/2;
            [letsBattle setTitle:@"Let's Battle!" forState:UIControlStateNormal];
            [letsBattle setBackgroundColor:[UIColor redOrangeColor]];
            [letsBattle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [letsBattle setTitleColor:[UIColor mineShaftColor] forState:UIControlStateHighlighted];
            letsBattle.alpha = 0.f;
            [letsBattle addTarget:self action:@selector(letsBattleButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:letsBattle];
            [UIView animateWithDuration:0.3 animations:^{
                letsBattle.alpha = 1.f;
            }];
        }
    }];
}

- (void)letsBattleButtonDidTouched:(UIButton *)sender
{
    [self.delegate prepareButtleVCWillDissmissed:self];
}

@end


#pragma mark - BSBattleVC Extension

@interface BSBattleVC () <SEFigureKitDragDropDelegate, BSPrepareBattleVCDelegate>

@property (nonatomic, strong) NSMutableArray *gameAreaCells;
@property (nonatomic, strong) UIButton *backToMenuButton;
@property (nonatomic, strong) BSPrepareBattleVC * prepareButtleVC;
@property (nonatomic, copy) NSMutableArray *shipModelsArray;
@property (nonatomic, strong) BSSpinner *spinner;

@end


#pragma mark - BSBattleVC Implementation

@implementation BSBattleVC

+ (CGRect)selfFrame
{
    if (isiPhone5)
     {
        return (CGRect) {
            0,
            0,
            320,
            568
        };
     }
     else
     {
        return (CGRect) {
            0,
            0,
            320,
            480
        };
     }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gameAreaCells = [NSMutableArray arrayWithCapacity:gameAreaWidth * gameAreaHeight];
        _shipModelsArray = [NSMutableArray arrayWithCapacity:kShipsCount];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor mercuryColor];
    // Tune the Navigation Controller
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem =
            [[UIBarButtonItem alloc]initWithTitle:@"Back to Menu"
                style:UIBarButtonItemStyleBordered target:self
                action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        [cancelBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    // [self.navigationController.navigationBar setBackgroundColor:[UIColor mineShaftColor]];
    // Fill the game field by UIButtons
    for (NSUInteger i = 0; i < gameAreaHeight; i++) {
        for (NSUInteger j = 0; j < gameAreaWidth; j++) {
            SEGameCell *newGameCell = [[SEGameCell alloc]init];
            newGameCell.button.frame = (CGRect){
                i * gameCellWidth + gameAreaLeftAsset,
                j * gameCellHeight + gameAreaTopAsset,
                gameCellWidth,
                gameCellHeight
            };
            newGameCell.button.tag = j * gameAreaHeight + i;
            newGameCell.button.layer.cornerRadius = gameCellCornerRadius;
            newGameCell.button.layer.borderWidth = gameCellCornerWidth;
            newGameCell.button.layer.borderColor = [UIColor lightSilverColor].CGColor;
            newGameCell.button.backgroundColor = [UIColor clearColor];
            [newGameCell.button addTarget:self action:@selector(didTappedGameAreaButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:newGameCell.button];
            [self.gameAreaCells addObject:newGameCell];
        }
    }
    self.view.frame = [BSBattleVC selfFrame];
    self.prepareButtleVC = [[BSPrepareBattleVC alloc]init];
    self.prepareButtleVC.delegate = self;
    [self addChildViewController:self.prepareButtleVC];
    [self.prepareButtleVC didMoveToParentViewController:self];
    self.prepareButtleVC.dragDropDelegate = self;
    [self.view addSubview:self.prepareButtleVC.view];
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate battleVCWillDismissed:self];
}

- (void)didTappedGameAreaButton:(UIButton *)sender
{
    NSLog(@"Tapped button with tag: %ld", (long)sender.tag);
}

- (void)didTappedBackToMenuButton:(UIButton *)sender
{
    [self.delegate battleVCWillDismissed:self];
}

- (void)snapFigureToGrid:(SEFigure *)figure
{
    for (SEGameCell *cell in self.gameAreaCells) {
        if (cell.state == gameStateEmpty) {
            for (SEFigureBlock *block in figure.views) {
                if (CGRectContainsPoint(cell.button.frame,
                    [block.superview convertPoint:block.center toView:self.view]
                    /*[block.superview convertPoint:block.center toView:nil]*/)) {
                    block.backgroundColor = block.surfaceColor;
                    cell.button.backgroundColor = block.backgroundColor;
                    block.canDrop = YES;
                    break;
                }
                else {
                    cell.button.backgroundColor = [UIColor clearColor];
                }
            }
        }
        else if (cell.state == gameStateBusy)
        for (SEFigureBlock *block in figure.views) {
            if (CGRectContainsPoint(cell.button.frame,
                [block.superview convertPoint:block.center toView:self.view])) {
                block.backgroundColor = [UIColor redColor];
                block.canDrop = NO;
            }
        }
    }
}

#pragma mark SEFigureKitDragDropDelegate Methods
- (void)figureDidMove:(SEFigure *)figure
{
    [self snapFigureToGrid:figure];
}

- (void)figureDidTouched:(SEFigure *)figure
{
    [figure.view bringToFrontOfView:self.view];
}

- (BOOL) figureWillDrope:(SEFigure *)figure
{
    CGRect figureAbsolutFrame = [figure.view.superview
        convertRect:figure.view.frame toView:self.view];
    if (CGRectContainsRect((CGRect){0, gameAreaTopAsset - 5 , 320,
    gameAreaHeight * gameCellHeight + 10}, figureAbsolutFrame) && ([figure canDrop])) {
        NSMutableArray *newShipModel = [NSMutableArray array];
        for (SEGameCell *cell in self.gameAreaCells) {
            for (SEFigureBlock *block in figure.views) {
                if (CGRectContainsPoint(cell.button.frame,
                    [block.superview convertPoint:block.center toView:self.view])) {
                    cell.button.backgroundColor = block.backgroundColor;
                    cell.state = gameStateBusy;
                    [newShipModel addObject:@(cell.button.tag)];
                    break;
                }
            }
        }
        [self.shipModelsArray addObject:newShipModel];
        return YES;
    }
    else {
        figure.view.frame = (CGRect){-1000, -1000, figure.view.frame.size};
        [self snapFigureToGrid:figure];
        return NO;
    }
}

#pragma mark BSPrepareBattleVCDelegate Protocol
- (void) prepareButtleVCWillDissmissed:(BSPrepareBattleVC *)sender
{
    UIView *grayView = [[UIView alloc]initWithFrame:(CGRect){0.f, 0.f, 320.f, 568.f}];
    grayView.backgroundColor = [UIColor mineShaftColor];
    grayView.alpha = 0.7f;
    [self.view addSubview:grayView];
    self.spinner = [BSSpinner animatedSpinnerWithFrame:
        [[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimation];
}


@end
