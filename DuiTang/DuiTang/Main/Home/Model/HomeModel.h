//
//  HomeModel.h
//  DuiTang
//
//  Created by leo on 2017/2/21.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

//加载更多的数量
@property(nonatomic, strong)NSNumber *next_start;

/** 点击人数和收藏人数*/
@property(nonatomic, strong)NSArray<NSDictionary *> *icon_infos;

/**  用户名 */
@property(nonatomic, copy)NSString *username;

/**  用户头像 */
@property(nonatomic, copy)NSString *avatar;

@property(nonatomic, copy)NSString *title;

@property(nonatomic, copy)NSString *photo_path;

@property(nonatomic, copy)NSString *type;

/**  副标题 */
@property(nonatomic, copy)NSString *cover_desc;





@end
