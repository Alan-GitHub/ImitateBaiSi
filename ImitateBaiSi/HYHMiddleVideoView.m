//
//  HYHMiddleVideoView.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/22.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHMiddleVideoView.h"
#import <UIImageView+WebCache.h>
#import "HYHTopic.h"
#import "HYHPlayVideoController.h"
#import "CustomMoviePlayerViewController.h"

@interface HYHMiddleVideoView ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *playCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoTimeLabel;


@end

@implementation HYHMiddleVideoView

- (void)setTopic:(HYHTopic *)topic
{
    _topic = topic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image2]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];

}

+ (instancetype) viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)]];
}

- (void) playVideo
{
    NSLog(@"playVideo");
    
//    HYHPlayVideoController* pv = [[HYHPlayVideoController alloc] init];
//    
//    pv.topic = self.topic;
//    
////    [pv startPlay];
//    //小心注意self.window是个nil
//    [self.window.rootViewController presentViewController:pv animated:YES completion:nil];
    
    
    CustomMoviePlayerViewController* pc = [[CustomMoviePlayerViewController alloc] init];
    
    pc.mediaURL = [NSURL URLWithString: self.topic.videouri];
    [pc readyPlayer];
    //小心注意self.window是个nil
    [self.window.rootViewController presentViewController:pc animated:YES completion:nil];
}

@end
