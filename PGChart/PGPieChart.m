//
//  PGPieChart.m
//  PGChart
//
//  Created by ouyanghua on 15/12/16.
//  Copyright © 2015年 pangu. All rights reserved.
//

#import "PGPieChart.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger kDefaultSliceZOrder = 100;

@interface PGSliceLayer : CAShapeLayer
@property(nonatomic, assign)CGFloat value;
@property(nonatomic, assign)CGFloat percentage;
@property(nonatomic, assign)double startAngle;
@property(nonatomic, assign)double endAngle;
@property(nonatomic, assign)BOOL isSelected;
@property(nonatomic, strong)NSString *desc;

@end

@implementation PGSliceLayer
@end

#pragma mark -
@interface PGPieChart ()
{
    NSInteger _selectedSliceIndex;
    UIView *_pieView;
    
    NSTimer *_animationTimer;
    NSMutableArray *_animations;
}
@end

@implementation PGPieChart

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _pieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _pieView.backgroundColor = [UIColor clearColor];
        [self addSubview:_pieView];
        
        self.colors = @[PGColor_Green,PGColor_Red,PGColor_Brown,PGColor_PinkGrey,PGColor_StarYellow,PGColor_DarkBlue,PGColor_PinkDark];
        _animations = [[NSMutableArray alloc] init];
        
        _selectedSliceIndex = -1;
        _labelColor = [UIColor whiteColor];
        
        self.pieRadius = MIN(frame.size.width/2, frame.size.height/2) - 10;
        self.pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
        _labelRadius = _pieRadius-20;
        _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
        
        self.animationSpeed = 1.0;
        _startPieAngle = M_PI_2;
        _selectedSliceStroke = 3.0;
        
        self.bShowValue = YES;
    }
    
    return self;
}

- (void)setPieCenter:(CGPoint)pieCenter
{
    [_pieView setCenter:pieCenter];
    _pieCenter = CGPointMake(_pieView.frame.size.width/2, _pieView.frame.size.height/2);
}

- (void)setPieRadius:(CGFloat)pieRadius
{
    _pieRadius = pieRadius;
    CGPoint origin = _pieView.frame.origin;
    CGRect frame = CGRectMake(origin.x+_pieCenter.x-pieRadius, origin.y+_pieCenter.y-pieRadius, pieRadius*2, pieRadius*2);
    _pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    [_pieView setFrame:frame];
    [_pieView.layer setCornerRadius:_pieRadius];
}

- (void)setPieBackgroundColor:(UIColor *)color
{
    [_pieView setBackgroundColor:color];
}

- (void)strokeChart
{
    CALayer *parentLayer = [_pieView layer];
    
    double startToAngle = 0.0;
    double endToAngle = startToAngle;
    
    NSUInteger sliceCount = self.yValues.count;
    double sum = 0.0;
    double values[sliceCount];
    for(int index = 0; index < sliceCount; index++)
    {
        NSString *valueString = [self.yValues objectAtIndex:index];
        float value = [valueString floatValue];
        values[index] = value;
        sum += value;
    }
    
    double angles[sliceCount];
    for (int index = 0; index < sliceCount; index++)
    {
        double div;
        if (sum == 0)
            div = 0;
        else
            div = values[index]/ sum;
        angles[index] = M_PI * 2 * div;
    }
    
    
    for(int index = 0; index < sliceCount; index++)
    {
        PGSliceLayer *layer =  [self createSliceLayer];
        double angle = angles[index];
        endToAngle += angle;
        double startFromAngle = _startPieAngle + startToAngle;
        double endFromAngle = _startPieAngle + endToAngle;
        
        layer.value = values[index];
        layer.percentage = (sum) ? layer.value/sum : 0;
        layer.desc = [self.yLabels objectAtIndex:index];
        
        UIColor *color = [self.colors objectAtIndex:(index%self.colors.count)];
         [layer setFillColor:color.CGColor];
        
        [self showDescForLayer:layer desc:layer.desc];
        
        CGPathRef path = CGPathCreateArc(_pieCenter, _pieRadius, startFromAngle, endFromAngle);
        [layer setPath:path];
        CFRelease(path);
        
        CALayer *labelLayer = [[layer sublayers] objectAtIndex:0];
        CGFloat interpolatedMidAngle = (endFromAngle + startFromAngle) / 2;
        [labelLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(interpolatedMidAngle)), _pieCenter.y + (_labelRadius * sin(interpolatedMidAngle)))];

        startToAngle = endToAngle;
        [parentLayer addSublayer:layer];
    }
    
    for(PGSliceLayer *layer in _pieView.layer.sublayers)
    {
        [layer setZPosition:kDefaultSliceZOrder];
    }
}

- (void)showInView:(UIView *)pView
{
    [self strokeChart];
    [pView addSubview:self];
}

