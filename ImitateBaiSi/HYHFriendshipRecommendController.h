//
//  HYHFriendshipRecommendController.h
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYHFriendshipRecommendController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain, readwrite) NSMutableArray* leftArr;
@property(nonatomic, retain, readwrite) NSMutableArray* rightArr;
@end
