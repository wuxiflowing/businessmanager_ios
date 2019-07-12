//
//  JKFarmerMainView.m
//  BusinessManager
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFarmerMainView.h"
#import "JKFarmerMainCell.h"
#import "JKPondCell.h"
#import "JKPondModel.h"


#define NAVBAR_COLORCHANGE_POINT SCALE_SIZE(-80)
#define IMAGE_HEIGHT 225 + XTopHeight
#define SCROLL_DOWN_LIMIT SCALE_SIZE(0)
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
#define SIGNBTN_Y (SCREEN_HEIGHT == 568.0 ? 30 : 100)

@interface JKFarmerMainView() <UITableViewDelegate, UITableViewDataSource,JKFarmerMainCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *fileBtn;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, strong) NSString *farmerHeadImg;
@property (nonatomic, strong) NSString *contactInfo;
@property (nonatomic, strong) NSString *customerLevel;
@property (nonatomic, strong) NSString *homeAddress;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *idPicture;
@property (nonatomic, strong) NSString *pondPicture;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *credit;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *equipment;
@property (nonatomic, strong) NSString *totalArea;
@property (nonatomic, strong) NSString *advanceCapital;
@property (nonatomic, strong) NSString *arrears;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *sectionTitileArr;
@property (nonatomic, strong) NSMutableArray *activelyArr;
@property (nonatomic, strong) NSMutableArray *boolArr;
@end

@implementation JKFarmerMainView

- (NSMutableArray *)rowNumberArr {
    if (!_rowNumberArr) {
        _rowNumberArr = [[NSMutableArray alloc] init];
    }
    return _rowNumberArr;
}

- (NSMutableArray *)sectionTitileArr {
    if (!_sectionTitileArr) {
        _sectionTitileArr = [[NSMutableArray alloc] init];
    }
    return _sectionTitileArr;
}

- (NSMutableArray *)activelyArr {
    if (!_activelyArr) {
        _activelyArr = [[NSMutableArray alloc] init];
    }
    return _activelyArr;
}

