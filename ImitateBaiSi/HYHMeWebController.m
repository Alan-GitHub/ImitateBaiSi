//
//  HYHMeWebController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/15.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHMeWebController.h"
#import <WebKit/WebKit.h>

@interface HYHMeWebController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation HYHMeWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WKWebView* webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.contentView addSubview:webView];
    
    //展示网页
    NSURLRequest* request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
    
//    [self.view insertSubview:_toolbar atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
