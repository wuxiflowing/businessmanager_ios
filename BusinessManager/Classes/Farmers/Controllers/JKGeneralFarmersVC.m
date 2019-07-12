//
//  JKGeneralFarmersVC.m
//  BusinessManager
//
//  Created by  on 2018/8/10.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKGeneralFarmersVC.h"
#import "JKOperationPersonVC.h"
#import "SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "JKFarmerModel.h"
#import "JKContactDataHelper.h"
#import "JKFarmerCell.h"
#import "JKSearchFarmersVC.h"
#import "JKFarmerMainVC.h"

@interface JKGeneralFarmersVC () <UITableViewDataSource, UITableViewDelegate, JKFarmerCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SCIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *farmerArr;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@end

@implementation JKGeneralFarmersVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.backgroundColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)farmerArr {
    if (!_farmerArr) {
        _farmerArr = [[NSMutableArray alloc] init];
    }
    return _farmerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"意向用户";
    
    [self createNavigationUI];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self dropDownRefresh];
    [self refreshData];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
//    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 刷新接口
- (void)refreshData {
    [self getGeneralList];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- 导航栏
- (void)createNavigationUI {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark -- 搜索
- (void)searchBtnClick:(UIButton *)btn {
    JKSearchFarmersVC *sfVC = [[JKSearchFarmersVC alloc] init];
    sfVC.isGeneral = YES;
    [self.navigationController pushViewController:sfVC animated:YES];
}

- (void)getGeneralList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/general?name=",kUrl_Base, loginId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.farmerArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKFarmerModel *model = [[JKFarmerModel alloc] initWithDic:dict];
                [self.farmerArr addObject:model];
            }
        }

        self.rowArr = [JKContactDataHelper getFriendListDataBy:self.farmerArr];
        self.sectionArr = [JKContactDataHelper getFriendListSectionBy:[self.rowArr mutableCopy]];
        [self.tableView reloadData];

        SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
        indexViewConfiguration.indexItemTextColor = kThemeColor;
        indexViewConfiguration.indexItemSelectedTextColor = kThemeColor;
        indexViewConfiguration.indexItemSelectedBackgroundColor = RGBHex(0xdddddd);
        SCIndexView *indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
        indexView.dataSource = self.sectionArr;
        [self.view addSubview:indexView];
        
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
    NSString *identifier = [NSString stringWithFormat:@"JKFarmerCell%ld%ld",indexPath.section,indexPath.row];
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
    fmVC.isGeneral = YES;
    [self.navigationController pushViewController:fmVC animated:YES];
}


@end
