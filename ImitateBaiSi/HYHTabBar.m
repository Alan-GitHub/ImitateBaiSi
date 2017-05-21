//
//  HYHTabBar.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/13.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHTabBar.h"
#import "UIView+Frame.h"
#import "HYHPublishController.h"

@interface HYHTabBar ()

@property (nonatomic, weak) UIButton *plusButton;

/** 上一次点击的按钮 */
@property (nonatomic, weak) UIControl *previousClickedTabBarButton;
@end

@implementation HYHTabBar

- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _plusButton = btn;
    }
    return _plusButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 跳转tabBarButton位置
    NSInteger count = self.items.count;
    
    CGFloat btnW = self.hyh_width / (count + 1);
    CGFloat btnH = self.hyh_height;
    CGFloat x = 0;
    int i = 0;
    // 私有类:打印出来有个类,但是敲出来没有,说明这个类是系统私有类
    // 遍历子控件 调整布局
    for (UIControl *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置previousClickedTabBarButton默认值为最前面的按钮
            if (i == 0 && self.previousClickedTabBarButton == nil) {
                self.previousClickedTabBarButton = tabBarButton;
            }
            
            if (i == 2) {
                i += 1;
            }
            
            x = i * btnW;
            
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH);
            
            i++;
        }
    }
    
    // 调整发布按钮位置
    self.plusButton.center = CGPointMake(self.hyh_width * 0.5, self.hyh_height * 0.5);
    
}

/**
 *  tabBarButton的点击
 */
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    HYHPublishController* publishVC = [[HYHPublishController alloc] init];
    
    UIViewController *topmostVC = [self topViewController];
    
    topmostVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    topmostVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [topmostVC presentViewController:publishVC animated:NO completion:nil];
    
//    [UIApplication sharedApplication].keyWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publishVC animated:NO completion:nil];

}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
