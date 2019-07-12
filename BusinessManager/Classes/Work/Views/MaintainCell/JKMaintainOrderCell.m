//
//  JKMaintainOrderCell.m
//  OperationsManager
//
//  Created by  on 2018/7/4.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainOrderCell.h"
#import "JKMaintainInfoModel.h"

@implementation JKMaintainOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKMaintainInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *maintainNoLb = [[UILabel alloc] init];
    maintainNoLb.text = @"维护工单";
    maintainNoLb.textColor = RGBHex(0x333333);
    maintainNoLb.textAlignment = NSTextAlignmentLeft;
    maintainNoLb.font = JKFont(16);
    [bgView addSubview:maintainNoLb];
    [maintainNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.maintainType == JKMaintainWait) {
        stateLb.text = @"待接单";
    } else if (self.maintainType == JKMaintainIng) {
        stateLb.text = @"进行中";
    } else if (self.maintainType == JKMaintainEd) {
        stateLb.text = @"已完成";
    }
    stateLb.textColor = kRedColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(16);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maintainNoLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = [NSString stringWithFormat:@"工单号：%@",model.txtFormNo];
    orderNoLb.textColor = RGBHex(0x333333);
    orderNoLb.textAlignment = NSTextAlignmentLeft;
    orderNoLb.font = JKFont(14);
    [bgView addSubview:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@",model.txtPondsName];
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *pondAddrValueLb = [[UILabel alloc] init];
    pondAddrValueLb.text = [NSString stringWithFormat:@"鱼塘位置：%@", model.txtPondAddr];
    pondAddrValueLb.textColor = RGBHex(0x333333);
    pondAddrValueLb.textAlignment = NSTextAlignmentLeft;
    pondAddrValueLb.font = JKFont(14);
    pondAddrValueLb.numberOfLines = 2;
    pondAddrValueLb.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:pondAddrValueLb];
    [pondAddrValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = [NSString stringWithFormat:@"设备类型: %@",model.txtRepairEqpKind];
    deviceIDLb.textColor = RGBHex(0x333333);
    deviceIDLb.textAlignment = NSTextAlignmentLeft;
    deviceIDLb.font = JKFont(14);
    [bgView addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrValueLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"运维管家：%@",model.txtMatnerMembName];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
}

@end
