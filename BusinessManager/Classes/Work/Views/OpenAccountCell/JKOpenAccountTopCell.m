//
//  JKOpenAccountTopCell.m
//  BusinessManager
//
//  Created by  on 2018/6/28.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOpenAccountTopCell.h"

@interface JKOpenAccountTopCell ()
@property (nonatomic, strong) NSString *tel;
@end

@implementation JKOpenAccountTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)createUIwithFarmerInfo:(NSArray *)infoArr {
    UIImageView *headImgV = [[UIImageView alloc] init];
    if ([[NSString stringWithFormat:@"%@",infoArr[0]] isEqualToString:@""]) {
       headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    } else {
        headImgV.yy_imageURL = [NSURL URLWithString:infoArr[0]];
    }
    headImgV.layer.cornerRadius = 20;
    headImgV.layer.masksToBounds = YES;
    [self addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"ic_call"] forState: UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    self.tel = infoArr[3];
    
    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(phoneBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = infoArr[1];
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(16);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(20);
    }];
    
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.text = infoArr[2];
    addrLb.textColor = RGBHex(0x888888);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(15);
//    addrLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(20);
    }];
}

- (void)phoneBtnClick:(UIButton *)btn {
    NSLog(@"拨打电话");
}

@end
