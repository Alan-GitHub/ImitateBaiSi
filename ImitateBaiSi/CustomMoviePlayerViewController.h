//
//  HYHPlayVideoController.h
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface HYHPlayVideoController : UIViewController
//
//@end

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h> //导入视频播放库

@interface CustomMoviePlayerViewController : UIViewController
{
    MPMoviePlayerController *mp;
    UIActivityIndicatorView *loadingAni; //加载动画
    UILabel *label; //加载提醒
}
///** 模型数据 */
//@property (nonatomic, strong) HYHTopic* topic;

@property (nonatomic,retain) NSURL *mediaURL;


//准备播放
- (void)readyPlayer;

@end