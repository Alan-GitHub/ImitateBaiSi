//
//  HYHLastestController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/19.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHLastestController.h"
#import "HYHLastestView.h"


@interface HYHLastestController ()

@end

@implementation HYHLastestController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [self.view addGestureRecognizer:tap];
    
    HYHLastestView* myView = [[HYHLastestView alloc] initWithFrame:self.view.frame];
    myView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:myView];
    
}

//- (void) handlePan
//{
//    NSLog(@"handlePan");
//}

//- (void) handleTap
//{
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
