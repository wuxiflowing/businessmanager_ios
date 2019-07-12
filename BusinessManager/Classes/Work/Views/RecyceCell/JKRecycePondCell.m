//
//  JKRecycePondCell.m
//  BusinessManager
//
//  Created by  on 2018/11/6.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecycePondCell.h"
#import "JKRecyceInfoModel.h"

@implementation JKRecycePondCell

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
    recyceLb.text = @"回收清单";
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
    
    NSInteger col = 0;
    NSLog(@"%@",model.tabPonds);
    for (JKPondInfoModel *pModel in model.tabPonds) {
        UIView *childView = [[UIView alloc] init];
        childView.backgroundColor = kWhiteColor;
        [bgView addSubview:childView];
        [childView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recyceLb.mas_bottom).offset((34 * 4 + 10) * col);
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(34 * 4 + 5);
        }];
        
        col++;
        
        UILabel *topLineLb = [[UILabel alloc] init];
        topLineLb.backgroundColor = RGBHex(0xdddddd);
        [childView addSubview:topLineLb];
        [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(childView.mas_top);
            make.left.right.equalTo(childView);
            make.height.mas_equalTo(0.5);
        }];

        UILabel *pondNameLb = [[UILabel alloc] init];
        pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@", pModel.ITEM1];
        pondNameLb.textColor = RGBHex(0x333333);
        pondNameLb.textAlignment = NSTextAlignmentLeft;
        pondNameLb.font = JKFont(14);
        [childView addSubview:pondNameLb];
        [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLineLb.mas_top).offset(5);
            make.left.equalTo(childView.mas_left).offset(15);
            make.right.equalTo(childView.mas_right).offset(-10);
            make.height.mas_equalTo(34);
        }];

        UILabel *pondAddrLb = [[UILabel alloc] init];
        pondAddrLb.text = [NSString stringWithFormat:@"鱼塘位置：%@", pModel.ITEM2];
        pondAddrLb.textColor = RGBHex(0x333333);
        pondAddrLb.textAlignment = NSTextAlignmentLeft;
        pondAddrLb.font = JKFont(14);
        pondAddrLb.numberOfLines = 2;
        [childView addSubview:pondAddrLb];
        [pondAddrLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pondNameLb.mas_bottom);
            make.left.equalTo(childView.mas_left).offset(15);
            make.right.equalTo(childView.mas_right).offset(-10);
            make.height.mas_equalTo(34);
        }];

        UILabel *deviceIdLb = [[UILabel alloc] init];
        deviceIdLb.text = [NSString stringWithFormat:@"设备ID：%@", pModel.ITEM4];
        deviceIdLb.textColor = RGBHex(0x333333);
        deviceIdLb.textAlignment = NSTextAlignmentLeft;
        deviceIdLb.font = JKFont(14);
        [childView addSubview:deviceIdLb];
        [deviceIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pondAddrLb.mas_bottom);
            make.left.equalTo(childView.mas_left).offset(15);
            make.right.equalTo(childView.mas_right).offset(-10);
            make.height.mas_equalTo(34);
        }];

        UILabel *pondPhoneLb = [[UILabel alloc] init];
        pondPhoneLb.text = [NSString stringWithFormat:@"鱼塘联系电话：%@", pModel.ITEM3];
        pondPhoneLb.textColor = RGBHex(0x333333);
        pondPhoneLb.textAlignment = NSTextAlignmentLeft;
        pondPhoneLb.font = JKFont(14);
        [childView addSubview:pondPhoneLb];
        [pondPhoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deviceIdLb.mas_bottom);
            make.left.equalTo(childView.mas_left).offset(15);
            make.right.equalTo(childView.mas_right).offset(-10);
            make.height.mas_equalTo(34);
        }];

        //    UILabel *operationPeopleLb = [[UILabel alloc] init];
        //    NSArray *arr = [model.ITEM6 componentsSeparatedByString:@" "];
        //    operationPeopleLb.text = [NSString stringWithFormat:@"运维管家：%@",arr[0]];
        //    operationPeopleLb.textColor = RGBHex(0x333333);
        //    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
        //    operationPeopleLb.font = JKFont(14);
        //    [bgView addSubview:operationPeopleLb];
        //    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(pondPhoneLb.mas_bottom);
        //        make.left.equalTo(bgView.mas_left).offset(15);
        //        make.right.equalTo(bgView.mas_right).offset(-10);
        //        make.height.mas_equalTo(34);
        //    }];
    }
}




@end
