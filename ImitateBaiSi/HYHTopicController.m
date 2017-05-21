//
//  HYHTopicController.m
//  ImitateBaiSi
//
//  Created by Macx on 2017/4/16.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHTopicController.h"
#import <AFNetworking.h>
#import "HYHTopic.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "HYHTopicCell.h"
#import <UIImageView+WebCache.h>
#import "HYHMiddleVideoView.h"
#import "HYHMiddleVoiceView.h"
#import "HYHMiddlePictureView.h"
#import "UIView+Frame.h"


#define HeaderHeight 50
#define FooterHeight 49
#define tableViewContentInsetTop 104
#define tableViewContentInsetBottom 0   //49

#define HYHMargin 10
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height

#define ID @"HYHTopicCell"

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, RefreshState) {
    /** 下拉普通闲置状态 */
    DropDownRefreshStateIdle = 1,
    /** 下拉松开就可以进行刷新的状态 */
    DropDownRefreshStatePulling,
    /** 下拉正在刷新中的状态 */
    DropDownRefreshStateRefreshing,
    
    /** 上拉普通闲置状态 */
    PutUpRefreshStateIdle = 11,
    /** 上拉松开就可以进行刷新的状态 */
    PutUpRefreshStatePulling,
    /** 上拉正在刷新中的状态 */
    PutUpRefreshStateRefreshing
};

@interface HYHTopicController ()
@property(nonatomic, retain, readwrite) UIView* header;
@property(nonatomic, retain, readwrite) UILabel* headerLabel;
@property(nonatomic, retain, readwrite) UIActivityIndicatorView* headerAiv;
@property(nonatomic, retain, readwrite) UIView* footer;
@property(nonatomic, retain, readwrite) UILabel* footerLabel;
@property(nonatomic, retain, readwrite) UIActivityIndicatorView* footerAiv;


//
//@property(nonatomic, assign, readwrite) NSInteger dataCount;
@property(nonatomic, retain, readwrite) NSMutableArray* topics;
/** 上次返回数据的maxtime */
@property (nonatomic, retain) NSString* maxtime;

@property (nonatomic, assign) NSInteger contentOffsetHeaderY;
@property (nonatomic, assign) NSInteger contentOffsetBottomY;

@property (nonatomic, assign) RefreshState dropDownRefreshState;
@property (nonatomic, assign) RefreshState putUpRefreshState;
@end



