//
//  BaseTabBarController.m
//  DuiTang
//
//  Created by leo on 2017/2/20.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "FindViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "ShopViewController.h"
#import "Const.h"


@interface BaseTabBarController ()

/** 选中的图片 */
@property(nonatomic, strong)NSArray *selectedImageArr;

/** 正常状态的图片 */
@property(nonatomic, strong)NSArray *normalImageArr;

//按钮名称
@property(nonatomic, strong)UILabel *lab;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建子控制器
    [self prepareUI];
    
 
    
}

#pragma mark - 准备UI
- (void)prepareUI{
    
    NSArray *arr = [self createViewControllers];
    
    //存放导航栏的数组
    NSMutableArray *naviArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        BaseNavigationController *baseNavi = [[BaseNavigationController alloc]initWithRootViewController:arr[i]];
        [naviArr addObject:baseNavi];
        
        
    }
    self.viewControllers = naviArr;
    
    [self addTabBarButton];
    
    
}
//添加标签按钮
- (void)addTabBarButton {
    
    //正常状态的图片
    _normalImageArr = @[@"tab_icon_home~iphone",
                                @"tab_icon_explore~iphone",
                                @"tab_icon_store~iphone",
                                @"tab_icon_me~iphone"];
    //点击后的图片
   _selectedImageArr = @[@"tab_icon_home_highlight~iphone",
                                @"tab_icon_explore_highlight~iphone",
                                @"tab_icon_store_highlight~iphone",
                                @"tab_icon_me_highlight~iphone"];
    
    NSArray *nameArr = @[@"首页", @"发现", @"商店", @"我的"];
    
    CGFloat btnW = ScreenW / _normalImageArr.count;
    
    for (NSInteger i = 0; i < _normalImageArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, 5, btnW, 30);
        [btn setImage:[UIImage imageNamed:_normalImageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_selectedImageArr[i]] forState:UIControlStateSelected];
        //设置图片的上，左，下，右的边距
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (btnW - 30)/2, 0, (btnW - 30)/2)];
        btn.tag = 2017 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
        
        
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame)+2, btn.frame.size.width, 10)];
        _lab.text = nameArr[i];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.tag = 3000 + i;
        _lab.font = [UIFont systemFontOfSize:13];
        _lab.textColor = [UIColor lightGrayColor];
        [self.tabBar addSubview:_lab];
        
        if (i == 0) {
            
            btn.selected = YES;
            _lab.textColor = [UIColor redColor];
            
        }
        
        
    }
    
    
   
    
}

//存放每个页面的控制器
- (NSArray *)createViewControllers{
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    FindViewController *findVC = [[FindViewController alloc] init];
 
    ShopViewController *shopVC = [[ShopViewController alloc] init];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    
  return @[homeVC, findVC, shopVC, mineVC];
    
    
}


#pragma mark - 点击事件
-(void)btnAction:(UIButton *)btn {
  
    self.selectedIndex = btn.tag - 2017;
 
    //点击button换图片
    for (int i = 0; i < _normalImageArr.count; i++) {
        
        UIButton *button = [self.tabBar viewWithTag:2017 + i];
        button.selected = NO;
    }
    
    //换label文字颜色
    for (int i = 0; i < _normalImageArr.count; i++) {
        
        //当前点击状态下的label
        _lab = [self.tabBar viewWithTag:btn.tag - 2017 + 3000];
        
        //遍历下面所有的Label
        UILabel *label = [self.tabBar viewWithTag:3000 + i];
        
        if (_lab == label) {
            
            label.textColor = [UIColor redColor];
        
        }else {
            
            label.textColor = [UIColor lightGrayColor];
        }
     
    }
      btn.selected = !btn.selected;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    
    
    
    
    
}



@end
