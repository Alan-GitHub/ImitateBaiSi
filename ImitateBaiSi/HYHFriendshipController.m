//
//  HYHFriendshipController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/19.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHFriendshipController.h"
#import "HYHFriendshipRecommendController.h"
#import "HYHFriendshipLoginSelectController.h"

#define ID @"friendshipCollectionview"

@interface HYHFriendshipController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *friendshipCollectionview;

@end

@implementation HYHFriendshipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关注";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friendsRecommentIcon" ] style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftButton)];
    

    [_friendshipCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
//    _friendshipCollectionview.mini
    
    _friendshipCollectionview.delegate = self;
    _friendshipCollectionview.dataSource = self;
//    _friendshipCollectionview.backgroundColor = [UIColor blackColor];
    
    [self setCollectionViewLayout];
}

- (void)setCollectionViewLayout
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];

    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    
//    [_friendshipCollectionview setCollectionViewLayout:flowLayout];
    [_friendshipCollectionview setCollectionViewLayout:flowLayout animated:YES];
    
}

- (void) handleLeftButton
{
    HYHFriendshipRecommendController* friendshipRecommend = [[HYHFriendshipRecommendController alloc] init];
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
//    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:friendshipRecommend animated:YES];
}

- (IBAction)handleLogin:(id)sender {
    HYHFriendshipLoginSelectController* loginRegister = [[HYHFriendshipLoginSelectController alloc] init];
    
//    [self.navigationController pushViewController:loginRegister animated:YES];

    [self presentViewController:loginRegister animated:YES completion:nil];
}

- (IBAction)handleRegister:(id)sender {
    
    [self handleLogin:sender];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
//    cell.layer.borderColor = [UIColor blueColor].CGColor;
//    cell.layer.borderWidth = 4;
    
    UILabel* label = [[UILabel alloc] init];
    label.text = @"图片";
    [label sizeToFit];
    [cell addSubview:label];

//    cell.alignmentRectInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
