//
//  PGLineChart.h
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

//demo
/*
 self.automaticallyAdjustsScrollViewInsets = NO;
 
 - (NSArray *)getXTitles:(int)num
 {
 NSMutableArray *xTitles = [NSMutableArray array];
 for (int i=0; i<num; i++) {
 NSString * str = [NSString stringWithFormat:@"R-%d",i];
 [xTitles addObject:str];
 }
 return xTitles;
 }
 
 PGLineChart *lineChart = [[PGLineChart alloc] initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 200)];
 lineChart.yValues = @[ary1,ary2,ary5];
 lineChart.yLabels = @[ary1,ary2,ary5];
 lineChart.xLabels = [self getXTitles:7];
 //    lineChart.showRange = YES;
 //    lineChart.chooseRange = CGRangeMake(100, 0);
 lineChart.bShowHorizonLine = YES;
 lineChart.levelNum = 5;
 lineChart.minXTitleWidth = 80;
 lineChart.nodetype = EnodeType_HOLLOW;
 lineChart.bShowValue = YES;
 [lineChart showInView:self.view];
 */

#import "PGChart.h"

#define ENodeType_NONE      0
#define ENodeType_SOLID     1
#define EnodeType_HOLLOW    2

@interface PGLineChart : PGChart
{
    float minXTitleWidth;
}

@property(nonatomic, assign)float minXTitleWidth;
@property(nonatomic, retain)NSMutableArray *ShowHorizonLine;
@property(nonatomic, assign)int nodetype;

@end
