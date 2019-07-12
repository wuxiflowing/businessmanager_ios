//
//  JKMaintainInfoTopCell.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainInfoTopCell.h"

@implementation JKMaintainInfoTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createUI];
    }
    return self;
}


- (void)createUI {
    UIImageView *headImgV = [[UIImageView alloc] init];
    headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    [self addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCALE_SIZE(10));
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(40), SCALE_SIZE(40)));
    }];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"ic_call"] forState: UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(SCALE_SIZE(60));
    }];
    
    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(phoneBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, SCALE_SIZE(30)));
    }];
    
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = @"大狗子";
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(16);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.text = @"无锡市滨湖区建筑西路589号建苑大厦4楼";
    addrLb.textColor = RGBHex(0x888888);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(15);
//    addrLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
}

- (void)phoneBtnClick:(UIButton *)btn {
    NSLog(@"拨打电话");
}
@end
