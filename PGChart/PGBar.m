//
//  PGBar.m
//  PGChart
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGBar.h"
#import "PGColor.h"

@implementation PGBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapSquare;
        _chartLine.fillColor = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth = self.frame.size.width;
        _chartLine.strokeEnd = 0.0;
        self.clipsToBounds = YES;
        [self.layer addSublayer:_chartLine];
        self.layer.cornerRadius = 2.0;
    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (grade==0)
        return;
    
    _grade = grade;
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, 0)];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    _chartLine.path = progressline.CGPath;
    
    if (_barColor) {
        _chartLine.strokeColor = [_barColor CGColor];
    }else{
        _chartLine.strokeColor = [PGColor_Green CGColor];
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 2.0;
}

- (void)drawRect:(CGRect)rect
{
    //Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
}

@end
