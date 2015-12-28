//
//  PGLineChart.m
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGLineChart.h"
#import "PGChartLabel.h"

@interface PGLineChart ()
{
    UIScrollView *scrollView;
    NSMutableArray *arHorizonLine;
    UIView *lineView;
}
@end

@implementation PGLineChart
@synthesize minXTitleWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        minXTitleWidth = 40.0f;
        self.levelNum = 4;
        self.colors = @[PGColor_Green,PGColor_Red,PGColor_Brown,PGColor_PinkGrey,PGColor_StarYellow,PGColor_DarkBlue];
        self.clipsToBounds = YES;
        
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
    
    if(self.xLabelWidth < minXTitleWidth)
    {
        self.xLabelWidth = minXTitleWidth;
    }
    
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
        
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [scrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (self.xLabelWidth/2.0);
        
        float grade = ((float)firstValue-self.yValueMin) / ((float)self.yValueMax-self.yValueMin);
        
        CGPoint point = CGPointMake(xPosition, (1 - grade)*chartCavanHeight + PGLabelHeight);
        [progressline moveToPoint:point];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        [self addPoint:point color:[self.colors objectAtIndex:i] tag:i*childAry.count value:firstValue];
        
        for(int j=1; j<childAry.count; j++)
        {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-self.yValueMin) / ((float)self.yValueMax-self.yValueMin);
            
            CGPoint point = CGPointMake(xPosition+j*self.xLabelWidth, (1 - grade)*chartCavanHeight + PGLabelHeight);
            [progressline addLineToPoint:point];
            
            [progressline moveToPoint:point];
            
            [self addPoint:point color:[self.colors objectAtIndex:i] tag:i*childAry.count+j value:value];
        }
        
        _chartLine.path = progressline.CGPath;
        
        _chartLine.strokeColor = ((UIColor *)[self.colors objectAtIndex:i]).CGColor;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
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
    
    if(self.bShowHorizonLine)
    {
        [self showHorizonLine];
    }
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
    
    //画竖线
    for (int i=0; i<self.xLabels.count+1; i++)
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake((i+1)*self.xLabelWidth,PGLabelHeight)];
        [path addLineToPoint:CGPointMake((i+1)*self.xLabelWidth,PGLabelHeight+chartCavanHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5;
        [scrollView.layer insertSublayer:shapeLayer atIndex:0];
    }
}

- (void)showInView:(UIView *)pView
{
    [self strokeChart];
    
    [self createCoordinateAxis];
    [pView addSubview:self];
    
}

- (void)createNode:(CGPoint)point color:(UIColor *)color tag:(int)tag value:(float)value
{
    if(self.nodetype != ENodeType_NONE)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
        view.center = point;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        view.layer.borderWidth = 2;
        view.layer.borderColor = color.CGColor;
        view.tag = tag;
        
        if(self.nodetype == EnodeType_HOLLOW)
        {
            view.backgroundColor = self.backgroundColor;
        }
        else
        {
            view.backgroundColor = color;
        }
        
        [scrollView addSubview:view];
    }
}

- (void)createTagTitle:(CGPoint)point color:(UIColor *)color value:(float)value
{
    if(self.bShowValue)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-PGTagLabelwidth/2.0, point.y-PGLabelHeight*1.5, PGTagLabelwidth, PGLabelHeight)];
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

- (void)addPoint:(CGPoint)point color:(UIColor *)color tag:(int)tag value:(float)value
{
    [self createTagTitle:point color:color value:value];
    [self createNode:point color:color tag:tag value:value];
}

@end