- (NSMutableArray *)boolArr {
    if (!_boolArr) {
        _boolArr = [[NSMutableArray alloc] init];
    }
    return _boolArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
        [self.tableView addSubview:self.topImgV];
        [self addSubview:self.tableView];
        
        [self dropDownRefresh];
    }
    return self;
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 刷新接口
- (void)refreshData {
    [self getCustomerInfo];
    [self getFishRawData];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- 用户基础信息
- (void)getCustomerInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerData",kUrl_Base, self.customerIdStr];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            self.farmerName = responseObject[@"data"][@"name"];
            self.farmerId = responseObject[@"data"][@"farmerId"];
            if ([responseObject[@"data"][@"picture"] isKindOfClass:[NSNull class]]) {
                self.farmerHeadImg = @"";
            } else {
                self.farmerHeadImg = responseObject[@"data"][@"picture"];
            }
            self.contactInfo = responseObject[@"data"][@"contactInfo"];
            self.customerLevel = responseObject[@"data"][@"customerLevel"];
            self.birthday = responseObject[@"data"][@"birthday"];
            self.region = responseObject[@"data"][@"region"];
            self.idNumber = responseObject[@"data"][@"idNumber"];
            self.sex = responseObject[@"data"][@"sex"];
            self.picture = responseObject[@"data"][@"picture"];
            self.idPicture = responseObject[@"data"][@"idPicture"];
            if ([responseObject[@"data"][@"pondPicture"] isKindOfClass:[NSNull class]]) {
                self.pondPicture = @"";
            } else {
                self.pondPicture = responseObject[@"data"][@"pondPicture"];
            }
            
            if ([self.customerLevel isKindOfClass:[NSNull class]]) {
                self.customerLevel = @"0";
            }
            self.homeAddress = responseObject[@"data"][@"homeAddress"];
            self.address = [NSString stringWithFormat:@"%@%@",responseObject[@"data"][@"region"],responseObject[@"data"][@"homeAddress"]];
            self.credit = responseObject[@"data"][@"credit"];
            if ([self.credit isKindOfClass:[NSNull class]]) {
                self.credit = @"0";
            }
            self.integral = responseObject[@"data"][@"integral"];
            if ([self.integral isKindOfClass:[NSNull class]]) {
                self.integral = @"0";
            }
            self.equipment = responseObject[@"data"][@"equipment"];
            if ([self.equipment isKindOfClass:[NSNull class]]) {
                self.equipment = @"0";
            }
            self.totalArea = responseObject[@"data"][@"totalArea"];
            if ([self.totalArea isKindOfClass:[NSNull class]]) {
                self.totalArea = @"0";
            }
            self.advanceCapital = responseObject[@"data"][@"advanceCapital"];
            if ([self.advanceCapital isKindOfClass:[NSNull class]]) {
                self.advanceCapital = @"0";
            }
            self.arrears = responseObject[@"data"][@"arrears"];
            if ([self.arrears isKindOfClass:[NSNull class]]) {
                self.arrears = @"0";
            }
            [self reloadTopViewInfo];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 鱼塘设备状态列表
- (void)getFishRawData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"0" forKey:@"startTime"];
    [params setObject:@"0" forKey:@"endTime"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/pondData",kUrl_Base, self.customerIdStr];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.sectionTitileArr removeAllObjects];
            [self.rowNumberArr removeAllObjects];
            [self.boolArr removeAllObjects];
            [self.activelyArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.area = dict[@"area"];
                pModel.fishVariety = dict[@"fishVariety"];
                pModel.fryNumber = dict[@"fryNumber"];
                pModel.name = dict[@"name"];
                pModel.phoneNumber = dict[@"phoneNumber"];
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.putInDate = dict[@"putInDate"];
                if ([[NSString stringWithFormat:@"%@",dict[@"reckonSaleDate"]] isEqualToString:@"<null>"]) {
                    pModel.reckonSaleDate = @"";
                } else {
                    pModel.reckonSaleDate = dict[@"reckonSaleDate"];
                }
                pModel.region = dict[@"region"];
                pModel.childDeviceList = dict[@"childDeviceList"];
                [self.sectionTitileArr addObject:pModel];
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                NSMutableArray *activelyArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dict[@"childDeviceList"]) {
                    JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                    pcdModel.alarmType = dic[@"alarmType"];
                    pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                    pcdModel.automatic = dic[@"automatic"];
                    pcdModel.dissolvedOxygen = dic[@"dissolvedOxygen"];
                    pcdModel.enabled = dic[@"enabled"];
                    pcdModel.deviceId = dic[@"id"];
                    pcdModel.ident = dic[@"identifier"];
                    pcdModel.name = dic[@"name"];
                    pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                    pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                    pcdModel.ph = dic[@"ph"];
                    pcdModel.scheduled = dic[@"scheduled"];
                    pcdModel.temperature = dic[@"temperature"];
                    pcdModel.type = dic[@"type"];
                    pcdModel.workStatus = dic[@"workStatus"];
                    NSArray *aeratorControls = dic[@"aeratorControlList"];
                    if (aeratorControls != nil && ![aeratorControls isKindOfClass:[NSNull class]] && aeratorControls.count != 0) {
                        pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                        pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                    }
                    [arr addObject:pcdModel];
                }
                [self.activelyArr addObject:activelyArr];
                [self.rowNumberArr addObject:arr];
                [self.boolArr addObject:@YES];
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)reloadTopViewInfo {
    [self createUserInfoUI];
}

