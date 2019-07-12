//
//  JKContractCell.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractCell.h"

@implementation JKContractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCALE_SIZE(10));
        make.left.right.bottom.equalTo(self);
    }];
    
    UIView *midView = [[UIView alloc] init];
    midView.backgroundColor = kWhiteColor;
    [bgView addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(SCALE_SIZE(80));
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = kBgColor;
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(midView.mas_top);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = kBgColor;
    [bgView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *contractNoLb = [[UILabel alloc] init];
    contractNoLb.text = @"合同ID：";
    contractNoLb.textColor = RGBHex(0x333333);
    contractNoLb.textAlignment = NSTextAlignmentLeft;
    contractNoLb.font = JKFont(15);
    [bgView addSubview:contractNoLb];
    [contractNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.bottom.equalTo(midView.mas_top);
        make.width.mas_equalTo(65);
    }];
    
    UILabel *contractNoValueLb = [[UILabel alloc] init];
    contractNoValueLb.text = @"12345678901";
    contractNoValueLb.textColor = RGBHex(0x333333);
    contractNoValueLb.textAlignment = NSTextAlignmentLeft;
    contractNoValueLb.font = JKFont(15);
    [bgView addSubview:contractNoValueLb];
    [contractNoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(contractNoLb.mas_right);
        make.bottom.equalTo(midView.mas_top);
        make.right.equalTo(bgView.mas_right);
    }];
    
    UILabel *contractNameLb = [[UILabel alloc] init];
    contractNameLb.text = @"合同名称：小小";
    contractNameLb.textColor = RGBHex(0x333333);
    contractNameLb.textAlignment = NSTextAlignmentLeft;
    contractNameLb.font = JKFont(13);
    [midView addSubview:contractNameLb];
    [contractNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_top).offset(SCALE_SIZE(5));
        make.left.equalTo(midView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(midView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *contractAmountLb = [[UILabel alloc] init];
    contractAmountLb.text = @"合同金额：￥23333";
    contractAmountLb.textColor = RGBHex(0x333333);
    contractAmountLb.textAlignment = NSTextAlignmentLeft;
    contractAmountLb.font = JKFont(13);
    [midView addSubview:contractAmountLb];
    [contractAmountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractNameLb.mas_bottom);
        make.left.equalTo(midView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(midView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = @"签约时间：2018.06.12";
    timeLb.textColor = RGBHex(0x333333);
    timeLb.textAlignment = NSTextAlignmentLeft;
    timeLb.font = JKFont(13);
    [midView addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractAmountLb.mas_bottom);
        make.left.equalTo(midView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(midView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *effectivTimeLb = [[UILabel alloc] init];
    effectivTimeLb.text = @"有效时间：2018.09.09-2019.09.09";
    effectivTimeLb.textColor = RGBHex(0x666666);
    effectivTimeLb.textAlignment = NSTextAlignmentLeft;
    effectivTimeLb.font = JKFont(15);
    [bgView addSubview:effectivTimeLb];
    [effectivTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.bottom.equalTo(bgView.mas_bottom);
    }];
}


@end
