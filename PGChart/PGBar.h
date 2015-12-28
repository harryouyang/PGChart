//
//  PGBar.h
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGBar : UIView

@property(nonatomic)float grade;
@property(nonatomic, strong)CAShapeLayer *chartLine;
@property(nonatomic, strong)UIColor *barColor;

@end