- (void)createUserInfoUI {
    for (UIView *view in self.topImgV.subviews) {
        [view removeFromSuperview];
    }
    [self.topImgV addSubview:self.fileBtn];
    
    UIImageView *headImgV = [[UIImageView alloc] init];
    if (self.farmerHeadImg.length == 0) {
        headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    } else {
        headImgV.yy_imageURL = [NSURL URLWithString:self.farmerHeadImg];
    }
    headImgV.layer.cornerRadius = 30;
    headImgV.layer.masksToBounds = YES;
    [self.topImgV addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImgV.mas_top).offset(SafeAreaTopHeight + SCALE_SIZE(15));
        make.left.equalTo(self.topImgV.mas_left).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *titleLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",self.farmerName] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",self.farmerName] isEqualToString:@"<null>"]) {
        titleLb.text = @"";
    } else {
        titleLb.text = self.farmerName;
    }
    titleLb.textColor = kWhiteColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.numberOfLines = 1;
    [self.topImgV addSubview:titleLb];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    CGSize textSize = [titleLb.text boundingRectWithSize:CGSizeMake((SCREEN_WIDTH -70)/2, 21) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgV.mas_bottom).offset(SCALE_SIZE(10));
        make.left.equalTo(headImgV.mas_left);
        make.size.mas_equalTo(CGSizeMake(textSize.width+10, 21));
    }];
    
    UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    levelBtn.titleLabel.font = JKFont(10);
    [levelBtn setTitle:[NSString stringWithFormat:@"Lv.%@",self.customerLevel] forState:UIControlStateNormal];
    [levelBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [levelBtn setBackgroundImage:[UIImage imageNamed:@"ic_level_bg"] forState:UIControlStateNormal];
    [self.topImgV addSubview:levelBtn];
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb.mas_centerY);
        make.left.equalTo(titleLb.mas_right);
        make.size.mas_equalTo(CGSizeMake(40, 21));
    }];
    
    UIImageView *fCallImgV = [[UIImageView alloc] init];
    fCallImgV.image = [UIImage imageNamed:@"ic_farmer_call"];
    [self.topImgV addSubview:fCallImgV];
    [fCallImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(SCALE_SIZE(10));
        make.left.equalTo(titleLb.mas_left);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = self.contactInfo;
    phoneLb.textColor = kWhiteColor;
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(14);
    phoneLb.userInteractionEnabled = YES;
    
    [self.topImgV addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fCallImgV.mas_centerY);
        make.left.equalTo(fCallImgV.mas_right).offset(5);
        make.right.equalTo(self.topImgV.mas_right).offset(-15);
        make.height.mas_equalTo(21);
    }];
    self.titleLb = titleLb;
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneLb addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(phoneLb);
    }];

    UIImageView *addrImgV = [[UIImageView alloc] init];
    addrImgV.image = [UIImage imageNamed:@"ic_addr"];
    [self.topImgV addSubview:addrImgV];
    [addrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCallImgV.mas_bottom).offset(15);
        make.left.equalTo(fCallImgV.mas_left);
        make.size.mas_equalTo(CGSizeMake(11, 14));
    }];
    
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.text = self.address;
    addrLb.textColor = kWhiteColor;
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(14);
    addrLb.numberOfLines = 2;
//    addrLb.adjustsFontSizeToFitWidth = YES;
    addrLb.userInteractionEnabled = YES;
    [self.topImgV addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addrImgV.mas_centerY);
        make.left.equalTo(addrImgV.mas_right).offset(5);
        make.right.equalTo(self.topImgV.mas_right).offset(-15);
        make.height.mas_equalTo(35);
    }];

    UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addrBtn addTarget:self action:@selector(addrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addrLb addSubview:addrBtn];
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(addrLb);
    }];
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.25];
    [self.topImgV addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImgV.mas_centerY);
        make.right.equalTo(self.topImgV.mas_right);
        make.size.mas_equalTo(CGSizeMake(100, 45));
    }];
    
    UILabel *creditScoreLb = [[UILabel alloc] init];
    creditScoreLb.text = @"信用分";
    creditScoreLb.textColor = kWhiteColor;
    creditScoreLb.textAlignment = NSTextAlignmentLeft;
    creditScoreLb.font = JKFont(13);
    [infoView addSubview:creditScoreLb];
    [creditScoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.mas_top).offset(2);
        make.left.equalTo(infoView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
    
    UILabel *creditScoreValueLb = [[UILabel alloc] init];
    creditScoreValueLb.text = [NSString stringWithFormat:@"%@",self.credit];
    creditScoreValueLb.textColor = RGBHex(0x4d9cf5);
    creditScoreValueLb.textAlignment = NSTextAlignmentLeft;
    creditScoreValueLb.font = JKFont(13);
    [infoView addSubview:creditScoreValueLb];
    [creditScoreValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.mas_top).offset(2);
        make.left.equalTo(infoView.mas_centerX).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
    
    UILabel *integralLb = [[UILabel alloc] init];
    integralLb.text = @"积分";
    integralLb.textColor = kWhiteColor;
    integralLb.textAlignment = NSTextAlignmentLeft;
    integralLb.font = JKFont(13);
    [infoView addSubview:integralLb];
    [integralLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoView.mas_bottom).offset(-2);
        make.left.equalTo(infoView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
    
    UILabel *integralValueLb = [[UILabel alloc] init];
    integralValueLb.text = self.integral;
    integralValueLb.textColor = RGBHex(0x4d9cf5);
    integralValueLb.textAlignment = NSTextAlignmentLeft;
    integralValueLb.font = JKFont(13);
    [infoView addSubview:integralValueLb];
    [integralValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoView.mas_bottom).offset(-2);
        make.left.equalTo(infoView.mas_centerX).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 23));
    }];
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        [self changeNavBarAnimateWithIsClear:NO];
    }
    else
    {
        [self changeNavBarAnimateWithIsClear:YES];
    }

    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }

    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT + IMAGE_HEIGHT) {
        self.topImgV.frame = CGRectMake(0, newOffsetY, SCREEN_WIDTH, -newOffsetY);
    }
}

