//
//  FirstTableViewCell.m
//  DuiTang
//
//  Created by leo on 2017/2/21.
//  Copyright © 2017年 LEO. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "Const.h"

@interface FirstTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *clickImage;

@property (weak, nonatomic) IBOutlet UILabel *clickNum;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageV;
@property (weak, nonatomic) IBOutlet UILabel *colloction;
@property (weak, nonatomic) IBOutlet UIImageView *aditionImageV;

@end

@implementation FirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setModel:(HomeModel *)model {
    
    _model = model;
    NSString *imgStr = _model.avatar;
    NSURL *url = [NSURL URLWithString:imgStr];
   [_icon sd_setImageWithURL:url];
    _username.text = _model.username;
    _title.text = _model.title;
    _content.text = _model.cover_desc;
    
    
   [_clickImage sd_setImageWithURL:[NSURL URLWithString:[_model.icon_infos[0] objectForKey:@"icon_url" ]]];
        _clickNum.text = [_model.icon_infos[0] objectForKey:@"icon_info"];
        
   [_collectImageV sd_setImageWithURL:[NSURL URLWithString:[_model.icon_infos[1] objectForKey:@"icon_url" ]]];
        _colloction.text = [_model.icon_infos[1] objectForKey:@"icon_info"];
   
   [_aditionImageV sd_setImageWithURL:[NSURL URLWithString:_model.photo_path]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
