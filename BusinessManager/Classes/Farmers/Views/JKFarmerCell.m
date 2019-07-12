//
//  JKFarmerCell.m
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFarmerCell.h"
#import "JKFarmerModel.h"

@interface JKFarmerCell ()
@property (nonatomic, strong) JKFarmerModel *model;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addrLb;

@end

@implementation JKFarmerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createUI:(JKFarmerModel *)model {
    UIImageView *headImgV = [[UIImageView alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.farmerPic] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",model.farmerPic] isEqualToString:@"(null)"]) {
        headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    } else {
        headImgV.yy_imageURL = [NSURL URLWithString:model.farmerPic];
    }
    headImgV.layer.cornerRadius = 20;
    headImgV.layer.masksToBounds = YES;
    [self addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    UIButton *callBtn = [[UIButton alloc] init];
    [callBtn setImage:[UIImage imageNamed:@"ic_call"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(callBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];

    [self.nameLb removeFromSuperview];
    UILabel *nameLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.farmerName] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",model.farmerName] isEqualToString:@"(null)"]) {
        nameLb.text = @"";
    } else {
       nameLb.text = model.farmerName;
    }
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(16);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImgV.mas_centerY).offset(-5);
        make.left.equalTo(headImgV.mas_right).offset(10);
        make.right.equalTo(lineLb.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    self.nameLb = nameLb;

    [self.addrLb removeFromSuperview];
    UILabel *addrLb = [[UILabel alloc] init];
    if (model.farmerRegion != nil) {
        addrLb.text = [NSString stringWithFormat:@"%@%@",model.farmerRegion,model.farmerAdd];
    } else {
        addrLb.text = [NSString stringWithFormat:@"%@",model.farmerAdd];
    }
    addrLb.textColor = RGBHex(0x666666);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(14);
    addrLb.numberOfLines = 2;
    [addrLb sizeToFit];
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgV.mas_centerY).offset(-5);
        make.left.equalTo(headImgV.mas_right).offset(10);
        make.right.equalTo(lineLb.mas_left).offset(-10);
        make.height.mas_equalTo(35);
    }];
    self.addrLb = addrLb;

    self.model = model;
}

#pragma mark -- 拨打电话
- (void)callBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(callFarmerPhone:)]) {
        [_delegate callFarmerPhone:self.model];
    }
}


@end
