//
//  JKRecyceInfoMidCell.m
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceInfoMidCell.h"

@implementation JKRecyceInfoMidCell

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
    
    UILabel *recyceNoLb = [[UILabel alloc] init];
    recyceNoLb.text = @"回收工单";
    recyceNoLb.textColor = RGBHex(0x333333);
    recyceNoLb.textAlignment = NSTextAlignmentLeft;
    recyceNoLb.font = JKFont(15);
    [bgView addSubview:recyceNoLb];
    [recyceNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];

    UILabel *stateLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecycePending) {
        stateLb.text = @"待审核";
    } else if (self.recyceType == JKRecyceWait) {
        stateLb.text = @"待接单";
    } else if (self.recyceType == JKRecyceIng) {
        stateLb.text = @"进行中";
    } else if (self.recyceType == JKRecyceEd) {
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
        make.top.equalTo(recyceNoLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *deviceTypeLb = [[UILabel alloc] init];
    deviceTypeLb.text = @"设备类型：套餐1、套餐2";
    deviceTypeLb.textColor = RGBHex(0x333333);
    deviceTypeLb.textAlignment = NSTextAlignmentLeft;
    deviceTypeLb.font = JKFont(12);
    [bgView addSubview:deviceTypeLb];
    [deviceTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = @"鱼塘名称：鱼塘01、鱼塘02";
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(12);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceTypeLb.mas_bottom);
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
    
    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = @"联系电话：88888888888";
    phoneLb.textColor = RGBHex(0x333333);
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(12);
    [bgView addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(phoneLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.text = @"回收内容：内用内用内内用用内用";
    contentLb.textColor = RGBHex(0x333333);
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.numberOfLines = 2;
    contentLb.font = JKFont(12);
    [bgView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(40));
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = @"计划完成时间：2018-09-09";
    timeLb.textColor = RGBHex(0x666666);
    timeLb.textAlignment = NSTextAlignmentLeft;
    timeLb.font = JKFont(12);
    [bgView addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    if (self.recyceType == JKRecyceWait) {
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
    } else if (self.recyceType == JKRecycePending) {
        UIButton *pendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pendBtn setTitle:@"审核" forState:UIControlStateNormal];
        [pendBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [pendBtn addTarget:self action:@selector(pendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        pendBtn.titleLabel.font = JKFont(15);
        pendBtn.layer.cornerRadius = 2;
        pendBtn.layer.masksToBounds = YES;
        [pendBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [pendBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [pendBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        [bgView addSubview:pendBtn];
        [pendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)pendBtnClick:(UIButton *)btn {
        if ([_delegate respondsToSelector:@selector(clickPendBtn:)]) {
            [_delegate clickPendBtn:btn];
        }
}

@end
