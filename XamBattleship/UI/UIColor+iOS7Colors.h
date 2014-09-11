
#import <UIKit/UIKit.h>

@interface UIColor (iOS7Colors)

//      http://chir.ag/projects/name-that-color/


+ (NSArray *) sharedColorNames;

/**
 *
 * Returns UIColor with random name from NSArray [UIColor sharedColorNames]
 *
 */
+ (UIColor *) randomColor;

#pragma mark Clear Colors

+ (UIColor *)silverColor;
+ (UIColor *)altoColor;
+ (UIColor *)manateeColor;
+ (UIColor *)radicalRedColor;
+ (UIColor *)redOrangeColor;
+ (UIColor *)pizazzColor;
+ (UIColor *)supernovaColor;
+ (UIColor *)emeraldColor;
+ (UIColor *)malibuColor;
+ (UIColor *)curiousBlueColor;
+ (UIColor *)azureRadianceColor;
+ (UIColor *)indigoColor;
+ (UIColor *)mineShaftColor;
+ (UIColor *)lightSilverColor;
+ (UIColor *)doveGrayColor;
+ (UIColor *)darkMineShaftColor;
+ (UIColor *)mercuryColor;


#pragma mark Aliaces

+ (UIColor *)iOS7BlackColor;
+ (UIColor *)iOS7PurpleColor;
+ (UIColor *)iOS7DarkBlueColor;
+ (UIColor *)iOS7MarineBlueColor;
+ (UIColor *)iOS7LightBlueColor;
+ (UIColor *)iOS7GreenColor;
+ (UIColor *)iOS7YellowColor;
+ (UIColor *)iOS7OrangeColor;
+ (UIColor *)iOS7RedColor;
+ (UIColor *)iOS7PinkColor;
+ (UIColor *)iOS7GrayColor;

+ (UIColor *)rhythmusDividerColor;
+ (UIColor *)rhythmusPlaybackPanelColor;
+ (UIColor *)rhythmusMetronomeTextColor;
+ (UIColor *)rhythmusMetronomeBackgroundColor;
+ (UIColor *)rhythmusLedOffColor;
+ (UIColor *)rhythmusLedOnColor;
+ (UIColor *)rhythmusBackgroundColor;
+ (UIColor *)rhythmusTapBarColor;
+ (UIColor *)rhythmusNavBarColor;

@end
