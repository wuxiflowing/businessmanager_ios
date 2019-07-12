//
//  JKFarmersVC.m
//  BusinessManager
//
//  Created by  on 2018/6/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFarmersVC.h"
#import "JKFarmerMainVC.h"
#import "JKOperationPersonVC.h"
#import "SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "JKOpenAccountVC.h"
#import "JKFarmerModel.h"
#import "JKContactDataHelper.h"
#import "JKFarmerCell.h"
#import "JKGeneralFarmersVC.h"
#import "JKSearchFarmersVC.h"

@interface JKFarmersVC () <UITableViewDataSource, UITableViewDelegate, JKFarmerCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SCIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *farmerArr;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) UILabel *numLb;
@property (nonatomic, strong) UIImageView *generalImgV;
@property (nonatomic, strong) UILabel *generalTitleLb;
@property (nonatomic, strong) UIImageView *arrowImgV;
@property (nonatomic, strong) SCIndexViewConfiguration *indexViewConfiguration;
@end

@implementation JKFarmersVC
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.backgroundColor = kBgColor;
        _tableView.tableHeaderView = self.topView;
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

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _topView.backgroundColor = kWhiteColor;
    }
    return _topView;
}

- (NSMutableArray *)farmerArr {
    if (!_farmerArr) {
        _farmerArr = [[NSMutableArray alloc] init];
    }
    return _farmerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavigationUI];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
    
    [self dropDownRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createTopViewUI];
}

#pragma mark -- 意向用户
- (void)createTopViewUI {
    [self.generalImgV removeFromSuperview];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"ic_intention_customers"];
    imgV.layer.cornerRadius = 20;
    imgV.layer.masksToBounds = YES;
    [self.topView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.generalImgV = imgV;
    
    [self.generalTitleLb removeFromSuperview];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"意向用户";
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(15);
    [self.topView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(10);
        make.top.bottom.equalTo(imgV);
        make.width.mas_equalTo(100);
    }];
    self.generalTitleLb = titleLb;
    
    [self.arrowImgV removeFromSuperview];
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    arrowImgV.image = [UIImage imageNamed:@"ic_arrow"];
    [self.topView addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
    self.arrowImgV = arrowImgV;
    
    [self.numLb removeFromSuperview];
    UILabel *numLb = [[UILabel alloc] init];
    numLb.textColor = RGBHex(0x333333);
    numLb.textAlignment = NSTextAlignmentRight;
    numLb.font = JKFont(15);
    [self.topView addSubview:numLb];
    [numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.right.equalTo(arrowImgV.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    self.numLb = numLb;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIntentionalUser)];
    [self.topView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark -- 导航栏
- (void)createNavigationUI {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[addItem,searchItem];
}

#pragma mark -- 搜索
- (void)searchBtnClick:(UIButton *)btn {
    JKSearchFarmersVC *sfVC = [[JKSearchFarmersVC alloc] init];
    sfVC.isGeneral = NO;
    [self.navigationController pushViewController:sfVC animated:YES];
}

#pragma mark -- 添加好友
- (void)addBtnClick:(UIButton *)btn {
    JKOpenAccountVC *opVC = [[JKOpenAccountVC alloc] init];
    opVC.isGeneral = NO;
    [self.navigationController pushViewController:opVC animated:YES];
}

#pragma mark -- 意向用户
- (void)clickIntentionalUser {
    JKGeneralFarmersVC *gfVC = [[JKGeneralFarmersVC alloc] init];
    [self.navigationController pushViewController:gfVC animated:YES];
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
    [self getCustomerList];
    [self getGeneralListCount];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- 养殖户列表
- (void)getCustomerList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/contract?name=",kUrl_Base, loginId];

    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.farmerArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                });
                JKFarmerModel *model = [[JKFarmerModel alloc] initWithDic:dict];
                [self.farmerArr addObject:model];
            }
        }

        self.rowArr = [JKContactDataHelper getFriendListDataBy:self.farmerArr];
        self.sectionArr = [JKContactDataHelper getFriendListSectionBy:[self.rowArr mutableCopy]];
        [self.tableView reloadData];

        self.indexViewConfiguration = nil;
        [self.indexView removeFromSuperview];
        SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
        indexViewConfiguration.indexItemTextColor = kThemeColor;
        indexViewConfiguration.indexItemSelectedTextColor = kThemeColor;
        indexViewConfiguration.indexItemSelectedBackgroundColor = RGBHex(0xdddddd);
        SCIndexView *indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
        indexView.dataSource = self.sectionArr;
        [self.view addSubview:indexView];
        self.indexView = indexView;
        self.indexViewConfiguration = indexViewConfiguration;
    
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 获取意向用户数量
- (void)getGeneralListCount {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/general?name=",kUrl_Base, loginId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            if (responseObject[@"total"] == 0) {
                self.numLb.text = @"";
            } else {
                self.numLb.text = [NSString stringWithFormat:@"%@",responseObject[@"total"]];
            }
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- JKFarmerCellDelegate
- (void)callFarmerPhone:(JKFarmerModel *)model {
    NSString *dialSring=[NSString stringWithFormat:@"tel://%@",model.farmerTel];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring]];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rowArr[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBgColor;
    
    UILabel *title = [[UILabel alloc] init];
    title.text = self.sectionArr[section];
    title.textColor = RGBHex(0x333333);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = JKFont(14);
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view).offset(15);
        make.right.equalTo(view).offset(-15);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,indexPath.row];
    JKFarmerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKFarmerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
    [cell createUI:model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
    JKFarmerMainVC *fmVC = [[JKFarmerMainVC alloc] init];
    fmVC.customerIdStr = model.farmerId;
    fmVC.isGeneral = NO;
    [self.navigationController pushViewController:fmVC animated:YES];
}

@end
