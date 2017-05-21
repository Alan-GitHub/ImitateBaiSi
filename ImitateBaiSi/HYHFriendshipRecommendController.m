//
//  HYHFriendshipRecommendController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHFriendshipRecommendController.h"
#import <AFNetworking.h>
#import "HYHRecommendLeft.h"
#import <MJExtension.h>
#import "HYHRightTable.h"
#import "HYHRightTableCell.h"
#import <UIImageView+WebCache.h>

#define leftTableWidth  [UIScreen mainScreen].bounds.size.width * 0.25
#define rightTableWidth [UIScreen mainScreen].bounds.size.width * 0.75
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define rightTableID @"rightTableID"
#define leftTableID @"leftTableID"

@interface HYHFriendshipRecommendController ()
@property (strong, nonatomic) IBOutlet UITableView *leftTable;
@property (strong, nonatomic) IBOutlet UITableView *rightTable;

@end

@implementation HYHFriendshipRecommendController

- (NSMutableArray *)leftArr
{
    if (_leftArr == nil)
    {
        _leftArr = [NSMutableArray array];
    }
    return _leftArr;
}

- (NSMutableArray *)rightArr
{
    if (_rightArr == nil)
    {
        _rightArr = [NSMutableArray array];
    }
    return _rightArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐关注";
    
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    
    //注册rightTableCell
    [self.rightTable registerNib:[UINib nibWithNibName:@"HYHRightTableCell" bundle:nil] forCellReuseIdentifier:rightTableID];
//    [self.rightTable registerClass:[HYHRightTableCell class] forCellReuseIdentifier:rightTableID];
    
    [self loadLeftData];
    [self loadRightDefaultData];
    
    
    //从plist文件中加载数据
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"plist"];
//    NSLog(@"viewDidLoad path=%@", path);
//    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"viewDidLoad dict=%@", dict);
//    NSArray* dictArray = [dict valueForKey:@"list"];
//    NSLog(@"viewDidLoad dictArray=%@", dictArray);
//    [self dealIdentifier:dictArray];
    
}

- (void) adjustSize
{
    CGRect leftTableSize = CGRectMake(0, 0, leftTableWidth, screenHeight);
    CGRect rightTableSize = CGRectMake(leftTableWidth + 1, 0, rightTableWidth, screenHeight);
    
    UIEdgeInsets inset = self.rightTable.contentInset;
    inset.top = 69;
    inset.bottom = 49;
    self.rightTable.contentInset = inset;
    
    
    self.leftTable.frame = leftTableSize;
    self.rightTable.frame = rightTableSize;
    
}

- (void)viewDidLayoutSubviews
{
    [self adjustSize];
}

- (void) loadRightDefaultData
{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"friend_recommend";
    parameters[@"c"] = @"user";
    
    NSString* url = @"http://api.budejie.com/api/api_open.php";
    [mgr GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"正在获取推荐标签右侧列表...");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"已经成功获取右侧默认数据");
        
//        NSLog(@"%@", responseObject);
//        [responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/rightTableDefaultData.plist" atomically:YES];
        NSArray* arr = [responseObject valueForKey:@"top_list"];
//        NSLog(@"arr = %@", arr);
        
        _rightArr = [HYHRightTable mj_objectArrayWithKeyValuesArray:arr];
        
//        for(HYHRightTable* bb in _rightArr)
//            NSLog(@"name=%@, ", bb.screen_name);
        
        [self.rightTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败获取推荐标签右侧列表...");
    }];
    
    
}

- (void) loadLeftData
{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    
    NSString* url = @"http://api.budejie.com/api/api_open.php";
    [mgr GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"正在获取推荐标签左侧列表...");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"已经成功获取推荐标签左侧列表...");
