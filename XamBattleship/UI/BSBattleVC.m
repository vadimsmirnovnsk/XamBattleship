//
//  BSBattleVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSBattleVC.h"
#import "UIColor+iOS7Colors.h"
#import "SEFigureKit.h"
#import "SEGamingCard.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


#pragma mark - BSBattleVC Constants

static NSUInteger const gameAreaWidth = 10;
static NSUInteger const gameAreaHeight = 10;
static NSUInteger const gameAreaTopAsset = 20 + 44 + 5;
static NSUInteger const gameAreaLeftAsset = 5;
static NSUInteger const gameCellHeight = 31;
static NSUInteger const gameCellWidth = 31;

static NSUInteger const gameCardWidth = 74;
static NSUInteger const gameCardHeight = 86;
static NSUInteger const gameCardHorizontalAsset = 5;
static NSUInteger const gameCardVerticalAsset = 4;
static NSUInteger const gameCardBlockHeight = 15;
static NSUInteger const gameCardBlockWidth = 15;
static NSUInteger const gameCardBlockCornerRadius = 3;


#pragma mark - BSPrepareBattleVC Interface

@interface BSPrepareBattleVC : UIViewController

@property (nonatomic, weak) id<SEFigureKitDragDropDelegate> dragDropDelgate;

@end


#pragma mark - BSPrepareBattleVC Extension

@interface BSPrepareBattleVC () <SEGamingCardDelegate>

@property (nonatomic, copy) NSMutableArray /* of SEGamingCards */ *cards;

@end


#pragma mark - BSPrepareBattleVC Implementation

@implementation BSPrepareBattleVC

+ (CGRect)selfFrame
{
    if (isiPhone5)
     {
        return (CGRect) {
            0,
            384,
            320,
            184
        };
     }
     else
     {
        return (CGRect) {
            0,
            384,
            320,
            96
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
        _cards = [@[] mutableCopy];
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
    [SEFigureKit sharedKit].dragDropDelegate = self.dragDropDelgate;
    // Create cards with figures.
    for (NSNumber *tubesNumber in shipTubes) {
        SEFigure *newFigure = [[SEFigureKit sharedKit]figureWithNumberOfBlocks:tubesNumber color:[UIColor randomColor]];
        CGRect cardFrame = [BSPrepareBattleVC cardFrame];
        cardFrame = (CGRect)(CGRect) {
            cardFrame.origin.x + gameCardHorizontalAsset +
                (([_cards count]<4)?
                (cardFrame.size.width + gameCardHorizontalAsset) * [_cards count]
                :(cardFrame.size.width + gameCardHorizontalAsset) * ([_cards count]-4)),
            cardFrame.origin.y + gameCardVerticalAsset
            + (([_cards count]<4)? 0 : (gameCardVerticalAsset+gameCardHeight)),
            cardFrame.size
        };
        SEGamingCard *newCard = [SEGamingCard cardWithFigure:newFigure frame:cardFrame];
        newCard.delegate = self;
        [_cards addObject:newCard];
        [self.view addSubview:newCard.view];
    }
}

- (void)didTouchCard:(UIButton *)cardButton
{
    NSLog(@"Did Touch the card: %@", cardButton);
}

#pragma mark SEGamingCardDelegate Protocol

- (void) cardWillDelete:(SEGamingCard *)card
{
    [self.cards removeObject:card];
}

@end


#pragma mark - BSBattleVC Extension

@interface BSBattleVC () <SEFigureKitDragDropDelegate>

@property (nonatomic, strong) NSMutableArray *gameFieldButtons;
@property (nonatomic, strong) UIButton *backToMenuButton;
@property (nonatomic, strong) BSPrepareBattleVC * prepareButtleVC;

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
        _gameFieldButtons = [NSMutableArray arrayWithCapacity:gameAreaWidth * gameAreaHeight];
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
    }
    // Fill the game field by UIButtons
    for (NSUInteger i = 0; i < gameAreaHeight; i++) {
        for (NSUInteger j = 0; j < gameAreaWidth; j++) {
            UIButton *newGameCell = [[UIButton alloc]init];
            newGameCell.frame = (CGRect){
                i * gameCellWidth + gameAreaLeftAsset,
                j * gameCellHeight + gameAreaTopAsset,
                gameCellWidth,
                gameCellHeight
            };
            newGameCell.tag = j * gameAreaHeight + i;
            newGameCell.layer.cornerRadius = 8;
            newGameCell.layer.borderWidth = 0.7;
            newGameCell.layer.borderColor = [UIColor lightSilverColor].CGColor;
            newGameCell.backgroundColor = [UIColor clearColor];
            [newGameCell addTarget:self action:@selector(didTappedGameAreaButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:newGameCell];
        }
    }
    self.view.frame = [BSBattleVC selfFrame];
    self.prepareButtleVC = [[BSPrepareBattleVC alloc]init];
    [self addChildViewController:self.prepareButtleVC];
    [self.prepareButtleVC didMoveToParentViewController:self];
    self.prepareButtleVC.dragDropDelgate = self;
    [self.view addSubview:self.prepareButtleVC.view];
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate battleVCWillDismissed:self];
}

- (void)didTappedGameAreaButton:(UIButton *)sender
{
    NSLog(@"Tapped button with tag: %d", sender.tag);
}

- (void)didTappedBackToMenuButton:(UIButton *)sender
{
    [self.delegate battleVCWillDismissed:self];
}

#pragma mark SEFigureKitDragDropDelegate Methods

- (void) figureDidMove:(SEFigure *)figure
{
    NSLog(@"Figure moved!");
}

- (BOOL) figureWillDrope:(SEFigure *)figure
{
    CGRect figureAbsolutFrame = [figure.view.superview
        convertRect:figure.view.frame toView:nil];
    if (CGRectContainsRect((CGRect){0, gameAreaTopAsset - 5 ,320,
    gameAreaHeight * gameCellHeight + 10}, figureAbsolutFrame) ) {
        return YES;
    }
    else return NO;
}


@end
