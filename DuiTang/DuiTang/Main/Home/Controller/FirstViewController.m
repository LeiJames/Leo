//
//  FirstViewController.m
//  DuiTang
//
//  Created by leo on 2017/2/21.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "HomeModel.h"
#import "Const.h"

static  NSString *cellID = @"FirstID";

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, strong)NSMutableArray *moreData;




@end

@implementation FirstViewController

- (NSMutableArray *)moreData {
    
    if (_moreData == nil) {
        
        _moreData = [NSMutableArray array];
    }
    
    return _moreData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self prepareUI];
    
  
  
    
}
#pragma mark - 准备UI
- (void)prepareUI {
    
    _selectTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _selectTabView.delegate = self;
    _selectTabView.dataSource = self;
    _selectTabView.rowHeight = 180;
    _selectTabView.contentInset = UIEdgeInsetsMake(0, 0, 155, 0);
    //注册cell
    [_selectTabView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:_selectTabView];
    //上拉刷新
    _selectTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData:[@(0) integerValue]];
        [_selectTabView.mj_header endRefreshing];
        
    }];
    
    
    
    //下拉加载更多
    _selectTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        __weak  FirstViewController *weakSelf = self;
        HomeModel *model = weakSelf.dataArr[0];
        
        [weakSelf loadData:[model.next_start integerValue]];
        
        [_selectTabView.mj_footer endRefreshing];
    }];
    
    
  
}

#pragma mark - 代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    
    HomeModel *model = self.dataArr[indexPath.row];
    
  
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    
    
    return cell;

    
    
    
    
}

#pragma mark - 上下拉刷新加载数据

- (void)loadData:(NSInteger)startNum{
    
   NSString *requestStr = [NSString stringWithFormat:@"http://103.21.119.166/napi/index/list/by_cate/?platform_name=iOS&start=%ld&__domain=www.duitang.com&app_version=6.7.1%%20rv%%3A179265&device_platform=iPhone6%%2C2&cate=SELECTION&locale=zh_CN&app_code=gandalf&platform_version=10.2.1&screen_height=568&device_name=Unknown%%20iPhone&screen_width=320", startNum];
    //请求数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:requestStr
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //返回的json数据的回调
             NSDictionary *dataDic = responseObject[@"data"];
             NSArray *objcArr = dataDic[@"object_list"];
             
             for (NSDictionary *modelDic in objcArr) {
                 
                 HomeModel *model = [[HomeModel alloc] init];
                 model.next_start = dataDic[@"next_start"];
                 [model setValuesForKeysWithDictionary:modelDic];
                 
                 if ([model.type isEqualToString:@"STORE"] || [model.type isEqualToString:@"ALBUM"]) {
                     
                     continue;
                 }
                 [model setValuesForKeysWithDictionary:modelDic[@"entity"]];
                 [model setValuesForKeysWithDictionary:[modelDic[@"entity"] objectForKey:@"sender"]];
                 [model setValuesForKeysWithDictionary:[modelDic[@"entity"] objectForKey:@"cover"]];
                 
                 
                 
                 
                 [self.moreData addObject:model];
                 
             }
            
             if (startNum == 0) {
                 
                 self.dataArr = self.moreData;
             }else {
                 
                 [self.dataArr addObjectsFromArray:self.moreData];
             }
             
             
          [self.selectTabView reloadData];
            
             
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    
    
    
    
}


@end
