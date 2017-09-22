//
//  HomeViewController.m
//  DuiTang
//
//  Created by leo on 2017/2/20.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import "HomeViewController.h"
#import "Const.h"
#import "HomeModel.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>

//上面的滑动视图
@property(nonatomic, strong)UIScrollView *topScrollView;

//下面的滑动视图
@property(nonatomic, strong)UIScrollView *bottomScrollView;

//移动的红色视图
@property(nonatomic, strong)UIView *moveView;

//标题数组
@property(nonatomic, strong)NSMutableArray<NSString *> *labelNameArr;

@property(nonatomic, strong)NSArray *viewControllerArr;

@end


@implementation HomeViewController{
    
    FirstViewController *_fvc;
    
}


#pragma mark - 懒加载
- (NSMutableArray *)labelNameArr {
    
    if(_labelNameArr == nil){
        
        _labelNameArr = [NSMutableArray array];
    }
    
    return _labelNameArr;
}

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
   
    return _dataArr;
}

- (NSArray *)viewControllerArr {
    
    if (_viewControllerArr == nil) {
        
        _viewControllerArr = [NSArray array];
    }
    return _viewControllerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关闭滑动偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.title = @"首页";
    [self loadDataWithtitle:nil];
    
    [self createTopView];
    
    [self createBottomView];
    
    
}

#pragma mark - 加载数据
-  (void)loadDataWithtitle:(NSString *)titleStr {
    
    //默认加载每日精选
    if (titleStr == nil) {
        
        titleStr = @"SELECTION";
    
    }
    
    NSString *requestStr = [NSString stringWithFormat:@"http://103.21.119.166/napi/index/list/by_cate/?platform_name=iOS&start=0&__domain=www.duitang.com&app_version=6.7.1%%20rv%%3A179265&device_platform=iPhone6%%2C2&cate=%@&locale=zh_CN&app_code=gandalf&platform_version=10.2.1&screen_height=568&device_name=Unknown%%20iPhone&screen_width=320", titleStr];
    
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
               
              
               
                 
                 [self.dataArr addObject:model];
                 
             }
             
              _fvc.dataArr = self.dataArr;
              [_fvc.selectTabView reloadData];
             
   
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


#pragma mark - 创建视图
//上面的视图
- (void)createTopView {
    
    //标题
    self.labelNameArr = @[@"每日精选", @"美容时尚", @"美食手札", @"美图摄影"].mutableCopy;
    
    CGFloat labelW = ScreenW / 4;
    
    //设置标题滑动视图
    _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 40)];
    //滑动范围
    _topScrollView.contentSize = CGSizeMake(ScreenW, 0);
    //不反弹
    _topScrollView.bounces = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;

    
    //标题按钮
    for (int i = 0; i < self.labelNameArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*labelW, 0, labelW, 40)];
        
        [btn setTitle:self.labelNameArr[i] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        //默认选中第一个
        if (i == 0) {
            
            btn.selected = YES;
            
        }
        [_topScrollView addSubview:btn];
        
}
    //移动的横线
    _moveView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollView.frame.size.height - 3, labelW, 3)];
    _moveView.backgroundColor = [UIColor redColor];
    [_topScrollView addSubview:_moveView];
   
    [self.view addSubview:_topScrollView];
     
    
}

//下面的滑动视图
- (void)createBottomView {
    
    /******
     注意在使用scrollRectToVisible这个方法的时候不能将某一个方向的滑动区域设置为0 否者那个方法将失效
     
     *********/
    //内容滑动视图
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topScrollView.frame), ScreenW, ScreenH - CGRectGetHeight(_topScrollView.frame) - 64 - 49)];
    _bottomScrollView.contentSize = CGSizeMake(ScreenW * 4, ScreenH - CGRectGetHeight(_topScrollView.frame) - 64 - 49);
    _bottomScrollView.bounces = NO;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.delegate = self;
    [self.view addSubview: _bottomScrollView];
    
    _fvc = [[FirstViewController alloc] init];
    SecondViewController *svc1 = [[SecondViewController alloc] init];
    SecondViewController *svc2 = [[SecondViewController alloc] init];
    ThirdViewController *tvc = [[ThirdViewController alloc] init];
    self.viewControllerArr = @[_fvc, svc1,  svc2, tvc];
    
   
    //设置子控制器
    for (int i = 0; i < self.viewControllerArr.count; i++) {
        
        UIViewController *vc = self.viewControllerArr[i];
        
        vc.view.frame = CGRectMake(i * ScreenW, 0, ScreenW, CGRectGetHeight(_bottomScrollView.frame));
        vc.view.backgroundColor = [UIColor colorWithDisplayP3Red:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1];
        [_bottomScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
   
    
    
    
    
}

#pragma mark - 响应事件
//标题按钮的响应
- (void)btnAct:(UIButton *)btn {
    
    NSInteger currentPage = btn.tag - 1000;
    
    [_bottomScrollView scrollRectToVisible:CGRectMake(currentPage * ScreenW, 0, ScreenW, ScreenH - CGRectGetHeight(_topScrollView.frame) - 64 - 49) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        _moveView.center = CGPointMake(btn.center.x, _moveView.center.y);
    }];
    for (int i = 0; i < _labelNameArr.count; i++) {
        
        UIButton *button = [_topScrollView viewWithTag:1000 + i];
        button.selected = NO;
        
    }
    btn.selected = !btn.selected;
    
}


#pragma mark - 滑动视图代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //滑动的页面数
    NSInteger page =  scrollView.contentOffset.x / ScreenW;
    
    CGRect rect = _moveView.frame;
    
    rect.origin.x = page * rect.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        _moveView.frame = rect;
    }];
    
    for (int i = 0; i < _labelNameArr.count; i++) {
        
        UIButton *button = [_topScrollView viewWithTag:1000 + i];
        UIButton *currentBtn = [_topScrollView viewWithTag:1000 + page];
        
        if (button == currentBtn) {
            
           currentBtn.selected = YES;
        }else {
            
            button.selected = NO;
        }
        
    }
   
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
  
    
}


@end
