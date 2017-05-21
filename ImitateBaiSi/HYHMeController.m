//
//  HYHMeController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/3/19.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHMeController.h"
#import "HYHSquareCell.h"
#import "HYHFriendshipLoginSelectController.h"
#import <AFNetworking.h>
#import "HYHMeSquare.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "HYHMeWebController.h"

#define ID @"collectionViewCell"

static CGFloat margin = 1;
static NSInteger cols = 4;
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define itemWH (ScreenW - (cols - 1) * margin) / cols



@interface HYHMeController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property(nonatomic, retain, readwrite) UICollectionView* collectionView;
@property(nonatomic, retain, readwrite) NSMutableArray* arr;

@end

@implementation HYHMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";
    
    [self setupTableFootView];

    [self loadData];
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}

- (void) loadData
{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    NSString* url = @"http://api.budejie.com/api/api_open.php";
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [mgr GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"正在获取我板块内容");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"成功获取我板块内容");
//        NSLog(@"%@", responseObject);
//        [responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/me.plist" atomically:YES];
        
        NSArray* array = [responseObject valueForKey:@"square_list"];
        
        _arr = [HYHMeSquare mj_objectArrayWithKeyValuesArray:array];
        
        [self dealExtraGrid];
        
        NSInteger count = self.arr.count;
        NSInteger rows = (count - 1) / cols + 1;
        CGRect rect = _collectionView.frame;
        rect.size.height = rows * itemWH + (rows - 1) * margin;
        _collectionView.frame = rect;
        
        //重新给tableview赋值，系统自动计算tableview的展示区域。 不然collectionView的滚动区域不够
        self.tableView.tableFooterView = _collectionView;
        
        //刷新很有必要
        [_collectionView reloadData];
        
//        for(HYHMeSquare* me in _arr)
//            NSLog(@"%@", me.name);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败获取我板块内容");
        
    }];
    
}

- (void) dealExtraGrid
{
    NSInteger count = self.arr.count;
    NSInteger extra = count % cols;
    if(extra)
    {
        extra = cols - extra;
        for(NSInteger i = 0; i < extra; i++)
        {
            HYHMeSquare* square = [[HYHMeSquare alloc] init];
            [self.arr addObject:square];
        }
    }
}

- (void) setupTableFootView
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];

    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    
    _collectionView = collectionView;
//    collectionView.backgroundColor = [UIColor greenColor];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    
    self.tableView.tableFooterView = collectionView;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HYHSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    NSLog(@"1111");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"2222");
    return _arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"0000");
    HYHSquareCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    cell.backgroundColor = [UIColor whiteColor];
    HYHMeSquare* square = (HYHMeSquare*)[_arr objectAtIndex:row];
//    NSLog(@"square.name=%@",square.name);
    cell.nameLabel.text = square.name;
    [cell.headerIcon sd_setImageWithURL:[NSURL URLWithString:square.icon] completed:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if(!section && !row)
    {
        //点击登录注册cell  跳转
        HYHFriendshipLoginSelectController* loginSelect = [[HYHFriendshipLoginSelectController alloc] init];
        
        [self presentViewController:loginSelect animated:YES completion:nil];
    }
//    NSLog(@"%ld %ld", sec, row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    HYHMeSquare* square = (HYHMeSquare*)[_arr objectAtIndex:row];
    if(![square.url containsString:@"http"]) return;
    NSLog(@"url=%@", square.url);
    
    self.hidesBottomBarWhenPushed = YES;
    
    HYHMeWebController* meWebController = [[HYHMeWebController alloc] init];
    meWebController.url = [NSURL URLWithString:square.url];
    [self.navigationController pushViewController:meWebController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
//    [self presentViewController:meWebController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
