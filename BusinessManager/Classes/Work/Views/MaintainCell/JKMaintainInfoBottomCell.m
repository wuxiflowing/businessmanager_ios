//
//  JKMaintainInfoBottomCell.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainInfoBottomCell.h"

@interface JKMaintainInfoBottomCell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation JKMaintainInfoBottomCell

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

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
        make.top.equalTo(self).offset(SCALE_SIZE(15));
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *resultLb = [[UILabel alloc] init];
    resultLb.text = @"处理结果";
    resultLb.textColor = RGBHex(0x333333);
    resultLb.textAlignment = NSTextAlignmentLeft;
    resultLb.font = JKFont(15);
    [bgView addSubview:resultLb];
    [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *lineOneLb = [[UILabel alloc] init];
    lineOneLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:lineOneLb];
    [lineOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *maintainTypeLb = [[UILabel alloc] init];
    maintainTypeLb.text = @"维护类型";
    maintainTypeLb.textColor = RGBHex(0x333333);
    maintainTypeLb.textAlignment = NSTextAlignmentLeft;
    maintainTypeLb.font = JKFont(13);
    [bgView addSubview:maintainTypeLb];
    [maintainTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOneLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *maintainValueLb = [[UILabel alloc] init];
    maintainValueLb.text = @"清洗";
    maintainValueLb.textColor = RGBHex(0x666666);
    maintainValueLb.textAlignment = NSTextAlignmentRight;
    maintainValueLb.font = JKFont(13);
    [bgView addSubview:maintainValueLb];
    [maintainValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOneLb.mas_bottom);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.left.equalTo(maintainTypeLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *lineTwoLb = [[UILabel alloc] init];
    lineTwoLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:lineTwoLb];
    [lineTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maintainValueLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *nextMaintainTimeLb = [[UILabel alloc] init];
    nextMaintainTimeLb.text = @"下次维护时间";
    nextMaintainTimeLb.textColor = RGBHex(0x333333);
    nextMaintainTimeLb.textAlignment = NSTextAlignmentLeft;
    nextMaintainTimeLb.font = JKFont(13);
    [bgView addSubview:nextMaintainTimeLb];
    [nextMaintainTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwoLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *nextMaintainTimeValueLb = [[UILabel alloc] init];
    nextMaintainTimeValueLb.text = @"2018-09-09";
    nextMaintainTimeValueLb.textColor = RGBHex(0x666666);
    nextMaintainTimeValueLb.textAlignment = NSTextAlignmentRight;
    nextMaintainTimeValueLb.font = JKFont(13);
    [bgView addSubview:nextMaintainTimeValueLb];
    [nextMaintainTimeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwoLb.mas_bottom);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.left.equalTo(nextMaintainTimeLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *lineThreeLb = [[UILabel alloc] init];
    lineThreeLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:lineThreeLb];
    [lineThreeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextMaintainTimeValueLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *orderTimeLb = [[UILabel alloc] init];
    orderTimeLb.text = @"接单时间";
    orderTimeLb.textColor = RGBHex(0x333333);
    orderTimeLb.textAlignment = NSTextAlignmentLeft;
    orderTimeLb.font = JKFont(13);
    [bgView addSubview:orderTimeLb];
    [orderTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThreeLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *orderTimeValueLb = [[UILabel alloc] init];
    orderTimeValueLb.text = @"2018-09-09";
    orderTimeValueLb.textColor = RGBHex(0x666666);
    orderTimeValueLb.textAlignment = NSTextAlignmentRight;
    orderTimeValueLb.font = JKFont(13);
    [bgView addSubview:orderTimeValueLb];
    [orderTimeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThreeLb.mas_bottom);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.left.equalTo(orderTimeLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *linefourLb = [[UILabel alloc] init];
    linefourLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:linefourLb];
    [linefourLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTimeValueLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *finishTimeLb = [[UILabel alloc] init];
    finishTimeLb.text = @"完成时间";
    finishTimeLb.textColor = RGBHex(0x333333);
    finishTimeLb.textAlignment = NSTextAlignmentLeft;
    finishTimeLb.font = JKFont(13);
    [bgView addSubview:finishTimeLb];
    [finishTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linefourLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *finishTimeValueLb = [[UILabel alloc] init];
    finishTimeValueLb.text = @"2018-09-09";
    finishTimeValueLb.textColor = RGBHex(0x666666);
    finishTimeValueLb.textAlignment = NSTextAlignmentRight;
    finishTimeValueLb.font = JKFont(13);
    [bgView addSubview:finishTimeValueLb];
    [finishTimeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linefourLb.mas_bottom);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.left.equalTo(orderTimeLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *linefiveLb = [[UILabel alloc] init];
    linefiveLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:linefiveLb];
    [linefiveLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(finishTimeValueLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *remarkValueLb = [[UILabel alloc] init];
    remarkValueLb.text = @"由于机器突然宕机导致,数据检测出现问题重启设备后，设备一切正常，农户已确认；";
    remarkValueLb.textColor = RGBHex(0x666666);
    remarkValueLb.textAlignment = NSTextAlignmentRight;
    remarkValueLb.font = JKFont(13);
    remarkValueLb.numberOfLines = 0;
//    remarkValueLb.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:remarkValueLb];
    [remarkValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linefiveLb.mas_bottom);
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(SCALE_SIZE(60));
    }];
    
    UILabel *remarkLb = [[UILabel alloc] init];
    remarkLb.text = @"备注";
    remarkLb.textColor = RGBHex(0x333333);
    remarkLb.textAlignment = NSTextAlignmentLeft;
    remarkLb.font = JKFont(13);
    [bgView addSubview:remarkLb];
    [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remarkValueLb.mas_centerY);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    UILabel *lineSixLb = [[UILabel alloc] init];
    lineSixLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:lineSixLb];
    [lineSixLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkValueLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *annexPictureLb = [[UILabel alloc] init];
    annexPictureLb.text = @"附件图片";
    annexPictureLb.textColor = RGBHex(0x333333);
    annexPictureLb.textAlignment = NSTextAlignmentLeft;
    annexPictureLb.font = JKFont(13);
    [bgView addSubview:annexPictureLb];
    [annexPictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineSixLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(SCALE_SIZE(50));
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self createScrollViewWithLabel:annexPictureLb withPicure:arr];
}

- (void)createScrollViewWithLabel:(UILabel *)label withPicure:(NSMutableArray *)arr {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(self.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(80);
    }];
    
    self.scrollView.contentSize = CGSizeMake(90 *6, 80);
    
    for (NSInteger i = 0; i < 6; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(90 * i , 0, 80, 80);
        imgV.userInteractionEnabled = YES;
        imgV.backgroundColor = kLightGrayColor;
        //            NSString *img = [NSString stringWithFormat:@"%@!small.jpg",self.imgsArr[i]];
        //            [imgV sd_setImageWithURL:[NSURL URLWithString:img]];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imgV];
        
        //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //            btn.frame = CGRectMake(0 , 0, 110, 110);
        //            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //            [imgV addSubview:btn];
    }
}


@end
