//
//  JKContractFarmerCell.m
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractFarmerCell.h"
#import "JKFarmerModel.h"

@interface JKContractFarmerCell ()
@property (nonatomic, strong) JKFarmerModel *model;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addrLb;
@end

@implementation JKContractFarmerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createUI:(JKFarmerModel *)model {
    UIImageView *headImgV = [[UIImageView alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.farmerPic] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",model.farmerPic] isEqualToString:@"(null)"]) {
        headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    } else {
        NSArray *arr = [model.farmerPic componentsSeparatedByString:@","];
        headImgV.yy_imageURL = [NSURL URLWithString:arr[0]];
    }
    headImgV.layer.cornerRadius = 20;
    headImgV.layer.masksToBounds = YES;
    [self addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLb removeFromSuperview];
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = model.farmerName;
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(16);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImgV.mas_centerY).offset(-5);
        make.left.equalTo(headImgV.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    self.nameLb = nameLb;
    
    [self.addrLb removeFromSuperview];
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.text = [NSString stringWithFormat:@"%@%@",model.farmerRegion,model.farmerAdd];
    addrLb.textColor = RGBHex(0x666666);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(14);
    addrLb.numberOfLines = 2;
    [addrLb sizeToFit];
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgV.mas_centerY).offset(-5);
        make.left.equalTo(headImgV.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(35);
    }];
    self.addrLb = addrLb;
    
    self.model = model;
}


@end
