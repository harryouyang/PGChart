//
//  PGColor.h
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define PGColor_Grey         [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0f]
#define PGColor_LightBlue    [UIColor colorWithRed:94.0/255.0 green:147.0/255.0 blue:196.0/255.0 alpha:1.0f]
#define PGColor_Green        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define PGColor_TitleColor   [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:113.0/255.0 alpha:1.0f]
#define PGColor_ButtonGrey   [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0f]
#define PGColor_FreshGreen   [UIColor colorWithRed:77.0/255.0 green:196.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define PGColor_Red          [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
#define PGColor_Mauve        [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:103.0/255.0 alpha:1.0f]
#define PGColor_Brown        [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f]
#define PGColor_Blue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]
#define PGColor_DarkBlue     [UIColor colorWithRed:121.0/255.0 green:134.0/255.0 blue:142.0/255.0 alpha:1.0f]
#define PGColor_Yellow       [UIColor colorWithRed:242.0/255.0 green:197.0/255.0 blue:117.0/255.0 alpha:1.0f]
#define PGColor_White        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f]
#define PGColor_DeepGrey     [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
#define PGColor_PinkGrey     [UIColor colorWithRed:200.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0f]
#define PGColor_HealYellow   [UIColor colorWithRed:245.0/255.0 green:242.0/255.0 blue:238.0/255.0 alpha:1.0f]
#define PGColor_LightGrey    [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
#define PGColor_CleanGrey    [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0f]
#define PGColor_LightYellow  [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]
#define PGColor_DarkYellow   [UIColor colorWithRed:152.0/255.0 green:150.0/255.0 blue:159.0/255.0 alpha:1.0f]
#define PGColor_PinkDark     [UIColor colorWithRed:170.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0f]
#define PGColor_CloudWhite   [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f]
#define PGColor_Black        [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0f]
#define PGColor_StarYellow   [UIColor colorWithRed:252.0/255.0 green:223.0/255.0 blue:101.0/255.0 alpha:1.0f]
#define PGColor_TwitterColor [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:243.0/255.0 alpha:1.0]
#define PGColor_WeiboColor   [UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]
#define PGColor_iOSGreenColor [UIColor colorWithRed:98.0/255.0 green:247.0/255.0 blue:77.0/255.0 alpha:1.0]
#define PGColor_RandomColor   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f]

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min)
{
    CGRange p;
    p.max = max;
    p.min = min;
    return p;
}

static const CGRange CGRangeZero = {0,0};


@interface PGColor : NSObject

- (UIImage *)imageFromColor:(UIColor *)color;

@end

