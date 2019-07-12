//
//  JKOrderCell.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOrderCell.h"

@implementation JKOrderCell

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
        make.height.mas_equalTo(SCALE_SIZE(110));
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(midView.mas_top);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = @"订单编号：";
    orderNoLb.textColor = RGBHex(0x333333);
    orderNoLb.textAlignment = NSTextAlignmentLeft;
    orderNoLb.font = JKFont(15);
    [bgView addSubview:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.bottom.equalTo(midView.mas_top);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    stateLb.text = @"待支付";
    stateLb.textColor = kRedColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(15);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.bottom.equalTo(midView.mas_top);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *orderNoValueLb = [[UILabel alloc] init];
    orderNoValueLb.text = @"12345678901";
    orderNoValueLb.textColor = RGBHex(0x333333);
    orderNoValueLb.textAlignment = NSTextAlignmentLeft;
    orderNoValueLb.font = JKFont(15);
    [bgView addSubview:orderNoValueLb];
    [orderNoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(orderNoLb.mas_right);
        make.bottom.equalTo(midView.mas_top);
        make.right.equalTo(stateLb.mas_left);
    }];
    
    UILabel *farmerNameLb = [[UILabel alloc] init];
    farmerNameLb.text = @"养殖户名称：小小";
    farmerNameLb.textColor = RGBHex(0x333333);
    farmerNameLb.textAlignment = NSTextAlignmentLeft;
    farmerNameLb.font = JKFont(13);
    [midView addSubview:farmerNameLb];
    [farmerNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_top).offset(SCALE_SIZE(5));
        make.left.equalTo(midView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(midView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *contractNameLb = [[UILabel alloc] init];
    contractNameLb.text = @"合同名称：呜啦啦";
    contractNameLb.textColor = RGBHex(0x333333);
    contractNameLb.textAlignment = NSTextAlignmentLeft;
    contractNameLb.font = JKFont(13);
    [midView addSubview:contractNameLb];
    [contractNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(farmerNameLb.mas_bottom);
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
    
    UILabel *payLb = [[UILabel alloc] init];
    payLb.text = @"实付款：￥5288.00";
    payLb.textColor = RGBHex(0x333333);
    payLb.textAlignment = NSTextAlignmentRight;
    payLb.font = JKFont(15);
    [bgView addSubview:payLb];
    [payLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midView.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
}

@end
