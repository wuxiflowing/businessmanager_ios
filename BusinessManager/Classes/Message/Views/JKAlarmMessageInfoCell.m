//
//  JKAlarmMessageInfoself.m
//  BusinessManager
//
//  Created by  on 2018/7/30.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKAlarmMessageInfoCell.h"

@implementation JKAlarmMessageInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = @"告警消息";
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(15);
    [self.contentView addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];

    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [self.contentView addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

    UILabel *pondNameTitleLb = [[UILabel alloc] init];
    pondNameTitleLb.text = @"鱼塘名称：";
    pondNameTitleLb.textColor = RGBHex(0x333333);
    pondNameTitleLb.textAlignment = NSTextAlignmentLeft;
    pondNameTitleLb.font = JKFont(13);
    [self.contentView addSubview:pondNameTitleLb];
    [pondNameTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLb.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = @"鱼塘01";
    pondNameLb.textColor = RGBHex(0x888888);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(13);
    [self.contentView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameTitleLb.mas_top);
        make.left.equalTo(pondNameTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];

    UILabel *pondAddrTitleLb = [[UILabel alloc] init];
    pondAddrTitleLb.text = @"鱼塘位置：";
    pondAddrTitleLb.textColor = RGBHex(0x333333);
    pondAddrTitleLb.textAlignment = NSTextAlignmentLeft;
    pondAddrTitleLb.font = JKFont(13);
    [self.contentView addSubview:pondAddrTitleLb];
    [pondAddrTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameTitleLb.mas_bottom);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *pondAddrLb = [[UILabel alloc] init];
    pondAddrLb.text = @"无锡市滨湖区建筑西路589号建苑";
    pondAddrLb.textColor = RGBHex(0x888888);
    pondAddrLb.textAlignment = NSTextAlignmentLeft;
    pondAddrLb.font = JKFont(13);
    pondAddrLb.numberOfLines = 0;
    pondAddrLb.lineBreakMode = NSLineBreakByClipping;
    pondAddrLb.text = [pondAddrLb.text stringByAppendingString:@"\n"];
    [pondAddrLb sizeToFit];
    [self.contentView addSubview:pondAddrLb];
    [pondAddrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrTitleLb.mas_top);
        make.left.equalTo(pondAddrTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(45);
    }];

    UILabel *deviceIDTitleLb = [[UILabel alloc] init];
    deviceIDTitleLb.text = @"设备ID：";
    deviceIDTitleLb.textColor = RGBHex(0x333333);
    deviceIDTitleLb.textAlignment = NSTextAlignmentLeft;
    deviceIDTitleLb.font = JKFont(13);
    [self.contentView addSubview:deviceIDTitleLb];
    [deviceIDTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrTitleLb.mas_bottom);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = @"1531523438743";
    deviceIDLb.textColor = RGBHex(0x888888);
    deviceIDLb.textAlignment = NSTextAlignmentLeft;
    deviceIDLb.font = JKFont(13);
    [self.contentView addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDTitleLb.mas_top);
        make.left.equalTo(deviceIDTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];

    UILabel *alarmTypeTitleLb = [[UILabel alloc] init];
    alarmTypeTitleLb.text = @"告警类型：";
    alarmTypeTitleLb.textColor = RGBHex(0x333333);
    alarmTypeTitleLb.textAlignment = NSTextAlignmentLeft;
    alarmTypeTitleLb.font = JKFont(13);
    [self.contentView addSubview:alarmTypeTitleLb];
    [alarmTypeTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDLb.mas_bottom);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *alarmTypeLb = [[UILabel alloc] init];
    alarmTypeLb.text = @"数据告警";
    alarmTypeLb.textColor = RGBHex(0x888888);
    alarmTypeLb.textAlignment = NSTextAlignmentLeft;
    alarmTypeLb.font = JKFont(13);
    [self.contentView addSubview:alarmTypeLb];
    [alarmTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmTypeTitleLb.mas_top);
        make.left.equalTo(alarmTypeTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];

    UILabel *alarmLineTitleLb = [[UILabel alloc] init];
    alarmLineTitleLb.text = @"告警线：";
    alarmLineTitleLb.textColor = RGBHex(0x333333);
    alarmLineTitleLb.textAlignment = NSTextAlignmentLeft;
    alarmLineTitleLb.font = JKFont(13);
    [self.contentView addSubview:alarmLineTitleLb];
    [alarmLineTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmTypeTitleLb.mas_bottom);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *alarmLineLb = [[UILabel alloc] init];
    alarmLineLb.text = @"告警线";
    alarmLineLb.textColor = RGBHex(0x888888);
    alarmLineLb.textAlignment = NSTextAlignmentLeft;
    alarmLineLb.font = JKFont(13);
    [self.contentView addSubview:alarmLineLb];
    [alarmLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmLineTitleLb.mas_top);
        make.left.equalTo(alarmLineTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];

    UILabel *alarmInfoTitleLb = [[UILabel alloc] init];
    alarmInfoTitleLb.text = @"告警信息：";
    alarmInfoTitleLb.textColor = RGBHex(0x333333);
    alarmInfoTitleLb.textAlignment = NSTextAlignmentLeft;
    alarmInfoTitleLb.font = JKFont(13);
//    alarmInfoTitleLb.backgroundColor = kRedColor;
    [self.contentView addSubview:alarmInfoTitleLb];
    [alarmInfoTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmLineTitleLb.mas_bottom);
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];

    UILabel *alarmInfoLb = [[UILabel alloc] init];
    alarmInfoLb.text = @"阿松姐弟";
    alarmInfoLb.textColor = RGBHex(0x888888);
    alarmInfoLb.font = JKFont(13);
    alarmInfoLb.textAlignment = NSTextAlignmentLeft;
    alarmInfoLb.numberOfLines = 0;
    alarmInfoLb.text = [alarmInfoLb.text stringByAppendingString:@"\n"];
    [alarmInfoLb sizeToFit];
//    alarmInfoLb.backgroundColor = kRedColor;
    [self.contentView addSubview:alarmInfoLb];
    [alarmInfoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmInfoTitleLb.mas_top);
        make.left.equalTo(alarmInfoTitleLb.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(45);
    }];
}


@end
