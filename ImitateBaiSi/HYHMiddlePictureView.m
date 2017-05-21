//
//  HYHMiddlePictureView.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/22.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHMiddlePictureView.h"
#import <UIImageView+WebCache.h>
#import "HYHTopic.h"
#import "HYHSeeBigPictureController.h"

@interface HYHMiddlePictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation HYHMiddlePictureView

- (void)setTopic:(HYHTopic *)topic
{
    _topic = topic;
    
    //设置图片
    self.placeholderView.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            self.placeholderView.hidden = YES;
        
    }];
    
    //gif
    self.gifView.hidden = !topic.is_gif;
    
    
    //点击查看大图
    if (topic.isBigPicture) {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
        //处理超长图片的大小
        if(self.imageView.image){
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            //开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            
            //绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            //关闭上下文
            UIGraphicsEndImageContext();
        }
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
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
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    
}

- (void)seeBigPicture
{
    HYHSeeBigPictureController* bigPicController = [[HYHSeeBigPictureController alloc] init];
    
    bigPicController.topic = self.topic;
    
    //小心注意self.window是个nil
    [self.window.rootViewController presentViewController:bigPicController animated:YES completion:nil];

    //获取window的另一个可靠方法
//    [UIApplication sharedApplication].keyWindow.rootViewController;

}

@end
