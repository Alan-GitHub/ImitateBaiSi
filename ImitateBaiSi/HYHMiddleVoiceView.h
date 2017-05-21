//
//  HYHMiddleVoiceView.h
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/22.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYHTopic;
@interface HYHMiddleVoiceView : UIView
/** 模型数据 */
@property (nonatomic, strong) HYHTopic* topic;

+ (instancetype) viewFromXib;
@end
