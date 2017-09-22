//
//  BaseViewController.m
//  DuiTang
//
//  Created by leo on 2017/2/20.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    //移除系统自带的tabBarButton
    for (UIView *sub  in self.tabBarController.tabBar.subviews) {

        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {

            [sub  removeFromSuperview];
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
