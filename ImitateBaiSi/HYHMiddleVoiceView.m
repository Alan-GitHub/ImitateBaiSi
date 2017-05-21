//
//  HYHMiddleVoiceView.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/22.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHMiddleVoiceView.h"
#import <UIImageView+WebCache.h>
#import "HYHTopic.h"
#import "CustomMoviePlayerViewController.h"

@interface HYHMiddleVoiceView ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *playCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@end

@implementation HYHMiddleVoiceView

- (void)setTopic:(HYHTopic *)topic
{
    _topic = topic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image2]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
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
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice)]];
}

- (void) playVoice
{
    NSLog(@"playVoice");
    
    
    CustomMoviePlayerViewController* pc = [[CustomMoviePlayerViewController alloc] init];
    
    pc.mediaURL = [NSURL URLWithString: self.topic.voiceuri];
    
    [pc readyPlayer];
    //小心注意self.window是个nil
    [self.window.rootViewController presentViewController:pc animated:YES completion:nil];

}

@end
