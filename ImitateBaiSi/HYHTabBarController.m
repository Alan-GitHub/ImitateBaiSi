//
//  HYHTabBarController.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/13.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHTabBarController.h"
#import "HYHEssenceController.h"
#import "HYHEssenceNavController.h"
#import "HYHLastestController.h"
#import "HYHPublishController.h"
#import "HYHFriendshipController.h"
#import "HYHFriendshipNavController.h"
#import "HYHMeController.h"
#import "HYHMeNavController.h"
#import "HYHTabBar.h"


@interface HYHTabBarController ()

@end

@implementation HYHTabBarController

// 只会调用一次
+ (void)load
{
    // 获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    // 创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置子控制起
    [self setupAllChildViewControllers];
    
    //设置底部按钮标题文字和图片
    [self setupAllTabbarBtn];
    
    //设置底部工具栏
    // 3.自定义tabBar
    [self setupTabBar];
    
    self.tabBarController.selectedViewController = self.childViewControllers[0];
}

#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    HYHTabBar *tabBar = [[HYHTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void) setupAllChildViewControllers
{
    //设置tabbarController的子控制器
    HYHEssenceController* essenceController = [[HYHEssenceController alloc] init];
    HYHEssenceNavController* essNavCon = [[HYHEssenceNavController alloc] initWithRootViewController:essenceController];
//    essNavCon.tabBarItem.title = @"精华";
    
    HYHLastestController* lastestController = [[HYHLastestController alloc] init];
    lastestController.view.backgroundColor = [UIColor greenColor];
//    lastestController.tabBarItem.title = @"最新";
    
//    HYHPublishController* publishController = [[HYHPublishController alloc] init];
//    //    publishController.view.backgroundColor = [UIColor blueColor];
//    publishController.tabBarItem.title = @"发布";
    
    HYHFriendshipController* friendshipController = [[HYHFriendshipController alloc] init];
    HYHFriendshipNavController* friendshipNavController = [[HYHFriendshipNavController alloc] initWithRootViewController:friendshipController];
//    friendshipNavController.tabBarItem.title = @"关注";
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([HYHMeController class]) bundle:nil];
    HYHMeController* meController = [storyboard instantiateInitialViewController];
    HYHMeNavController* meNavController = [[HYHMeNavController alloc] initWithRootViewController:meController];
//    meNavController.tabBarItem.title = @"我";
    
    //添加子控制器到根控制器上
    [self addChildViewController:essNavCon];
    [self addChildViewController:lastestController];
//    [self addChildViewController:publishController];
    [self addChildViewController:friendshipNavController];
    [self addChildViewController:meNavController];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = self;
}

//中间的发布按钮不在这里设置
- (void) setupAllTabbarBtn
{
    // 0:nav
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    // 快速生成一个没有渲染图片
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    
    // 1:新帖
    UIViewController *viewLastest = self.childViewControllers[1];
    viewLastest.tabBarItem.title = @"新帖";
    viewLastest.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    viewLastest.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
    
    // 3.关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
    
    // 4.我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
