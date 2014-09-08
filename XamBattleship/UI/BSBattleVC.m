//
//  BSBattleVC.m
//  XamBattleship
//
//  Created by Wadim on 04/09/14.
//  Copyright (c) 2014 Smirnov Electronics. All rights reserved.
//

#import "BSBattleVC.h"
#import "UIColor+iOS7Colors.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


#pragma mark - BSBattleVC Constants

static NSUInteger const gameAreaWidth = 10;
static NSUInteger const gameAreaHeight = 10;
static NSUInteger const gameAreaTopAsset = 20 + 44 + 5;
static NSUInteger const gameAreaLeftAsset = 5;
static NSUInteger const gameCellHeight = 31;
static NSUInteger const gameCellWidth = 31;


#pragma mark - BSPrepareBattleVC Interface

@interface BSPrepareBattleVC : UIViewController

@end


#pragma mark - BSPrepareBattleVC Extension

@interface BSPrepareBattleVC ()

@end


#pragma mark - BSPrepareBattleVC Implementation

@implementation BSPrepareBattleVC

+ (CGRect)frameRect
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void) viewDidLoad
{
    self.view.frame = [BSPrepareBattleVC frameRect];
    self.view.backgroundColor = [UIColor mineShaftColor];
}

@end


#pragma mark - BSBattleVC Extension

@interface BSBattleVC ()

@property (nonatomic, strong) NSMutableArray *gameFieldButtons;
@property (nonatomic, strong) UIButton *backToMenuButton;
@property (nonatomic, strong) BSPrepareBattleVC * prepareButtleVC;

@end


#pragma mark - BSBattleVC Implementation

@implementation BSBattleVC

+ (CGRect)frameRect
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
    self.view.frame = [BSBattleVC frameRect];
    self.prepareButtleVC = [[BSPrepareBattleVC alloc]init];
    [self addChildViewController:self.prepareButtleVC];
    [self.prepareButtleVC didMoveToParentViewController:self];
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


@end
