//
//  HYHADItem.h
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/25.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <Foundation/Foundation.h>
//ori_curl w_picurl w h
@interface HYHADItem : NSObject
@property(nonatomic, copy, readwrite) NSString* w_picurl;
@property(nonatomic, copy, readwrite) NSString* ori_curl;
@property(nonatomic, assign, readwrite) double w;
@property(nonatomic, assign, readwrite) double h;

@end
