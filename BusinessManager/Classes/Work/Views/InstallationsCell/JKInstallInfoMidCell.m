//
//  JKInstallInfoMidCell.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallInfoMidCell.h"
#import "JKInstallInfoModel.h"

@implementation JKInstallInfoMidCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
    }
    return self;
}

- (void)createUI:(JKInstallInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *repairNoLb = [[UILabel alloc] init];
    repairNoLb.text = @"安装工单";
    repairNoLb.textColor = RGBHex(0x333333);
    repairNoLb.textAlignment = NSTextAlignmentLeft;
    repairNoLb.font = JKFont(16);
    [bgView addSubview:repairNoLb];
    [repairNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.installType == JKInstallationWait) {
        stateLb.text = @"待接单";
    } else if (self.installType == JKInstallationIng) {
        stateLb.text = @"进行中";
    } else if (self.installType == JKInstallationEd) {
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
        make.top.equalTo(repairNoLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *orderCountsLb = [[UILabel alloc] init];
    orderCountsLb.text = [NSString stringWithFormat:@"设备安装数量：%@套",model.txtDeviceNum];
    orderCountsLb.textColor = RGBHex(0x333333);
    orderCountsLb.textAlignment = NSTextAlignmentLeft;
    orderCountsLb.font = JKFont(14);
    [bgView addSubview:orderCountsLb];
    [orderCountsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.orderCountsLb = orderCountsLb;
    
    UILabel *installAddrValueLb = [[UILabel alloc] init];
    installAddrValueLb.text = [NSString stringWithFormat:@"安装地址：%@",model.txtInstallAddress];
    installAddrValueLb.textColor = RGBHex(0x333333);
    installAddrValueLb.textAlignment = NSTextAlignmentLeft;
    installAddrValueLb.font = JKFont(14);
    installAddrValueLb.numberOfLines = 2;
    [bgView addSubview:installAddrValueLb];
    [installAddrValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderCountsLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.installAddrValueLb = installAddrValueLb;
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"运维管家：%@",model.txtInstallationPersonnel];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(installAddrValueLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.operationPeopleLb = operationPeopleLb;
    
    UILabel *collectionServiceFeeLb = [[UILabel alloc] init];
    collectionServiceFeeLb.text = [NSString stringWithFormat:@"代收服务费：%@元",model.txtServiceAmount];
    collectionServiceFeeLb.textColor = RGBHex(0x333333);
    collectionServiceFeeLb.textAlignment = NSTextAlignmentLeft;
    collectionServiceFeeLb.font = JKFont(14);
    [bgView addSubview:collectionServiceFeeLb];
    [collectionServiceFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.collectionServiceFeeLb = collectionServiceFeeLb;
    
    UILabel *collectionDepositFeeLb = [[UILabel alloc] init];
    collectionDepositFeeLb.text = [NSString stringWithFormat:@"代收押金费：%@元",model.txtDepositAmount];
    collectionDepositFeeLb.textColor = RGBHex(0x333333);
    collectionDepositFeeLb.textAlignment = NSTextAlignmentLeft;
    collectionDepositFeeLb.font = JKFont(14);
    [bgView addSubview:collectionDepositFeeLb];
    [collectionDepositFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionServiceFeeLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.collectionDepositFeeLb = collectionDepositFeeLb;
    
    UILabel *otherLineLb = [[UILabel alloc] init];
    otherLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:otherLineLb];
    [otherLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionDepositFeeLb.mas_bottom).offset(5);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = [NSString stringWithFormat:@"计划完成时间：%@",model.calExpectedTime];
    timeLb.textColor = RGBHex(0x666666);
    timeLb.textAlignment = NSTextAlignmentLeft;
    timeLb.font = JKFont(15);
    [bgView addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLineLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    self.timeLb = timeLb;
}

@end
