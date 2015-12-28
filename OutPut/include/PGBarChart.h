//
//  PGBarChart.h
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
 
 NSArray *ary1 = @[@"20.5",@"54",@"15",@"30",@"42",@"77",@"43"];
 NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
 NSArray *ary5 = @[@"34",@"32",@"54",@"23",@"76",@"16",@"10"];
 
 PGBarChart *barChart = [[PGBarChart alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 200)];
 barChart.yValues = @[ary1,ary2,ary5];
 barChart.yLabels = @[ary1,ary2,ary5];
 barChart.xLabels = [self getXTitles:7];
 barChart.showRange = YES;
 barChart.chooseRange = CGRangeMake(100, 0);
 barChart.bShowHorizonLine = YES;
 barChart.levelNum = 5;
 barChart.minBarWidth = 30;
 barChart.bShowValue = YES;
 [barChart showInView:self.view];
 */



#import "PGChart.h"

@interface PGBarChart : PGChart
{
    float minBarWidth;
}

@property(nonatomic, assign)float minBarWidth;
@property(nonatomic, assign)float nLabelMargin;

@end
