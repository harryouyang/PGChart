//
//  PGChartLabel.m
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGChartLabel.h"
#import "PGColor.h"

@implementation PGChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor:PGColor_DeepGrey];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
