//
//  HYHPlayVideoController.h
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYHTopic;
@interface HYHPlayVideoController : UIViewController
/** 模型数据 */
@property (nonatomic, strong) HYHTopic* topic;

- (void) startPlay;
@end
