//
//  HYHFriendshipLoginSelectController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/10.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHFriendshipLoginSelectController.h"
#import "HYHFriendshipLoginRegisterController.h"

@interface HYHFriendshipLoginSelectController ()

@end

@implementation HYHFriendshipLoginSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)handleCancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleOtherLogin:(id)sender {

    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"手机号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HYHFriendshipLoginRegisterController* loginRegister = [[HYHFriendshipLoginRegisterController alloc] init];
        
        /* 四种动画效果
        UIModalTransitionStyleCoverVertical=0, //默认方式，竖向上推
        
        UIModalTransitionStyleFlipHorizontal, //水平反转
        
        UIModalTransitionStyleCrossDissolve,//隐出隐现
        
        UIModalTransitionStylePartialCurl,//部分翻页效果
         */
        loginRegister.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:loginRegister animated:YES completion:nil];
        
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"新浪微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理代码
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"腾讯微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理代码
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