//        [responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/recommendLeft.plist" atomically:YES];
        
        NSArray* dictArray = [responseObject valueForKey:@"list"];
        
        //将字典数组中我们感兴趣的数据解析到数组leftArr中
        [self jsonToModel:dictArray];
        
        //因为plist文件的字典数组中有key为id，不能再模型中定义该变量名。如该方法不太好用
        //self.leftArr = [HYHRecommendLeft mj_objectArrayWithKeyValuesArray:dictArray];
        
        //主线程刷新，
        [self.leftTable reloadData];

//        for(HYHRecommendLeft* instance in self.leftArr)
//            NSLog(@"before %ld, %@", instance.identifier, instance.name);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败获取推荐标签左侧列表...");
    }];
}

//将字典数组中我们感兴趣的数据解析到数组leftArr中
- (void) jsonToModel:(NSArray*) dictArray
{
    NSUInteger i;
    NSDictionary* dict;
    for(i = 0; i < dictArray.count; i++)
    {
        dict = [dictArray objectAtIndex:i];
        HYHRecommendLeft* element = [[HYHRecommendLeft alloc] init];
        
        element.name = [dict valueForKey:@"name"];
        element.identifier = [[dict valueForKey:@"id"] unsignedIntegerValue];
        
        [self.leftArr addObject:element];
//        NSLog(@"name=%@, identifier=%ld", element.name, element.identifier);
    }
    
//    for(HYHRecommendLeft* instance in self.leftArr)
//    {
//        NSLog(@"mm %ld, %@", instance.identifier, instance.name);
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _rightTable)
        return 66;
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _leftTable)
        return 1;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _leftTable)
    {
        return [_leftArr count];
    }
    else
    {
        return [_rightArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTable)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:leftTableID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftTableID];
        }
        
        NSInteger row = [indexPath row];
        HYHRecommendLeft* rd = (HYHRecommendLeft*)[_leftArr objectAtIndex:row];
        cell.textLabel.text = rd.name;
        
        return cell;
    }
    
    else //(tableView == _rightTable)
    {
        HYHRightTableCell* cell = [tableView dequeueReusableCellWithIdentifier:rightTableID];
        if(cell == nil)
        {
            cell = [[HYHRightTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightTableID];
        }
        
        NSInteger row = [indexPath row];

        HYHRightTable* rt = (HYHRightTable*)[_rightArr objectAtIndex:row];
        
        cell.headerIcon.layer.cornerRadius = 23;
        cell.headerIcon.layer.masksToBounds = YES;
        [cell.headerIcon sd_setImageWithURL:[NSURL URLWithString:rt.header]];
        
        cell.nameLabel.text = rt.screen_name;
        [cell.nameLabel sizeToFit];
        
        NSString* fans = [NSString stringWithFormat:@"%ld人关注", rt.fans_count];
        cell.numberLabel.text = fans;
        [cell.numberLabel sizeToFit];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTable)
    {
        NSInteger row = [indexPath row];
        HYHRecommendLeft* rd = (HYHRecommendLeft*)[self.leftArr objectAtIndex:row];
        
        [self loadRightTable:rd.identifier];

    }
    else
        NSLog(@"bbb");
    
}

- (void) loadRightTable:(NSUInteger) identifier
{
//    NSLog(@"loadRightTable: %ld", identifier);
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = [NSNumber numberWithUnsignedInteger:identifier];
    
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"正在获取rightTable数据");
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"已经成功获取rightTable数据");

//        NSLog(@"%@", responseObject);
//        [responseObject writeToFile:@"/Users/yang/Desktop/ImitateBaiSi/rightTable.plist" atomically:YES];
        NSArray* arr = [responseObject valueForKey:@"list"];
//        NSLog(@"arr = %@", arr);
        
        _rightArr = [HYHRightTable mj_objectArrayWithKeyValuesArray:arr];
        [self.rightTable reloadData];
//        for(HYHRightTable* bb in _rightArr)
//            NSLog(@"name=%@, ", bb.screen_name);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败获取rightTable数据");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
