//
//  HYHLastestView.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/14.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHLastestView.h"

@implementation HYHLastestView


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 255, 0, 0, 1.0);
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextAddArc(context, 100, 200, 20, 0, 2 * M_PI, 0);
    
    CGContextDrawPath(context, kCGPathStroke);

}

@end