@implementation HYHTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.dataCount = 8;
    
    //    self.tableView.rowHeight = 200;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYHTopicCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.view.backgroundColor = [UIColor colorWithRed:206 / 256.0 green:206 / 256.0 blue:206 / 256.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(tableViewContentInsetTop, 0, tableViewContentInsetBottom, 0);
    
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TopicType) topicType
{
//    NSLog(@"topicType");
    return _topicType;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYHTopicCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (void) setupRefresh
{
    //广告条
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    
    [self dropDownRefresh];
    
    [self putUpRefresh];
}

- (void) dropDownRefresh
{
    //下拉刷新控件
    UIView* header = [[UIView alloc] init];
    header.frame = CGRectMake(0, -HeaderHeight, self.tableView.bounds.size.width, HeaderHeight);
    self.header = header;
    [self.tableView addSubview:header];
    
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    UIActivityIndicatorView* headerAiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.headerAiv = headerAiv;
    headerAiv.hyh_centerY = headerLabel.center.y;
    headerAiv.hyh_x = 100;
    //    aiv.hidesWhenStopped = NO;
    [header addSubview:headerAiv];
    
    [self setDropDownRefreshStatusInit:header];
}

- (void) setDropDownRefreshStatusInit:(UIView*) refreshView
{
    
    self.dropDownRefreshState = DropDownRefreshStateIdle;
    
    UILabel* label = refreshView.subviews[0];
    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    
    label.backgroundColor = [UIColor greenColor];
    label.text = @"下拉可以刷新...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [aiv stopAnimating];
}

- (void) setDropDownRefreshStatusWillRefresh:(UIView*) refreshView
{
    UILabel* label = refreshView.subviews[0];
    //    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    
    label.backgroundColor = [UIColor darkGrayColor];
    label.text = @"松开开始刷新...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void) setDropDownRefreshStatusRefreshing:(UIView*) refreshView
{
    self.dropDownRefreshState = DropDownRefreshStateRefreshing;
    
    UILabel* label = refreshView.subviews[0];
    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    label.backgroundColor = [UIColor purpleColor];
    label.text = @"正在刷新...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [aiv startAnimating];
}

- (void) putUpRefresh
{
    UIView* footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, FooterHeight);
    self.footer= footer;
    self.tableView.tableFooterView = footer;
    
    UILabel* footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    self.footerLabel = footerLabel;
    [footer addSubview:footerLabel];
    
    UIActivityIndicatorView* footerAiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.footerAiv = footerAiv;
    [footer addSubview:footerAiv];
    footerAiv.hyh_centerY = footerLabel.center.y;
    footerAiv.hyh_x = 100;
    
    
    self.tableView.tableFooterView.hidden = YES;
    
    [self setPutUpRefreshStatusInit:footer];
}

- (void) setPutUpRefreshStatusInit:(UIView*) refreshView
{
    self.putUpRefreshState = PutUpRefreshStateIdle;
    
    UILabel* label = refreshView.subviews[0];
    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    
    label.backgroundColor = [UIColor greenColor];
    label.text = @"上拉加载更多...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [aiv stopAnimating];
}

- (void) setPutUpRefreshStatusWillRefresh:(UIView*) refreshView
{
    UILabel* label = refreshView.subviews[0];
    //    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    
    label.backgroundColor = [UIColor darkGrayColor];
    label.text = @"松开开始加载...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void) setPutUpRefreshStatusRefreshing:(UIView*) refreshView
{
    self.putUpRefreshState = PutUpRefreshStateRefreshing;
    
    UILabel* label = refreshView.subviews[0];
    UIActivityIndicatorView* aiv = refreshView.subviews[1];
    
    label.backgroundColor = [UIColor purpleColor];
    label.text = @"正在加载...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [aiv startAnimating];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYHTopic* topic = self.topics[indexPath.row];
    
    CGFloat cellHeight = 0;
    
    //中间文字的Y值
    cellHeight += 60;
    
    //中间文字高度
    CGSize textMaxSize = CGSizeMake(ScreenWidth - 2 * HYHMargin, MAXFLOAT);
    cellHeight += [topic.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 17]} context:nil].size.height + HYHMargin;
    
    //中间内容
    if(topic.type != TopicTypeWord){ //中间有内容（视频、声音、图片）
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * topic.height / topic.width;
        
        if(middleH >= ScreenHeight) //显示的图片超过一个屏幕的高度，就认为是长图
        {
            middleH = 200;
            topic.bigPicture = YES;
        }
        
        CGFloat middleX = HYHMargin;
        CGFloat middleY = cellHeight;
        topic.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        cellHeight += middleH + HYHMargin;
    }
    
    //最热评论
    if(topic.top_cmt.count) { //有最热评论
        //标题
        cellHeight += 21;
        
        //内容
        NSDictionary* Cmt = topic.top_cmt.firstObject;
        NSString* content = Cmt[@"content"];
        if(content.length == 0) //语音评论
        {
            content = @"语音评论";
        }
        NSString* username = Cmt[@"user"][@"username"];
        NSString* cmtText = [NSString stringWithFormat:@"%@:%@", username, content];
        
        cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 17]} context:nil].size.height + HYHMargin;
    }
    
    //底部工具条高度
    cellHeight += 36 + HYHMargin;
    
    return cellHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //处理header
    [self dealHeader];
    
    //处理footer
    [self dealFooter];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.tableView.contentOffset.y <= self.contentOffsetHeaderY)
    {
        [self headerRefreshAndLoadData];
    }
    
    
    if(self.tableView.contentOffset.y >= self.contentOffsetBottomY)
    {
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.bottom = FooterHeight;
            self.tableView.contentInset = inset;
            
            [self setPutUpRefreshStatusRefreshing:self.footer];
        }];
        
        [self loadMoreTopics];
    }
}


