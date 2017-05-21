//
//  HYHADController.h
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/20.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHADItem.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width

@interface HYHADController : UIViewController{
}

@property(nonatomic, retain, readwrite) HYHADItem* adData;;

- (void) loadAdData;
@end
