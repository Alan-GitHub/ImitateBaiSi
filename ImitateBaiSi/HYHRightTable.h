//
//  HYHRightTable.h
//  ImitateBaiSi
//
//  Created by Yang on 2017/4/8.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHRightTable : NSObject

//header,fans_count,screen_name
@property(nonatomic, retain, readwrite) NSString* header;
@property(nonatomic, retain, readwrite) NSString* screen_name;
@property(nonatomic, assign, readwrite) NSUInteger fans_count;

@end
