//
//  JKRecyceOrderCell.m
//  OperationsManager
//
//  Created by  on 2018/7/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecycePendOrderCell.h"
#import "JKRecyceInfoModel.h"

@implementation JKRecycePendOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKRecyceInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.right.bottom.equalTo(self.contentView);
    }];

    UILabel *recyceLb = [[UILabel alloc] init];
    recyceLb.text = @"回收工单";
    recyceLb.textColor = RGBHex(0x333333);
    recyceLb.textAlignment = NSTextAlignmentLeft;
    recyceLb.font = JKFont(16);
    [bgView addSubview:recyceLb];
    [recyceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceWait) {
        stateLb.text = @"待接单";
    } else if (self.recyceType == JKRecyceIng) {
        stateLb.text = @"进行中";
    } else if (self.recyceType == JKRecyceEd) {
        stateLb.text = @"已完成";
    } else if (self.recyceType == JKRecyceCheck) {
        stateLb.text = @"待我审核";
    } else if (self.recyceType == JKRecycePending) {
        stateLb.text = @"待大区经理审核";
    } else if (self.recyceType == JKRecyceOverrule) {
        stateLb.text = @"已驳回";
    } else if (self.recyceType == JKRecyceThrough) {
        stateLb.text = @"审核通过";
    } else if (self.recyceType == JKRecyceFinish) {
        stateLb.text = @"已完成";
    } else if (self.recyceType == JKRecyceMagAuditPass) {
        stateLb.text = @"大区经理审核通过";
    } else if (self.recyceType == JKRecyceMagAuditReject) {
        stateLb.text = @"大区经理审核驳回";
    }
    stateLb.textColor = kRedColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(16);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recyceLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"发起时间：%@", model.txtStartDate];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    if (model.txtCSMembName.length == 0) {
        pondNameLb.text = [NSString stringWithFormat:@"发起人：%@", model.txtHK];
    } else {
        pondNameLb.text = [NSString stringWithFormat:@"发起人：%@", model.txtCSMembName];
    }
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *deviceRecyceLb = [[UILabel alloc] init];
    deviceRecyceLb.text = [NSString stringWithFormat:@"审核人：%@", model.txtCenMagName];
    deviceRecyceLb.textColor = RGBHex(0x333333);
    deviceRecyceLb.textAlignment = NSTextAlignmentLeft;
    deviceRecyceLb.font = JKFont(14);
    [bgView addSubview:deviceRecyceLb];
    [deviceRecyceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *resonLb = [[UILabel alloc] init];
    if (model.tarCustomerReson.length == 0) {
        resonLb.text = [NSString stringWithFormat:@"回收原因：%@", model.txtResMulti];
    } else {
        resonLb.text = [NSString stringWithFormat:@"回收原因：%@", model.tarCustomerReson];
    }
    resonLb.textColor = RGBHex(0x333333);
    resonLb.textAlignment = NSTextAlignmentLeft;
    resonLb.font = JKFont(14);
    resonLb.numberOfLines = 2;
    [bgView addSubview:resonLb];
    [resonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceRecyceLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.text = [NSString stringWithFormat:@"备注：%@", model.tarReson];
    contentLb.textColor = RGBHex(0x333333);
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.font = JKFont(14);
    contentLb.numberOfLines = 2;
    [bgView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resonLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
}


@end
