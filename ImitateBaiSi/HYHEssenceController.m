//
//  HYHEssenceController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/19.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHEssenceController.h"
#import "HYHTopicController.h"
#import "HYHAllController.h"
#import "HYHVideoController.h"
#import "HYHVoiceController.h"
#import "HYHPictureController.h"
#import "HYHWordController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define navBarMaxY 64
#define TITLEVIEWH 40

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface HYHEssenceController ()<UIScrollViewDelegate>
@property(nonatomic, retain,readwrite) UIView* titlesView;
@property(nonatomic, retain,readwrite) UIScrollView* scrollView;
@property(nonatomic, retain,readwrite) UIButton* previousClickedTitleButton;

@property(nonatomic, retain,readwrite) UIView* titleUnderline;


@end

@implementation HYHEssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"精华";
    
    [self setupAllChildVcs];
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    [self handleTitleBtnClick:_titlesView.subviews.firstObject];
    
    //
    HYHTopicController* tc = self.childViewControllers.firstObject;
    [tc headerRefreshAndLoadData];
//
}

- (void) setupAllChildVcs
{
    [self addChildViewController:[[HYHAllController alloc] init]];
    [self addChildViewController:[[HYHVideoController alloc] init]];
    [self addChildViewController:[[HYHVoiceController alloc] init]];
    [self addChildViewController:[[HYHPictureController alloc] init]];
    [self addChildViewController:[[HYHWordController alloc] init]];
}

/*
 scrollView和tableView的内边距：
 1. scrollView在导航控制器中，会自动设置其顶部内边距
    通过控制器的属性automaticallyAdjustsScrollViewInsets 可以控制顶部内边距有还是无
 2. 表cell的显示区域就是tableview的视图区域。
    所以：
    如果要做cell全屏穿透，首先必须使tableview的大小为整个屏幕。然后还需要设置tableview的顶部和底部内边距，防止cell被导航栏或tabbar阻挡
 */

- (void)setupScrollView
{
    NSLog(@"setupScrollView");
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.frame  = self.view.bounds; //CGRectMake(0, 0, 100, 100);
//    scrollView.backgroundColor = [UIColor blueColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    CGFloat scrollViewW = scrollView.bounds.size.width;
//    CGFloat scrollViewH = scrollView.bounds.size.height;
//    
//    
//    for(NSUInteger i = 0; i < 5; i++)
//    {
//        UIView* childVcView = self.childViewControllers[i].view;
//        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
////        childVcView.backgroundColor = randomColor;
//        [scrollView addSubview:childVcView];
//    }
    
    scrollView.contentSize = CGSizeMake(5 * scrollViewW, 0);
}

- (void) setupTitlesView
{
    UIView* titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, navBarMaxY, ScreenW, TITLEVIEWH);
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    
    [self.view addSubview:titlesView];
    _titlesView = titlesView;
    
    //setup title button
    [self setupTitleButtons];
    
    [self setupTitleUnderline];
}

- (void)setupTitleButtons
{
    NSArray* titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    
    for(int i = 0; i < 5; i++)
    {
        UIButton* titleBtn = [[UIButton alloc] init];
        [self.titlesView addSubview:titleBtn];
        
        CGFloat titleBtnW = self.titlesView.bounds.size.width / 5;
        CGFloat titleBtnH = TITLEVIEWH;
        CGFloat titleBtnX = i * titleBtnW;
        titleBtn.frame = CGRectMake(titleBtnX, 0, titleBtnW, titleBtnH);
        
//        titleBtn.backgroundColor = randomColor;
        
        [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(handleTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        
    }
}

- (void) setupTitleUnderline
{
    UIButton* btn = self.titlesView.subviews.firstObject;
    
    UIView* titleUnderline = [[UIView alloc] init];
    
    CGFloat titleUnderlineH = 2;
    CGFloat titleUnderlineW = self.titlesView.bounds.size.width / 5;
    CGFloat titleUnderlineY = self.titlesView.bounds.size.height - titleUnderlineH;
    
    titleUnderline.frame = CGRectMake(0, titleUnderlineY, titleUnderlineW, titleUnderlineH);
    
    titleUnderline.backgroundColor = [btn titleColorForState:UIControlStateSelected];
    
    [self.titlesView addSubview:titleUnderline];
    _titleUnderline = titleUnderline;
//    NSLog(@"%@", btn.titleLabel.text);
}

- (void)handleTitleBtnClick:(UIButton*) titleButton
{
    //直接改变颜色   不好
//    [self.previousClickedTitleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.previousClickedTitleButton = titleButton;
    
    //通过改变按钮状态间接改变颜色
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    
    CGPoint center = _titleUnderline.center;
    CGFloat titleButtonCX = titleButton.center.x;
    center.x = titleButtonCX;
    
    NSUInteger index = [self.titlesView.subviews indexOfObject:titleButton];
    
    [UIView animateWithDuration:0.25 animations:^{
        //处理下划线
        _titleUnderline.center = center;
        
        NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = titleButton.titleLabel.font;
        CGFloat titleUnderlineW = [titleButton.currentTitle sizeWithAttributes:attributes].width;
        
        CGRect rect = _titleUnderline.bounds;
        rect.size.width = titleUnderlineW;
        
        _titleUnderline.bounds = rect;
        
        //按钮联动scrollView
        CGFloat scrollViewW = self.scrollView.bounds.size.width;
        CGFloat offsetX = scrollViewW * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        //懒加载子控制器的view  用到的时候才创建加载
        CGFloat scrollViewW = self.scrollView.bounds.size.width;
        CGFloat scrollViewH = self.scrollView.bounds.size.height;
        
        
        UIView* childVcView = self.childViewControllers[index].view;
        childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, scrollViewH);
        
        if ([childVcView superview] != _scrollView) {
            HYHTopicController* tc = self.childViewControllers[index];
            [tc headerRefreshAndLoadData];
        }
  
        [_scrollView addSubview:childVcView];

    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollViewW = self.scrollView.bounds.size.width;
    NSUInteger index = scrollView.contentOffset.x / scrollViewW;
    UIButton* titleBtn = [self.titlesView.subviews objectAtIndex:index];
    
    [self handleTitleBtnClick:titleBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