- (void)changeNavBarAnimateWithIsClear:(BOOL)isClear {
    if ([_delegate respondsToSelector:@selector(scrollNavigationBarWithTitle:withIsClear:)]) {
        [_delegate scrollNavigationBarWithTitle:self.titleLb.text withIsClear:isClear];
    }
}

#pragma mark -- 基础信息
- (void)fileBtnClick:(UIButton *)btn {
    if (!_isGeneral) {
        if ([_delegate respondsToSelector:@selector(clickFileBtn:)]) {
            [_delegate clickFileBtn:btn];
        }
    }
}

#pragma mark -- 拨打电话
- (void)phoneBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(callFarmerPhone:)]) {
        [_delegate callFarmerPhone:self.contactInfo];
    }
}

#pragma mark -- 地址
- (void)addrBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(farmerAddr:)]) {
        [_delegate farmerAddr:self.address];
    }
}

#pragma mark -- 设备详情
- (void)pushDeviceInfoVC:(NSString *)deviceId {
    if ([_delegate respondsToSelector:@selector(pushDevicesInfoVC:)]) {
        [_delegate pushDevicesInfoVC:deviceId];
    }
}

#pragma mark -- 鱼塘详情
- (void)pushPondInfoVC:(JKPondModel *)model {
    if ([_delegate respondsToSelector:@selector(pushPondsInfoVC:)]) {
        [_delegate pushPondsInfoVC:model];
    }
}

#pragma mark -- 成为签约用户
- (void)signBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(clickSignBtnWithFarmerId:withFarmerName:withContractInfo:withBirthday:withSex:withRegion:withHomeAddress:withIDNumber:withIdPicture:withPicture:withPondPicture:)]) {
        [_delegate clickSignBtnWithFarmerId:self.farmerId withFarmerName:self.farmerName withContractInfo:self.contactInfo withBirthday:self.birthday withSex:self.sex withRegion:self.region withHomeAddress:self.homeAddress withIDNumber:self.idNumber withIdPicture:self.idPicture withPicture:self.picture withPondPicture:self.pondPicture];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isGeneral) {
        return 2;
    } else {
        return self.sectionTitileArr.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.isGeneral) {
            return 1;
        } else {
            if ([self.boolArr[section - 1] boolValue] == NO) {
                return 0;
            }else {
                return [self.rowNumberArr[section - 1] count];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else {
        if (self.rowNumberArr.count != 0) {
            NSInteger count = [self.rowNumberArr[indexPath.section - 1] count];
            if (indexPath.row == (count - 1) ) {
                return 316;
            } else {
                return 306;
            }
        } else {
            return 200;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isGeneral) {
        return SIGNBTN_Y;
    } else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isGeneral) {
        if (section == 0) {
            return 0.1;
        } else {
            return 0.1;
        }
    } else {
        if (section == 0) {
            return 0.1;
        } else {
            return 51;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isGeneral) {
        return nil;
    } else {
        if (section != 0) {
            //创建headerView
            UIView *headerView = [[UIView alloc] init];
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51);
            headerView.tag = 10 + section;
            headerView.backgroundColor = kWhiteColor;
            
            //分割线
            UILabel *horizontalLineLb = [[UILabel alloc] init];
            horizontalLineLb.backgroundColor = kBgColor;
            [headerView addSubview:horizontalLineLb];
            [horizontalLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top);
                make.left.right.equalTo(headerView);
                make.height.mas_equalTo(1);
            }];
            
            // 默认组是没有删除组的
            JKPondModel *model = self.sectionTitileArr[section - 1];
            //标题
            UILabel *titleLb = [[UILabel alloc] init];
            titleLb.text = model.name;
            titleLb.numberOfLines = 1;
            titleLb.font = JKFont(17);
            [headerView addSubview:titleLb];
            CGSize size = CGSizeMake(50,50); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: titleLb.font};
            CGSize labelsize = [titleLb.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top);
                make.left.equalTo(headerView.mas_left).offset(15);
                if (labelsize.width > (SCREEN_WIDTH - 50)) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 50));
                } else {
                    make.size.mas_equalTo(CGSizeMake(labelsize.width + 10, 50));
                }
            }];
            
            //箭头
            UIImageView *arrowImgV = [[UIImageView alloc] init];
            arrowImgV.image = [self.boolArr[section - 1] boolValue] ? [UIImage imageNamed:@"ic_arrow_up"] : [UIImage imageNamed:@"ic_arrow_down"];
            [headerView addSubview:arrowImgV];
            [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView.mas_centerY);
                make.right.equalTo(headerView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(20, 10));
            }];
            
            //添加轻扣手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
            [headerView addGestureRecognizer:tap];
            
            return headerView;
        } else {
            return nil;
        }
    }
}

