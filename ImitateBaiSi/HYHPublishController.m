//
//  HYHPublishController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/19.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHPublishController.h"
#import "UIView+Frame.h"

#define ID @"HYHCellectionViewCell"

@interface HYHPublishController ()
@property (weak, nonatomic) IBOutlet UIButton *publishVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishPictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishWordBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishLinkBtn;
@property (weak, nonatomic) IBOutlet UIView *containPublishView;
@property (weak, nonatomic) IBOutlet UIButton *CacleBtn;

//@property (nonatomic, retain) NSMutableArray* imageBtn;

@end

@implementation HYHPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _imageBtn = (NSMutableArray*)@[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review"];
    
    [self setPublishBtn];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    
    [self.view addGestureRecognizer:tap];
}



-(void) setPublishBtn
{
    //设置按钮图片
    [_publishVideoBtn setBackgroundImage:[UIImage imageNamed:@"publish-video"] forState:UIControlStateNormal];
    [_publishPictureBtn setBackgroundImage:[UIImage imageNamed:@"publish-picture"] forState:UIControlStateNormal];
    [_publishWordBtn setBackgroundImage:[UIImage imageNamed:@"publish-text"] forState:UIControlStateNormal];
    [_publishVoiceBtn setBackgroundImage:[UIImage imageNamed:@"publish-audio"] forState:UIControlStateNormal];
    [_publishLinkBtn setBackgroundImage:[UIImage imageNamed:@"publish-review"] forState:UIControlStateNormal];
    
    //设置cell为圆形
    _publishVideoBtn.layer.cornerRadius = _publishVideoBtn.bounds.size.width / 2;
    _publishPictureBtn.layer.cornerRadius = _publishPictureBtn.bounds.size.width / 2;
    _publishWordBtn.layer.cornerRadius = _publishWordBtn.bounds.size.width / 2;
    _publishVoiceBtn.layer.cornerRadius = _publishVoiceBtn.bounds.size.width / 2;
    _publishLinkBtn.layer.cornerRadius = _publishLinkBtn.bounds.size.width / 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat targetY = [UIScreen mainScreen].bounds.size.height * 0.36;  //0.36 = 240 / 667
    NSInteger num = _containPublishView.subviews.count;
    UIView* publishView;
    
    for(int i = 0; i < num; i++)
    {
        
        publishView = _containPublishView.subviews[i];

        publishView.hyh_y = -125;

        if (i < 5)
        {
            [UIView animateWithDuration:0.8 delay: 0.1 * (5 - i) usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                publishView.hyh_y = targetY + (i / 3) * publishView.bounds.size.height;
            } completion:^(BOOL finished) {
            }];
        }else if (i == 5) {
            [UIView animateWithDuration:0.8 delay: 0.6 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                publishView.hyh_y = 100;
            } completion:^(BOOL finished) {
            }];
        }
    }
}


- (IBAction)handleCancel:(id)sender {

    [self handleTap];
}

- (void) handleTap
{
    _CacleBtn.hidden = YES;
    
    NSInteger num = _containPublishView.subviews.count;
    UIView* view;
    
    for(NSInteger i = 0; i < num; i++)
    {
        view = self.containPublishView.subviews[i];
        
        if (i < 5) {
            [UIView animateWithDuration:0.25 delay:0.03 * (5 - i) options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                view.hyh_y = [UIScreen mainScreen].bounds.size.height;
                
            } completion:nil];
            
        }else if (i == 5)
        {
            [UIView animateWithDuration:0.25 delay:0.03 * 6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                view.hyh_y = [UIScreen mainScreen].bounds.size.height;
                
            } completion:^(BOOL finished) {
                
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
