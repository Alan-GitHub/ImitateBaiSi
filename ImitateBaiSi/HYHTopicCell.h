//
//  HYHTopicCell.h
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/21.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHMiddleVideoView.h"
#import "HYHMiddleVoiceView.h"
#import "HYHMiddlePictureView.h"
#import "HYHTopic.h"

@interface HYHTopicCell : UITableViewCell
// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/** 模型数据 */
@property (nonatomic, strong) HYHTopic* topic;


/* 中间控件 */
///** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
//@property (nonatomic, assign) NSInteger type;

/** 视频控件*/
@property (nonatomic, weak) HYHMiddleVideoView* videoView;
/** 声音控件*/
@property (nonatomic, weak) HYHMiddleVoiceView* voiceView;
/** 图片控件*/
@property (nonatomic, weak) HYHMiddlePictureView* pictureView;

@end
