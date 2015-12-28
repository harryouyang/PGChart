//
//  PGChart.h
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGColor.h"

#define chartMargin         10
#define xLabelMargin        15
#define yLabelMargin        15
#define PGLabelHeight       10
#define PGYLabelwidth       30
#define PGTagLabelwidth     80

@interface PGChart : UIView

@property(strong, nonatomic)NSArray *xLabels;
@property(strong, nonatomic)NSArray *yLabels;
@property(strong, nonatomic)NSArray *yValues;
@property(nonatomic, strong)NSArray *colors;

@property(nonatomic, strong)UIFont *xLabelFont;
@property(nonatomic, strong)UIFont *yLabelFont;
@property(nonatomic, strong)UIColor *xLabelColor;
@property(nonatomic, strong)UIColor *yLabelColor;

@property(nonatomic)CGFloat xLabelWidth;
@property(nonatomic)CGFloat yValueMin;
@property(nonatomic)CGFloat yValueMax;

@property(nonatomic, assign)BOOL showRange;
@property(nonatomic, assign)CGRange chooseRange;

@property(nonatomic, assign)unsigned int levelNum;

@property(nonatomic, assign)BOOL bShowHorizonLine;

@property(nonatomic, assign)BOOL bShowValue;

@property(nonatomic, assign)int decimalPlaces;

@property(nonatomic, assign)CGFloat animationSpeed;//动画速度

- (void)showInView:(UIView *)pView;

@end