- (void) dealHeader
{
    self.contentOffsetHeaderY = - (tableViewContentInsetTop + HeaderHeight);
    
    if(self.tableView.contentOffset.y <= self.contentOffsetHeaderY)
    {
        if (self.dropDownRefreshState != DropDownRefreshStateRefreshing) {
            [self setDropDownRefreshStatusWillRefresh:self.header];
        }
    }
    else
    {
        [self setDropDownRefreshStatusInit:self.header];
    }
}

- (void) headerRefreshAndLoadData
{
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top = tableViewContentInsetTop + HeaderHeight;
        self.tableView.contentInset = inset;
        
        [self setDropDownRefreshStatusRefreshing:self.header];
    }];
    
    //发送请求给服务器
    [self loadNewTopics];
}

- (void) loadNewTopics
{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = [NSNumber numberWithInteger:self.topicType];  //这里发送@1也是可行的
    
    NSString* url = @"http://api.budejie.com/api/api_open.php";
    
    [mgr GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"精华帖子获取成功...");
        
        [self.headerAiv stopAnimating];
        self.headerLabel.text = @"数据加载完成！";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top = tableViewContentInsetTop;
            self.tableView.contentInset = inset;
        });
        
        //NSLog(@"%@", responseObject);
        //[responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/topics.plist" atomically:YES];
        
        //保存本次maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //字典数组-->模型数组
        self.topics = [HYHTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"精华帖子获取失败...");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top = tableViewContentInsetTop;
            self.tableView.contentInset = inset;
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        });
    }];
}


//table 底部间距为0  脚表设置为标签栏的高度   正常情况下不显示。  可看作是高度等于标签栏的底部间距
- (void) dealFooter
{
    if(self.tableView.contentSize.height == 0) return;
    
    if((self.tableView.contentSize.height - self.tableView.tableFooterView.bounds.size.height)
       < (self.tableView.bounds.size.height - tableViewContentInsetTop - FooterHeight))
    {
        self.tableView.tableFooterView.hidden = YES;
        
        return;
    }
    
    self.tableView.tableFooterView.hidden = NO;
    
    self.contentOffsetBottomY = self.tableView.contentSize.height - self.tableView.bounds.size.height + FooterHeight;
    
    if(self.tableView.contentOffset.y >= self.contentOffsetBottomY)
    {
        if(self.putUpRefreshState != PutUpRefreshStateRefreshing)
            [self setPutUpRefreshStatusWillRefresh:self.footer];
    }
    else
    {
        [self setPutUpRefreshStatusInit:self.footer];
    }
}



- (void) loadMoreTopics
{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"maxtime"] = self.maxtime;
    parameters[@"type"] = [NSNumber numberWithInteger:self.topicType];  //这里发送@1也是可行的
    
    NSString* url = @"http://api.budejie.com/api/api_open.php";
    
    [mgr GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSLog(@"精华帖子获取成功...");
        
        self.footerLabel.text = @"数据加载完成！";
        [self.footerAiv stopAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                UIEdgeInsets inset = self.tableView.contentInset;
                inset.bottom = tableViewContentInsetBottom;
                self.tableView.contentInset = inset;
                
                //                [self.tableView reloadData];
            }];
            
        });
        
        //NSLog(@"%@", responseObject);
        //[responseObject writeToFile:@"/Users/Macx/Desktop/贺艳辉/ImitateBaiSi/topics.plist" atomically:YES];
        
        //保存本次maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //字典数组-->模型数组
        [self.topics addObjectsFromArray:[HYHTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                UIEdgeInsets inset = self.tableView.contentInset;
                inset.bottom = tableViewContentInsetBottom;
                self.tableView.contentInset = inset;
                
                [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
            }];
            
        });
        
    }];
}

@end
