//
//  FirstViewController.h
//  DuiTang
//
//  Created by leo on 2017/2/21.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController


@property(nonatomic, strong)NSMutableArray *dataArr;

/**  每日精选 */
@property(nonatomic, strong)UITableView *selectTabView;


@end
