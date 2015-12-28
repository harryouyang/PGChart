//
//  PGChart.m
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGChart.h"

@implementation PGChart

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.yLabelFont = [UIFont systemFontOfSize:10];
        self.xLabelFont = [UIFont systemFontOfSize:10];
        self.xLabelColor = [UIColor blackColor];
        self.yLabelColor = [UIColor blackColor];
    }
    return self;
}

- (void)computeChart
{
}

- (void)showInView:(UIView *)pView
{
    [pView addSubview:self];
}

@end
