//
//  JKOrderInfoTopCell.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOrderInfoTopCell.h"

@implementation JKOrderInfoTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *addrImgV = [[UIImageView alloc] init];
    addrImgV.image = [UIImage imageNamed:@"ic_order_addr"];
    addrImgV.contentMode = UIViewContentModeCenter;
    [self addSubview:addrImgV];
    [addrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(16), SCALE_SIZE(20)));
    }];
    
    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = @"88888888888";
    phoneLb.textColor = RGBHex(0x333333);
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(14);
    [self addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(addrImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(self);
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.text = @"江苏省无锡市滨湖区建筑西路586号建苑大厦412室";
    addrLb.textColor = RGBHex(0x333333);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(14);
//    addrLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLb.mas_bottom);
        make.left.equalTo(addrImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(self);
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    
    
    
    
    
    
    
    
}

@end
