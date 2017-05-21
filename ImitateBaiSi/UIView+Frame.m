//
//  UIView+Frame.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/1.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat) hyh_x
{
    return self.frame.origin.x;
}

- (void) setHyh_x:(CGFloat)hyh_x
{
    CGRect rect = self.frame;
    rect.origin.x = hyh_x;
    
    self.frame = rect;
}

- (CGFloat) hyh_y
{
    return self.frame.origin.y;
}

- (void) setHyh_y:(CGFloat)hyh_y
{
    CGRect rect = self.frame;
    rect.origin.y = hyh_y;
    
    self.frame = rect;
}

- (CGFloat) hyh_centerX
{
    return self.center.x;
}

- (void) setHyh_centerX:(CGFloat)hyh_centerX
{
    CGPoint center = self.center;
    center.x = hyh_centerX;
    
    self.center = center;
}

- (CGFloat) hyh_centerY
{
    return self.center.y;
}

- (void) setHyh_centerY:(CGFloat)hyh_centerY
{
    CGPoint center = self.center;
    center.y = hyh_centerY;
    
    self.center=  center;
}

- (CGFloat) hyh_width
{
    return self.frame.size.width;
}

- (void) setHyh_width:(CGFloat)hyh_width
{
    CGRect rect = self.frame;
    rect.size.width = hyh_width;
    
    self.frame = rect;
}

- (CGFloat) hyh_height
{
    return self.frame.size.height;
}

- (void) setHyh_height:(CGFloat)hyh_height
{
    CGRect rect = self.frame;
    rect.size.height = hyh_height;
    
    self.frame = rect;
}


@end
