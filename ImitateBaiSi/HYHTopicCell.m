//
//  HYHTopicCell.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/21.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHTopicCell.h"
#import <UIImageView+WebCache.h>

#define HYHMargin 10

#define TopicTypeVideo   41
#define TopicTypeVoice   31
#define TopicTypePicture 10
#define TopicTypeWord    29

@interface HYHTopicCell ()


@end

@implementation HYHTopicCell

- (HYHMiddleVideoView *) videoView
{
    if(!_videoView)
    {
        HYHMiddleVideoView* videoView = [HYHMiddleVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (HYHMiddleVoiceView *) voiceView
{
    if(!_voiceView)
    {
        HYHMiddleVoiceView* voiceView = [HYHMiddleVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (HYHMiddlePictureView *) pictureView
{
    if(!_pictureView)
    {
        HYHMiddlePictureView* pictureView = [HYHMiddlePictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= HYHMargin;
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if(self.topic.type == TopicTypeVideo){ //视频
        self.videoView.frame = self.topic.middleFrame;
//        NSLog(@"layout=%@", NSStringFromCGRect(self.topic.middleFrame));
    }else if(self.topic.type == TopicTypeVoice){ //声音
        self.voiceView.frame = self.topic.middleFrame;
    }else if(self.topic.type == TopicTypePicture){ //图片
        self.pictureView.frame = self.topic.middleFrame;
    }
}

- (void)setTopic:(HYHTopic *)topic
{
    _topic = topic;
    
    //设置cell数据
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //设置圆形头像
        //1. 开启图形上下文
        //比例因素，当前点与像素比例
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        //2. 描述裁剪区域
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        //3. 设置裁剪区域
        [path addClip];
        
        //4. 画图片
        [image drawAtPoint:CGPointZero];
        
        //5. 取出图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        //6. 关闭上下文
        UIGraphicsEndImageContext();
        
        self.profileImageView.image = image;
    }];
    
    //    cell.dingButton.titleLabel.text = [NSString stringWithFormat:@"%ld", topic.ding];
    [self.dingButton setTitle:[NSString stringWithFormat:@"%zd", topic.ding] forState:UIControlStateNormal];
    [self.caiButton setTitle:[NSString stringWithFormat:@"%zd", topic.cai] forState:UIControlStateNormal];
    [self.repostButton setTitle:[NSString stringWithFormat:@"%zd", topic.repost] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", topic.comment] forState:UIControlStateNormal];
    
    //中间的内容
//    self.middleFrame = topic.middleFrame;
    if(topic.type == TopicTypeVideo){ //视频
        //[cell addSubview:cell.videoView];
        
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        self.videoView.topic = topic;
    }else if(topic.type == TopicTypeVoice){ //声音
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        self.voiceView.topic = topic;
    }else if(topic.type == TopicTypePicture){ //图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
    }else if(topic.type == TopicTypeWord){ //段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
 
    //最热评论
    if(topic.top_cmt.count) { //有最热评论
        self.topCmtView.hidden = NO;
        NSDictionary* Cmt = topic.top_cmt.firstObject;
        NSString* content = Cmt[@"content"];
        if(content.length == 0) //语音评论
        {
            content = @"语音评论";
        }
        NSString* username = Cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@:%@", username, content];
    }
    else {//没有最热评论
        self.topCmtView.hidden = YES;
    }
}

@end
