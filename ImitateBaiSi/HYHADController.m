//
//  HYHADController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/20.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHADController.h"
#import <AFNetworking.h>
#import "HYHADItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "HYHTabBarController.h"


#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface HYHADController ()
@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutlet UIButton *skipBtn;
@property (strong, nonatomic) NSTimer* timer;
@end

@implementation HYHADController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"enter ad....");
    [self loadAdData];
    
    [self addGesture];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setSkipButtonText) userInfo:nil repeats:YES];
}

- (void) setSkipButtonText
{
    static int i = 0;
    NSString* str = [NSString stringWithFormat:@"剩余%ds", i];
    
    [self.skipBtn setTitle:str forState:UIControlStateNormal];
    if (0 == i)
    {
        [self enterMainInterface];
        [self.timer invalidate];
    }
//    NSLog(@"setSkipButtonText...%@", str);
    
    i--;
}


- (void) addGesture
{
    /*
     UITapGestureRecognizer
     UIPinchGestureRecognizer
     UIRotationGestureRecognizer
     UISwipeGestureRecognizer
     UIPanGestureRecognizer
     UILongPressGestureRecognizer
     */

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}


- (void) enterMainInterface
{
    [[HYHTabBarController alloc] init];
}

- (IBAction)handleSkip:(id)sender {
    
    [self enterMainInterface];
}

- (void) handleSingleTap
{
    NSLog(@"handleSingleClick...");
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.adData.ori_curl]];
}

#pragma load advertisement data
- (void) loadAdData
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    NSString* url = @"http://mobads.baidu.com/cpro/ui/mads.php";
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    parameters[@"code2"] = code2;
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //请求进度
        NSLog(@"请求正在进行中...");
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        //请求成功
        //NSLog(@"请求成功：%@", responseObject);
       
        [responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/adData.plist" atomically:YES];
    
        NSDictionary* adDict = [responseObject[@"ad"] lastObject];
        
        HYHADItem* adData = [HYHADItem mj_objectWithKeyValues:adDict];
        self.adData = adData;
        
        float adImageH = ScreenW/adData.w* adData.h;
        self.adImageView.frame = CGRectMake(0, 0, ScreenW, adImageH);
        //NSLog(@"%@", adData);
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:adData.w_picurl]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败: %@", error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
