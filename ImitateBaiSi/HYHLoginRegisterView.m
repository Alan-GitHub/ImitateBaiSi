//
//  HYHLoginRegisterView.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/11.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHLoginRegisterView.h"

@interface HYHLoginRegisterView ()
@property (strong, nonatomic) IBOutlet UIButton *loginRegisterBtn;

@end

@implementation HYHLoginRegisterView

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    UIImage* image = _loginRegisterBtn.currentBackgroundImage;
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5  topCapHeight:image.size.height * 0.5];
    
    [_loginRegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
