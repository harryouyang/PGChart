//
//  PGBarChart.m
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGBarChart.h"
#import "PGChartLabel.h"
#import "PGBar.h"

@interface PGBarChart ()
{
    UIScrollView *scrollView;
    NSMutableArray *arHorizonLine;
    UIView *lineView;
}
@end

@implementation PGBarChart
@synthesize minBarWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        minBarWidth = 20;
        self.levelNum = 4;
        self.nLabelMargin = xLabelMargin;
        self.colors = @[PGColor_Green,PGColor_Red,PGColor_Brown,PGColor_PinkGrey,PGColor_StarYellow,PGColor_DarkBlue];
        self.clipsToBounds = YES;
        
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(PGYLabelwidth, 0, frame.size.width-PGYLabelwidth, frame.size.height)];
//        lineView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:lineView];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(PGYLabelwidth, 0, frame.size.width-PGYLabelwidth, frame.size.height)];
        [self addSubview:scrollView];
        
        self.backgroundColor = [UIColor whiteColor];
        scrollView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)computeChart
{
    [self createXLabels];
    [self createYLabels];
}

- (void)createXLabels
{
    NSInteger num;
    if (self.xLabels.count >= 8)
    {
        num = 8;
    }
    else if(self.xLabels.count <= 4)
    {
        num = 4;
    }
    else
    {
        num = self.xLabels.count;
    }
    self.xLabelWidth = scrollView.frame.size.width / num;
    
    float minWidth = minBarWidth*self.yValues.count+2*self.nLabelMargin;
    if(self.xLabelWidth < minWidth)
    {
        self.xLabelWidth = minWidth;
    }
    
    minBarWidth = (self.xLabelWidth-2*self.nLabelMargin)/self.yValues.count;
    
    for (int i=0; i<self.xLabels.count; i++)
    {
        PGChartLabel * label = [[PGChartLabel alloc] initWithFrame:CGRectMake((i *  self.xLabelWidth ), self.frame.size.height - PGLabelHeight-PGLabelHeight/2, self.xLabelWidth, PGLabelHeight)];
        label.text = self.xLabels[i];
        [scrollView addSubview:label];
    }
    
    float max = self.xLabels.count*self.xLabelWidth;
    if(scrollView.frame.size.width > max)
    {
        max = scrollView.frame.size.width;
    }
    
    scrollView.contentSize = CGSizeMake(max, scrollView.frame.size.height);
}

- (void)createYLabels
{
    float max = 0;
    float min = MAXFLOAT;
    for (NSArray *ary in self.yLabels)
    {
        for (NSString *valueString in ary)
        {
            float value = [valueString floatValue];
            if (value > max)
            {
                max = value;
            }
            if (value < min)
            {
                min = value;
            }
        }
    }
    
    if(self.showRange)
    {
        self.yValueMin = min;
    }
    else
    {
        self.yValueMin = 0;
    }
    self.yValueMax = max;
    
    self.yValueMax += 5.0; //保证美观，确保没有一柱能到y坐标顶点
    
    if (self.chooseRange.max != self.chooseRange.min)
    {
        self.yValueMax = self.chooseRange.max;
        self.yValueMin = self.chooseRange.min;
    }
    
    float level = (self.yValueMax - self.yValueMin) / self.levelNum;
    CGFloat chartCavanHeight = self.frame.size.height - PGLabelHeight*3;
    CGFloat levelHeight = chartCavanHeight / self.levelNum;
    
    for (int i=0; i<self.levelNum+1; i++)
    {
        PGChartLabel *label = [[PGChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+PGLabelHeight/2, PGYLabelwidth, PGLabelHeight)];
        if(self.decimalPlaces == 0)
        {
            label.text = [NSString stringWithFormat:@"%.0f",level * i+self.yValueMin];
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%.1f",level * i+self.yValueMin];
        }
        [self addSubview:label];
    }
}

- (void)strokeChart
{
    [self computeChart];
    
    CGFloat chartCavanHeight = self.frame.size.height - PGLabelHeight*3;
    
    for (int i=0; i<self.yValues.count; i++)
    {
        NSArray *childAry = self.yValues[i];
        for (int j=0; j<childAry.count; j++)
        {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-self.yValueMin) / ((float)self.yValueMax-self.yValueMin);
            
            PGBar *bar = [[PGBar alloc] initWithFrame:CGRectMake(self.nLabelMargin+j*self.xLabelWidth+i*minBarWidth, PGLabelHeight+(1-grade)*chartCavanHeight, minBarWidth, chartCavanHeight*grade)];
            bar.barColor = [self.colors objectAtIndex:i];
            [scrollView addSubview:bar];
            bar.grade = grade;
            
            [self createTagTitle:CGPointMake(bar.frame.origin.x+bar.frame.size.width/2, bar.frame.origin.y) color:bar.barColor value:value];
        }
    }
}

- (void)createTagTitle:(CGPoint)point color:(UIColor *)color value:(float)value
{
    if(self.bShowValue)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-PGTagLabelwidth/2.0, point.y-PGLabelHeight, PGTagLabelwidth, PGLabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = color;
        if(self.decimalPlaces == 0)
            label.text = [NSString stringWithFormat:@"%0.0f",value];
        else
            label.text = [NSString stringWithFormat:@"%0.1f",value];
        
        [scrollView addSubview:label];
    }
}

- (void)createCoordinateAxis
{
    CGFloat chartCavanHeight = self.frame.size.height - PGLabelHeight*3;
    UIView *yline = [[UIView alloc] initWithFrame:CGRectMake(PGYLabelwidth, PGLabelHeight, 0.5f, chartCavanHeight)];
    yline.backgroundColor = [UIColor blackColor];
    [self addSubview:yline];
    
    UIView *xline = [[UIView alloc] initWithFrame:CGRectMake(PGYLabelwidth, chartCavanHeight+PGLabelHeight, self.frame.size.width-PGYLabelwidth, 0.5f)];
    xline.backgroundColor = [UIColor blackColor];
    [self addSubview:xline];
}

- (void)showHorizonLine
{
    CGFloat chartCavanHeight = self.frame.size.height - PGLabelHeight*3;
    CGFloat levelHeight = chartCavanHeight / self.levelNum;
    
    //画横线
    for (int i=0; i<self.levelNum+1; i++)
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(PGYLabelwidth,PGLabelHeight+i*levelHeight)];
        [path addLineToPoint:CGPointMake(self.frame.size.width,PGLabelHeight+i*levelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5;
        [self.layer insertSublayer:shapeLayer atIndex:0];
    }
}

- (void)showInView:(UIView *)pView
{
    if(self.bShowHorizonLine)
    {
        [self showHorizonLine];
    }
    [self strokeChart];
    [self createCoordinateAxis];
    [pView addSubview:self];
}

@end
