//
//  JKMaintainInfoMidCell.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainInfoMidCell.h"

@implementation JKMaintainInfoMidCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCALE_SIZE(15));
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *maintainNoLb = [[UILabel alloc] init];
    maintainNoLb.text = @"维护工单";
    maintainNoLb.textColor = RGBHex(0x333333);
    maintainNoLb.textAlignment = NSTextAlignmentLeft;
    maintainNoLb.font = JKFont(15);
    [bgView addSubview:maintainNoLb];
    [maintainNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(40));
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
    stateLb.font = JKFont(15);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maintainNoLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = @"工单号：123456789";
    orderNoLb.textColor = RGBHex(0x333333);
    orderNoLb.textAlignment = NSTextAlignmentLeft;
    orderNoLb.font = JKFont(12);
    [bgView addSubview:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = @"鱼塘名称：鱼塘01";
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(12);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *pondAddrLb = [[UILabel alloc] init];
    pondAddrLb.text = @"鱼塘位置：无锡市滨湖区建筑西路589号建苑大厦4楼";
    pondAddrLb.textColor = RGBHex(0x333333);
    pondAddrLb.textAlignment = NSTextAlignmentLeft;
    pondAddrLb.font = JKFont(12);
//    pondAddrLb.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:pondAddrLb];
    [pondAddrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = @"设备ID：123456";
    deviceIDLb.textColor = RGBHex(0x333333);
    deviceIDLb.textAlignment = NSTextAlignmentLeft;
    deviceIDLb.font = JKFont(12);
//    deviceIDLb.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = @"运维管家：小小";
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(12);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    if (self.maintainType == JKMaintainWait) {
        UILabel *bottomLineLb = [[UILabel alloc] init];
        bottomLineLb.backgroundColor = RGBHex(0xdddddd);
        [bgView addSubview:bottomLineLb];
        [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(operationPeopleLb.mas_bottom);
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *timeLb = [[UILabel alloc] init];
        //    timeLb.text = @"计划完成时间：2018-09-09";
        timeLb.textColor = RGBHex(0x666666);
        timeLb.textAlignment = NSTextAlignmentLeft;
        timeLb.font = JKFont(12);
        [bgView addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomLineLb.mas_bottom);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.width.mas_equalTo((SCREEN_WIDTH - SCALE_SIZE(30))/ 3 * 2);
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"接单" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.titleLabel.font = JKFont(14);
        orderBtn.layer.cornerRadius = 2;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        [bgView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLb.mas_centerY);
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.width.mas_equalTo((SCREEN_WIDTH - SCALE_SIZE(30))/ 3 *0.5);
            make.height.mas_equalTo(SCALE_SIZE(25));
        }];
    }
}

- (void)orderBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(clickOrderBtn:)]) {
        [_delegate clickOrderBtn:btn];
    }
}

@end
