//
//  JKBasicFileVC.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBasicFileVC.h"
#import "XHStarRateView.h"

@interface JKBasicFileVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UILabel *scoreLb;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *attachmentPictureLb;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *customerLevel;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *advanceCapital;
@property (nonatomic, strong) NSString *arrears;
@property (nonatomic, strong) NSString *arrearsQuota;
@property (nonatomic, strong) NSString *pondNumber;
@property (nonatomic, strong) NSString *equipment;
@property (nonatomic, strong) NSString *totalArea;
@property (nonatomic, strong) NSString *contactInfo;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *openAccountDate;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *idPicture;
@property (nonatomic, strong) NSString *registerPicture;

@end

@implementation JKBasicFileVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基础信息";
    
    self.titleArr = @[@"农户姓名", @"信用等级", @"积分", @"预付款", @"欠款", @"欠款额度", @"鱼塘数量", @"总设备", @"面积", @"联系方式", @"出生日期", @"性别", @"身份证号", @"开户时间", @"附件图片"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self dropDownRefresh];
    
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
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- 用户基础信息
- (void)getCustomerInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerData",kUrl_Base, self.customerIdStr];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            self.name = responseObject[@"data"][@"name"];
            self.customerLevel = responseObject[@"data"][@"customerLevel"];
            self.integral = responseObject[@"data"][@"integral"];
            self.advanceCapital = responseObject[@"data"][@"advanceCapital"];
            self.arrears = responseObject[@"data"][@"arrears"];
            self.arrearsQuota = responseObject[@"data"][@"arrearsQuota"];
            self.pondNumber = responseObject[@"data"][@"pondNumber"];
            self.equipment = responseObject[@"data"][@"equipment"];
            self.totalArea = responseObject[@"data"][@"totalArea"];
            self.contactInfo = responseObject[@"data"][@"contactInfo"];
            self.birthday = responseObject[@"data"][@"birthday"];
            self.sex = responseObject[@"data"][@"sex"];
            self.idNumber = responseObject[@"data"][@"idNumber"];
            self.openAccountDate = responseObject[@"data"][@"openAccountDate"];
            self.picture = responseObject[@"data"][@"picture"];
            self.idPicture = responseObject[@"data"][@"idPicture"];
            self.registerPicture = responseObject[@"data"][@"registerPicture"];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titleArr.count - 1) {
        return 180;
    } else {
        return SCALE_SIZE(50);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(14);
    
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.name;
    } else if (indexPath.row == 1) {
        XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 145, SCALE_SIZE(25)-7.5, 100, 15) numberOfStars:5 rateStyle:HalfStar isAnination:YES finish:^(CGFloat currentScore) {
        }];
//        starRateView.currentScore = [self.customerLevel integerValue];
        starRateView.currentScore = 0;
        [cell.contentView addSubview:starRateView];
        
        [self.scoreLb removeFromSuperview];
        UILabel *scoreLb = [[UILabel alloc] init];
        scoreLb.text = [NSString stringWithFormat:@"%@",self.customerLevel];
        scoreLb.textColor = RGBHex(0x999999);
        scoreLb.textAlignment = NSTextAlignmentRight;
        scoreLb.font = JKFont(14);
        [cell.contentView addSubview:scoreLb];
        [scoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
            make.width.mas_equalTo(30);
        }];
        self.scoreLb = scoreLb;
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.integral];
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.advanceCapital];
    } else if (indexPath.row == 4) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.arrears];
    } else if (indexPath.row == 5) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.arrearsQuota];
    } else if (indexPath.row == 6) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@个",self.pondNumber];
    } else if (indexPath.row == 7) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@套",self.equipment];
    } else if (indexPath.row == 8) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@亩",self.totalArea];
    } else if (indexPath.row == 9) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.contactInfo];
    } else if (indexPath.row == 10) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.birthday];
    } else if (indexPath.row == 11) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.sex];
    } else if (indexPath.row == 12) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.idNumber];
    } else if (indexPath.row == 13) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.openAccountDate];
    } else if (indexPath.row == 14) {
        cell.textLabel.text = nil;
        [self.attachmentPictureLb removeFromSuperview];
        UILabel *attachmentPictureLb = [[UILabel alloc] init];
        attachmentPictureLb.text = @"附件图片";
        attachmentPictureLb.textColor = RGBHex(0x333333);
        attachmentPictureLb.textAlignment = NSTextAlignmentLeft;
        attachmentPictureLb.font = JKFont(14);
        [cell.contentView addSubview:attachmentPictureLb];
        [attachmentPictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(SCALE_SIZE(12));
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.height.mas_equalTo(30);
        }];
        self.attachmentPictureLb = attachmentPictureLb;
        
        [cell.contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(attachmentPictureLb.mas_bottom).offset(SCALE_SIZE(12));
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        NSString *pictureStr = [NSString stringWithFormat:@"%@,%@",self.idPicture,self.registerPicture];
        NSArray *pictureArr = [pictureStr componentsSeparatedByString:@","];
        
        self.scrollView.contentSize = CGSizeMake(90 *6, 80);
        
        for (NSInteger i = 0; i < pictureArr.count; i++) {
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.frame = CGRectMake(90 * i , 0, 80, 80);
            imgV.userInteractionEnabled = YES;
            imgV.yy_imageURL = [NSURL URLWithString:pictureArr[i]];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [self.scrollView addSubview:imgV];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(0 , 0, 110, 110);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn];
        }
        
        
    }
    cell.detailTextLabel.textColor = RGBHex(0x999999);
    cell.detailTextLabel.font = JKFont(14);

    return cell;
}

- (void)btnClick:(UIButton *)btn {
    NSString *pictureStr = [NSString stringWithFormat:@"%@,%@",self.idPicture,self.registerPicture];
    NSArray *pictureArr = [pictureStr componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:pictureArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

@end
