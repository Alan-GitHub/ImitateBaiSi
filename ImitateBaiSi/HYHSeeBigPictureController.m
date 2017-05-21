//
//  HYHSeeBigPictureController.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/4/27.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHSeeBigPictureController.h"
#import "HYHTopic.h"
#import <UIImageView+WebCache.h>
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface HYHSeeBigPictureController ()
@property(nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic, retain) UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (PHAssetCollection*) createCollection;
@end

@implementation HYHSeeBigPictureController

- (void)viewDidLoad {
    [super viewDidLoad];

    //scrollView
    UIScrollView* scrollView = [[UIScrollView alloc] init];
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    scrollView.frame = self.view.bounds;
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBack:)]];
    [self.view insertSubview:scrollView atIndex:0];
    _scrollView = scrollView;
    
    //imageView
    UIImageView* imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
            self.saveButton.enabled = YES;
    } ];
    CGFloat imageW = scrollView.bounds.size.width;
    CGFloat imageH = imageW * self.topic.height / self.topic.width;
    CGFloat originX = 0;
    CGFloat originY = 0;
    if (imageH > ScreenH) {
        scrollView.contentSize = CGSizeMake(0, imageH);
    }else{
//        CGFloat centerY = imageH * 0.5;
        originY = (ScreenH / 2) - (imageH / 2);
    }
    imageView.frame = CGRectMake(originX, originY, imageW, imageH);
    _imageView = imageView;
    
    [scrollView addSubview:imageView];
}


- (IBAction)handleBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleSave:(id)sender {
    //保存图片到［相机胶卷］
    
//    //异步执行
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        if(error){
//            [SVProgressHUD showErrorWithStatus:@"保存失败！"];
//        }else{
//            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//        }
//    }];
    
    //同步执行
    NSError* error = nil;
    __block PHObjectPlaceholder* placeholder = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset;
    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        return;
    }
    
    //获得相册
    PHAssetCollection* createdCollection = self.createCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败！"];
        return;
    }
    
    //添加相片到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest* request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request addAssets:@[placeholder]];
    } error:&error];

    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
    
}

- (PHAssetCollection*) createCollection
{
    //获得软件名字
    NSString* title = [NSBundle mainBundle].infoDictionary[(NSString*)kCFBundleNameKey];
    
    //抓取所有的自定义相册
    PHFetchResult<PHAssetCollection*> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    //查找当前app对应的自定义相册
    for (PHAssetCollection* collection in collections){
        if([collection.localizedTitle isEqualToString:title])
        {
            return collection;
        }
    }
    
    /*** 当前app对应的自定义相册没有被创建过 ****/
    
    NSError* error = nil;
    __block NSString* createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //创建一个［自定义相册］
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败！"];
        return nil;
    }
    
    //根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
