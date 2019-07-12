//
//  JKPondCell.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKPondCell.h"

@interface JKPondCell ()
@property (nonatomic, strong) NSArray *infoArr;
@end

@implementation JKPondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.infoArr = @[@"设备套数", @"鱼塘面积", @"账户金额", @"欠款金额"];
    }
    return self;
}

- (void)createUI {
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (NSInteger i = 0; i < self.infoArr.count; i++) {
        UIView *infoView = [[UIView alloc] init];
        infoView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(65);
            make.left.mas_equalTo(btnWidth * i);
        }];
        
        UILabel *numberLb = [[UILabel alloc] init];
        numberLb.text = [NSString stringWithFormat:@"%@",self.infoNumberArr[i]];
        numberLb.textColor = RGBHex(0x333333);
        numberLb.textAlignment = NSTextAlignmentCenter;
        numberLb.font = JKFont(14);
        [infoView addSubview:numberLb];
        [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infoView.mas_centerY);
            make.left.right.equalTo(infoView);
            make.height.mas_equalTo(25);
        }];
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = self.infoArr[i];
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(14);
        [infoView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView.mas_centerY);
            make.left.right.equalTo(infoView);
            make.height.mas_equalTo(25);
        }];
    }
}


@end