- (void)extracted:(JKFarmerMainCell *)cell model:(JKPondChildDeviceModel *)model pModel:(JKPondModel *)pModel {
    [cell configCellWithModel:model withPondModel:pModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"JKPondCell";
        JKPondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[JKPondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        if (self.equipment != nil && self.totalArea != nil && self.advanceCapital != nil && self.arrears!= nil) {
            cell.infoNumberArr = @[self.equipment, self.totalArea, self.advanceCapital, self.arrears];
            [cell createUI];
        }

        return cell;
    } else {
        if (self.isGeneral) {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kBgColor;
            }

            UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [signBtn setTitle:@"成为签约用户" forState:UIControlStateNormal];
            [signBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            signBtn.titleLabel.font = JKFont(16);
            signBtn.layer.cornerRadius = 4;
            signBtn.layer.masksToBounds = YES;
            [signBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
            [signBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
            [signBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            signBtn.tag = [self.farmerId integerValue];
            [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:signBtn];
            [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.centerX.equalTo(cell.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 40));
            }];

            return cell;
        } else {
            NSString *cellIdentifier = @"JKFarmerMainCell";
            JKFarmerMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[JKFarmerMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kBgColor;
            } else {
                while ([cell.contentView.subviews lastObject] != nil) {
                    [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            if (self.rowNumberArr.count != 0) {
                if (indexPath.row < [self.rowNumberArr[indexPath.section - 1] count]) {
                    JKPondModel *pModel = self.sectionTitileArr[indexPath.section - 1];
                    JKPondChildDeviceModel *model = self.rowNumberArr[indexPath.section - 1][indexPath.row];
                    [self extracted:cell model:model pModel:pModel];
                }
            }
            cell.delegate = self;
            return cell;
        }
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark -- UITapGestureRecognizer点击事件
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    //获取section
    NSInteger section = tap.view.tag - 10;
    //判断改变bool值
    if ([self.boolArr[section - 1] boolValue] == YES) {
        [self.boolArr replaceObjectAtIndex:(section - 1) withObject:@NO];
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        self.topImgV.frame = CGRectMake(0, -IMAGE_HEIGHT-statusRect.size.height, SCREEN_WIDTH, IMAGE_HEIGHT);
    }else {
        [self.boolArr replaceObjectAtIndex:(section - 1) withObject:@YES];
    }
    //刷新某个section
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIImageView *)topImgV {
    if (!_topImgV) {
        _topImgV = [[UIImageView alloc] init];
        _topImgV.frame = CGRectMake(0, -IMAGE_HEIGHT, SCREEN_WIDTH, IMAGE_HEIGHT);
        _topImgV.contentMode = UIViewContentModeScaleToFill;
        _topImgV.clipsToBounds = YES;
        _topImgV.image = [self imageWithImageSimple:[UIImage imageNamed:@"ic_farmer_bg"] scaledToSize:CGSizeMake(SCREEN_WIDTH, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
        _topImgV.userInteractionEnabled = YES;
    }
    return _topImgV;
}

- (UIButton *)fileBtn {
    if (!_fileBtn) {
        _fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fileBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT-70);
        [_fileBtn addTarget:self action:@selector(fileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fileBtn;
}

@end
