//
//  HYHTopicController.h
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TopicType) {
    TopicTypeAll     = 1,
    TopicTypeVideo   = 41,
    TopicTypeVoice   = 31,
    TopicTypePicture = 10,
    TopicTypeWord    = 29
};

@interface HYHTopicController : UITableViewController
@property (nonatomic, assign) TopicType topicType;


- (void) headerRefreshAndLoadData;
@end
