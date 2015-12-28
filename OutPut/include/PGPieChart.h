//
//  PGPieChart.h
//  PGChart
//
//  Created by ouyanghua on 15/12/16.
//  Copyright © 2015年 pangu. All rights reserved.
//

//demo
/*
NSArray *ary1 = @[@"20.5",@"50",@"15",@"30",@"42",@"77",@"43"];

PGPieChart  *pieChart = [[PGPieChart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
pieChart.yValues = ary1;
pieChart.yLabels = ary1;
[pieChart showInView:self.view];
*/

#import "PGChart.h"

@class PGPieChart;
@protocol PGPieChartDelegate <NSObject>
@optional
- (void)pieChart:(PGPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PGPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PGPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(PGPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
@end

@interface PGPieChart : PGChart
@property(nonatomic, weak) id<PGPieChartDelegate> delegate;
@property(nonatomic, assign)CGFloat startPieAngle;
@property(nonatomic, assign)CGPoint pieCenter;
@property(nonatomic, assign)CGFloat pieRadius;

@property(nonatomic, strong)UIColor *labelColor;
@property(nonatomic, assign)CGFloat labelRadius;
@property(nonatomic, assign)CGFloat selectedSliceOffsetRadius;
@property(nonatomic, assign)CGFloat selectedSliceStroke;

- (void)setPieBackgroundColor:(UIColor *)color;

@end