- (PGSliceLayer *)createSliceLayer
{
    PGSliceLayer *pieLayer = [[PGSliceLayer alloc] init];
    [pieLayer setZPosition:0];
    [pieLayer setStrokeColor:NULL];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    CGFontRef font = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        font = CGFontCreateCopyWithVariations((__bridge CGFontRef)(self.yLabelFont), (__bridge CFDictionaryRef)(@{}));
    }
    else
    {
        font = CGFontCreateWithFontName((__bridge CFStringRef)[self.yLabelFont fontName]);
    }
    
    if (font)
    {
        [textLayer setFont:font];
        CFRelease(font);
    }
    [textLayer setFontSize:self.yLabelFont.pointSize];
    [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [textLayer setForegroundColor:self.yLabelColor.CGColor];
    
    CGSize size = [@"0" sizeWithAttributes:@{NSFontAttributeName:self.yLabelFont}];
    [CATransaction setDisableActions:YES];
    [textLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [textLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(0)), _pieCenter.y + (_labelRadius * sin(0)))];
    [CATransaction setDisableActions:NO];
    [pieLayer addSublayer:textLayer];
    
    return pieLayer;
}

#pragma mark - Touch Handing (Selection Notification)
- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PGSliceLayer *pieLayer = (PGSliceLayer *)obj;
        CGPathRef path = [pieLayer path];
        
        if (CGPathContainsPoint(path, &transform, point, 0)) {
            [pieLayer setLineWidth:_selectedSliceStroke];
            [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
            [pieLayer setLineJoin:kCALineJoinBevel];
            [pieLayer setZPosition:MAXFLOAT];
            selectedIndex = idx;
        } else {
            [pieLayer setZPosition:kDefaultSliceZOrder];
            [pieLayer setLineWidth:0.0];
        }
    }];
    return selectedIndex;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    [self getCurrentSelectedOnTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    [self notifyDelegateOfSelectionChangeFrom:_selectedSliceIndex to:selectedIndex];
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    for (PGSliceLayer *pieLayer in pieLayers) {
        [pieLayer setZPosition:kDefaultSliceZOrder];
        [pieLayer setLineWidth:0.0];
    }
}

- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection
{
    if (previousSelection != newSelection)
    {
        if(previousSelection != -1)
        {
            NSUInteger tempPre = previousSelection;
            if ([_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
                [_delegate pieChart:self willDeselectSliceAtIndex:tempPre];
            
            [self setSliceDeselectedAtIndex:tempPre];
            previousSelection = newSelection;
            if([_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                [_delegate pieChart:self didDeselectSliceAtIndex:tempPre];
        }
        
        if (newSelection != -1)
        {
            if([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
            
            [self setSliceSelectedAtIndex:newSelection];
            _selectedSliceIndex = newSelection;
            
            if([_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
        }
    }
    else if (newSelection != -1)
    {
        PGSliceLayer *layer = (PGSliceLayer *)[_pieView.layer.sublayers objectAtIndex:newSelection];
        if(_selectedSliceOffsetRadius > 0 && layer)
        {
            if (layer.isSelected)
            {
                if ([_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
                    [_delegate pieChart:self willDeselectSliceAtIndex:newSelection];
                
                [self setSliceDeselectedAtIndex:newSelection];
                
                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                    [_delegate pieChart:self didDeselectSliceAtIndex:newSelection];
                
                previousSelection = _selectedSliceIndex = -1;
            }
            else
            {
                if ([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                    [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
                
                [self setSliceSelectedAtIndex:newSelection];
                previousSelection = _selectedSliceIndex = newSelection;
                
                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                    [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
            }
        }
    }
}

#pragma mark -
- (void)setSliceSelectedAtIndex:(NSInteger)index
{
//    if(_selectedSliceOffsetRadius <= 0)
//        return;
//    PGSliceLayer *layer = (PGSliceLayer *)[_pieView.layer.sublayers objectAtIndex:index];
//    if (layer && !layer.isSelected)
//    {
//        CGPoint currPos = layer.position;
//        double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
//        CGPoint newPos = CGPointMake(currPos.x + _selectedSliceOffsetRadius*cos(middleAngle), currPos.y + _selectedSliceOffsetRadius*sin(middleAngle));
//        layer.position = newPos;
//        layer.isSelected = YES;
//    }
}

- (void)setSliceDeselectedAtIndex:(NSInteger)index
{
//    if(_selectedSliceOffsetRadius <= 0)
//        return;
//    PGSliceLayer *layer = (PGSliceLayer *)[_pieView.layer.sublayers objectAtIndex:index];
//    if (layer && layer.isSelected)
//    {
//        layer.position = CGPointMake(0, 0);
//        layer.isSelected = NO;
//    }
}

- (void)showDescForLayer:(PGSliceLayer *)pieLayer desc:(NSString *)szDesc
{
    CATextLayer *textLayer = (CATextLayer *)[[pieLayer sublayers] objectAtIndex:0];
    CGSize size = [szDesc sizeWithAttributes:@{NSFontAttributeName:self.yLabelFont}];
    
    [CATransaction setDisableActions:YES];
    if(M_PI*2*_labelRadius*pieLayer.percentage < MAX(size.width,size.height) || pieLayer.value <= 0)
    {
        [textLayer setString:@""];
    }
    else
    {
        [textLayer setString:szDesc];
        [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
    }
    [CATransaction setDisableActions:NO];
}









@end
