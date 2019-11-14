//
//  JKContractFarmersVC.m
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractFarmersVC.h"
#import "SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "UITableView+SCIndexView.h"
#import "JKFarmerModel.h"
#import "JKContactDataHelper.h"
#import "JKContractFarmerCell.h"
#import "JKSigningContractVC.h"

@interface JKContractFarmersVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SCIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *farmerArr;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation JKContractFarmersVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.backgroundColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)farmerArr {
    if (!_farmerArr) {
        _farmerArr = [[NSMutableArray alloc] init];
    }
    return _farmerArr;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入养殖户名称";
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.delegate = self;
    }
    return _searchBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择养殖户";
    
    [self initSearchBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getContractList:@""];
}

#pragma mark -- 导航栏上加搜索框
- (void)initSearchBar {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")]&&view.subviews.count>0) {
            view.backgroundColor = kBgColor;
            if (@available(ios 13.0,*)) {
                [view.subviews objectAtIndex:0].hidden = YES;
            }else{
                [[view.subviews objectAtIndex:0] removeFromSuperview];
            }
            break;
        }
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self getContractList:searchBar.text];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.farmerArr removeAllObjects];
        [self getContractList:@""];
    }
}

- (void)getContractList:(NSString *)name {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/contract?name=%@",kUrl_Base, loginId, name];
    
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
    NSString *identifier = [NSString stringWithFormat:@"JKContractFarmerCell%ld%ld",indexPath.section,indexPath.row];
    JKContractFarmerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKContractFarmerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
    [cell createUI:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contractType == JKContractTypeSign) {
        JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
        JKSigningContractVC *scVC = [[JKSigningContractVC alloc] init];
        scVC.farmerId = model.farmerId;
        scVC.farmerName = model.farmerName;
        scVC.farmerAdd = [NSString stringWithFormat:@"%@%@",model.farmerRegion,model.farmerAdd];
        scVC.farmerTel = model.farmerTel;
        scVC.farmerPic = model.farmerPic;
        
        [self.navigationController pushViewController:scVC animated:YES];
    } else if (self.contractType == JKContractTypeRecyce) {
        JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
        if ([_delegate respondsToSelector:@selector(popContractFarmerId:withFarmerName:withFarmerAddr:withContractInfo:)]) {
            [_delegate popContractFarmerId:model.farmerId withFarmerName:model.farmerName withFarmerAddr:[NSString stringWithFormat:@"%@%@",model.farmerRegion,model.farmerAdd] withContractInfo:model.farmerTel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        JKFarmerModel *model = _rowArr[indexPath.section][indexPath.row];
        if ([_delegate respondsToSelector:@selector(popContractFarmerAddr:withContractInfo:withFarmerName:withFarmerId:)]) {
            [_delegate popContractFarmerAddr:[NSString stringWithFormat:@"%@%@",model.farmerRegion,model.farmerAdd] withContractInfo:model.farmerTel withFarmerName:model.farmerName withFarmerId:model.farmerId];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
