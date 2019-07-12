//
//  JKSearchFarmersVC.m
//  BusinessManager
//
//  Created by  on 2018/8/10.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKSearchFarmersVC.h"
#import "JKFarmerModel.h"
#import "JKFarmerCell.h"
#import "JKFarmerMainVC.h"

@interface JKSearchFarmersVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, JKFarmerCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *farmerArr;

@end

@implementation JKSearchFarmersVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入搜索内容";
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (NSMutableArray *)farmerArr {
    if (!_farmerArr) {
        _farmerArr = [[NSMutableArray alloc] init];
    }
    return _farmerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isGeneral) {
        self.title = @"搜索意向用户";
    } else {
        self.title = @"搜索养殖户";
    }
    
    [self initSearchBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    if (self.farmerArr.count == 0) {
        [self createEmptyImgV];
    } else {
        [self.imgV removeFromSuperview];
        [self.titleLb removeFromSuperview];
    }
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
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self getCustomerList:searchBar.text];
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
        if (self.farmerArr.count == 0) {
            [self createEmptyImgV];
        } else {
            [self.imgV removeFromSuperview];
            [self.titleLb removeFromSuperview];
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- 养殖户列表
- (void)getCustomerList:(NSString *)keyword {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr;
    if (self.isGeneral) {
        urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/general?name=%@",kUrl_Base, loginId, keyword];
    } else {
        urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/customerList/contract?name=%@",kUrl_Base, loginId, keyword];
    }
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.farmerArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKFarmerModel *model = [[JKFarmerModel alloc] initWithDic:dict];
                [self.farmerArr addObject:model];
            }
            
            if (self.farmerArr.count == 0) {
                [self createEmptyImgV];
            } else {
                [self.imgV removeFromSuperview];
                [self.titleLb removeFromSuperview];
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- JKFarmerCellDelegate
- (void)callFarmerPhone:(JKFarmerModel *)model {
    NSLog(@"%@",model.farmerTel);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.farmerArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"JKFarmerCell";
    JKFarmerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKFarmerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.subviews lastObject] != nil) {
            [(UIView *)[cell.subviews lastObject] removeFromSuperview];
        }
    }
    
    JKFarmerModel *model = self.farmerArr[indexPath.row];
    [cell createUI:model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKFarmerModel *model = self.farmerArr[indexPath.row];
    JKFarmerMainVC *fmVC = [[JKFarmerMainVC alloc] init];
    fmVC.customerIdStr = model.farmerId;
    fmVC.isGeneral = self.isGeneral;
    [self.navigationController pushViewController:fmVC animated:YES];
}


@end
