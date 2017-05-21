//
//  HYHFriendshipLoginRegisterController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/9.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHFriendshipLoginRegisterController.h"
#import "HYHLoginRegisterView.h"

@interface HYHFriendshipLoginRegisterController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadCons;

@end

@implementation HYHFriendshipLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUInteger width = _middleView.bounds.size.width * 0.5;
    NSUInteger height = _middleView.bounds.size.height;
    
    //向middleView 添加loginView
    HYHLoginRegisterView* loginView = [HYHLoginRegisterView loginView];
    loginView.frame = CGRectMake(0, 0, width, height);
    [self.middleView addSubview:loginView];
    
    //向middleView 添加registerView
    HYHLoginRegisterView* registerView = [HYHLoginRegisterView registerView];
    registerView.frame = CGRectMake(width, 0, width, height);
    [self.middleView addSubview:registerView];
    
}
- (IBAction)handleClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SwitchLoginRegister:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    //平移中间view
    _leadCons.constant = _leadCons.constant == 0? -self.middleView.bounds.size.width * 0.5:0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
