//
//  JKOrderInfoBottomCell.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOrderInfoBottomCell.h"

@interface JKOrderInfoBottomCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *payWayLb;
@end

@implementation JKOrderInfoBottomCell

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

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
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCALE_SIZE(10));
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)createOrderInfoBottomUI:(NSInteger)infoType {
    
    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = @"订单编号：12345676788";
    [self setLabel:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(SCALE_SIZE(10));
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *orderStateLb = [[UILabel alloc] init];
    orderStateLb.text = @"订单状态：待支付";
    [self setLabel:orderStateLb];
    [orderStateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *payWayLb = [[UILabel alloc] init];
    payWayLb.text = @"付款方式：现金";
    [self setLabel:payWayLb];
    [payWayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderStateLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    self.payWayLb = payWayLb;
    
    if (infoType == 0) {
        [self createServiceUI];
    } else if (infoType == 1) {
        [self createDepositUI];
    } else if (infoType == 2) {
        [self createPrepaymentUI];
    } else if (infoType == 3) {
        [self createFeedUI];
    } 
}

- (void)createServiceUI {
    UILabel *pondNumberLb = [[UILabel alloc] init];
    pondNumberLb.text = @"鱼塘数量：3套";
    [self setLabel:pondNumberLb];
    [pondNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *pondAreaLb = [[UILabel alloc] init];
    pondAreaLb.text = @"鱼塘面积：233亩";
    [self setLabel:pondAreaLb];
    [pondAreaLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNumberLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *createTimeLb = [[UILabel alloc] init];
    createTimeLb.text = @"创建时间：2017-03-24 21:22:22";
    [self setLabel:createTimeLb];
    [createTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAreaLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionTimeLb = [[UILabel alloc] init];
    transactionTimeLb.text = @"交易时间：2017-03-24 21:22:22";
    [self setLabel:transactionTimeLb];
    [transactionTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *certificateLb = [[UILabel alloc] init];
    certificateLb.text = @"凭证：";
    [self setLabel:certificateLb];
    [certificateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self createScrollViewWithLabel:certificateLb withPicure:arr];
}

- (void)createDepositUI {
    UILabel *deviceNumberLb = [[UILabel alloc] init];
    deviceNumberLb.text = @"设备数量：3套";
    [self setLabel:deviceNumberLb];
    [deviceNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *createTimeLb = [[UILabel alloc] init];
    createTimeLb.text = @"创建时间：2017-03-24 21:22:22";
    [self setLabel:createTimeLb];
    [createTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceNumberLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionTimeLb = [[UILabel alloc] init];
    transactionTimeLb.text = @"交易时间：2017-03-24 21:22:22";
    [self setLabel:transactionTimeLb];
    [transactionTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionTypeLb = [[UILabel alloc] init];
    transactionTypeLb.text = @"交易类型：押金收取、押金退还";
    [self setLabel:transactionTypeLb];
    [transactionTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *certificateLb = [[UILabel alloc] init];
    certificateLb.text = @"凭证：";
    [self setLabel:certificateLb];
    [certificateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionTypeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self createScrollViewWithLabel:certificateLb withPicure:arr];
}

- (void)createPrepaymentUI {
    UILabel *feedBrandLb = [[UILabel alloc] init];
    feedBrandLb.text = @"饲料品牌：不知道";
    [self setLabel:feedBrandLb];
    [feedBrandLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *fishSpeciesLb = [[UILabel alloc] init];
    fishSpeciesLb.text = @"鱼种：小黄鱼";
    [self setLabel:fishSpeciesLb];
    [fishSpeciesLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedBrandLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionStateLb = [[UILabel alloc] init];
    transactionStateLb.text = @"交易状态：待交易";
    [self setLabel:transactionStateLb];
    [transactionStateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fishSpeciesLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *differenceLb = [[UILabel alloc] init];
    differenceLb.text = @"差价：12元/件";
    [self setLabel:differenceLb];
    [differenceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionStateLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *createTimeLb = [[UILabel alloc] init];
    createTimeLb.text = @"创建时间：2017-03-24 21:22:22";
    [self setLabel:createTimeLb];
    [createTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(differenceLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionTimeLb = [[UILabel alloc] init];
    transactionTimeLb.text = @"交易时间：2017-03-24 21:22:22";
    [self setLabel:transactionTimeLb];
    [transactionTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *certificateLb = [[UILabel alloc] init];
    certificateLb.text = @"凭证：";
    [self setLabel:certificateLb];
    [certificateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self createScrollViewWithLabel:certificateLb withPicure:arr];
}

- (void)createFeedUI {
    UILabel *feedNameLb = [[UILabel alloc] init];
    feedNameLb.text = @"饲料名称：不知道";
    [self setLabel:feedNameLb];
    [feedNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *feedCodeLb = [[UILabel alloc] init];
    feedCodeLb.text = @"饲料代码：KDKDKD";
    [self setLabel:feedCodeLb];
    [feedCodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedNameLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *fishSpeciesLb = [[UILabel alloc] init];
    fishSpeciesLb.text = @"鱼种：小黄鱼";
    [self setLabel:fishSpeciesLb];
    [fishSpeciesLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedCodeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *shelfLifeLb = [[UILabel alloc] init];
    shelfLifeLb.text = @"保质期：10天";
    [self setLabel:shelfLifeLb];
    [shelfLifeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fishSpeciesLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *productionDateLb = [[UILabel alloc] init];
    productionDateLb.text = @"生产日期：2018-09-09";
    [self setLabel:productionDateLb];
    [productionDateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shelfLifeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *priceLb = [[UILabel alloc] init];
    priceLb.text = @"单价：10元";
    [self setLabel:priceLb];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productionDateLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *fishNumberLb = [[UILabel alloc] init];
    fishNumberLb.text = @"数量：100条";
    [self setLabel:fishNumberLb];
    [fishNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *farmingStewardLb = [[UILabel alloc] init];
    farmingStewardLb.text = @"养殖管家：不知道";
    [self setLabel:farmingStewardLb];
    [farmingStewardLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fishNumberLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *createTimeLb = [[UILabel alloc] init];
    createTimeLb.text = @"创建时间：2017-03-24 21:22:22";
    [self setLabel:createTimeLb];
    [createTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(farmingStewardLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *transactionTimeLb = [[UILabel alloc] init];
    transactionTimeLb.text = @"交易时间：2017-03-24 21:22:22";
    [self setLabel:transactionTimeLb];
    [transactionTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    UILabel *certificateLb = [[UILabel alloc] init];
    certificateLb.text = @"凭证：";
    [self setLabel:certificateLb];
    [certificateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transactionTimeLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(25));
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self createScrollViewWithLabel:certificateLb withPicure:arr];
    
}

- (void)createScrollViewWithLabel:(UILabel *)label withPicure:(NSMutableArray *)arr {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(SCALE_SIZE(10));
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
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

- (void)setLabel:(UILabel *)label {
    label.textColor = RGBHex(0x666666);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = JKFont(12);
    [self.bgView addSubview:label];
}


@end
