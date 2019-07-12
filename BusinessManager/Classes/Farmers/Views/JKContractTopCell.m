//
//  JKContractTopCell.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractTopCell.h"

@implementation JKContractTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = @"订单编号：123456789765";
    orderNoLb.textColor = RGBHex(0x333333);
    orderNoLb.textAlignment = NSTextAlignmentLeft;
    orderNoLb.font = JKFont(14);
    [self addSubview:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoLb.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *contractNameLb = [[UILabel alloc] init];
    contractNameLb.text = @"合同名称：呜啦啦";
    contractNameLb.textColor = RGBHex(0x333333);
    contractNameLb.textAlignment = NSTextAlignmentLeft;
    contractNameLb.font = JKFont(12);
    [self addSubview:contractNameLb];
    [contractNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_top).offset(SCALE_SIZE(5));
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *contractAmountLb = [[UILabel alloc] init];
    contractAmountLb.text = @"合同金额：￥23333";
    contractAmountLb.textColor = RGBHex(0x333333);
    contractAmountLb.textAlignment = NSTextAlignmentLeft;
    contractAmountLb.font = JKFont(12);
    [self addSubview:contractAmountLb];
    [contractAmountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractNameLb.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = @"签约时间：2018.06.12";
    timeLb.textColor = RGBHex(0x333333);
    timeLb.textAlignment = NSTextAlignmentLeft;
    timeLb.font = JKFont(12);
    [self addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractAmountLb.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *midLineLb = [[UILabel alloc] init];
    midLineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:midLineLb];
    [midLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLb.mas_bottom).offset(SCALE_SIZE(5));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *totalLb = [[UILabel alloc] init];
    totalLb.text = @"合同金额";
    totalLb.textColor = RGBHex(0x686868);
    totalLb.textAlignment = NSTextAlignmentLeft;
    totalLb.font = JKFont(14);
    [self addSubview:totalLb];
    [totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLineLb.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(100, SCALE_SIZE(40)));
    }];
    
    UILabel *totalValueLb = [[UILabel alloc] init];
    totalValueLb.text = @"￥4000.00";
    totalValueLb.textColor = RGBHex(0x686868);
    totalValueLb.textAlignment = NSTextAlignmentRight;
    totalValueLb.font = JKFont(14);
    [self addSubview:totalValueLb];
    [totalValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLineLb.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalLb.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *realPaymentLb = [[UILabel alloc] init];
    realPaymentLb.text = @"实付款：￥5288.00";
    realPaymentLb.textColor = RGBHex(0x333333);
    realPaymentLb.textAlignment = NSTextAlignmentRight;
    realPaymentLb.font = JKFont(16);
    [self addSubview:realPaymentLb];
    [realPaymentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];
}

@end
