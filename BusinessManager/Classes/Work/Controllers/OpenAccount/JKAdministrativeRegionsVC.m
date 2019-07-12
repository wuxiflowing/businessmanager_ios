//
//  JKAdministrativeRegionsVC.m
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKAdministrativeRegionsVC.h"
#import "JKAreaModel.h"

@interface JKAdministrativeRegionsVC () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _btnWidth;
    NSInteger _selectedTag; //区分省市区
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *provinceBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *districtBtn;
@property (nonatomic, strong) UIButton *townBtn;
@property (nonatomic, strong) NSString *provinceStr;
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSString *districtStr;
@property (nonatomic, strong) NSString *townStr;
@property (nonatomic, strong) UIView *topView;
@end

@implementation JKAdministrativeRegionsVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kBgColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIButton *)provinceBtn {
    if (!_provinceBtn) {
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_provinceBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _provinceBtn.titleLabel.font = JKFont(16);
        _provinceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_provinceBtn addTarget:self action:@selector(provinceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _provinceBtn;
}

- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_cityBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = JKFont(16);
        _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityBtn;
}

- (UIButton *)districtBtn {
    if (!_districtBtn) {
        _districtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_districtBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _districtBtn.titleLabel.font = JKFont(16);
        _districtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_districtBtn addTarget:self action:@selector(districtBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _districtBtn;
}

- (UIButton *)townBtn {
    if (!_townBtn) {
        _townBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_townBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_townBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _townBtn.titleLabel.font = JKFont(16);
        _townBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_townBtn addTarget:self action:@selector(townBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _townBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"行政区域";
    self.view.backgroundColor = kBgColor;
    
    _selectedTag = 0;//默认省
    
    _btnWidth = (SCREEN_WIDTH - 30) / 4;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kBgColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    self.topView = topView;
    
    [self.topView addSubview:self.provinceBtn];
    [self.provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(_btnWidth, 30));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self getAreaList:@"PROV"];
}

#pragma mark -- 省市区镇列表
- (void)getAreaList:(NSString *)areaTypeID {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/%@/areaList",kUrl_Base,areaTypeID];
    
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                if (_selectedTag == 0) {
                    JKProvinceModel *model = [[JKProvinceModel alloc] init];
                    model.pName = dict[@"name"];
                    model.pId = dict[@"id"];
                    [self.dataSource addObject:model];
                } else if (_selectedTag == 1) {
                    JKCityModel *model = [[JKCityModel alloc] init];
                    model.cName = dict[@"name"];
                    model.cId = dict[@"id"];
                    [self.dataSource addObject:model];
                } else if (_selectedTag == 2) {
                    JKDistrictModel *model = [[JKDistrictModel alloc] init];
                    model.dName = dict[@"name"];
                    model.dId = dict[@"id"];
                    [self.dataSource addObject:model];
                } else if (_selectedTag == 3) {
                    JKTownModel *model = [[JKTownModel alloc] init];
                    model.tName = dict[@"name"];
                    model.tId = dict[@"id"];
                    [self.dataSource addObject:model];
                }
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 省点击
- (void)provinceBtnClick:(UIButton *)btn {
    [self getAreaList:@"PROV"];
    _selectedTag = 0;
}

#pragma mark -- 市点击
- (void)cityBtnClick:(UIButton *)btn {
    [self getAreaList:self.provinceStr];
    _selectedTag = 1;
}

#pragma mark -- 区点击
- (void)districtBtnClick:(UIButton *)btn {
    [self getAreaList:self.cityStr];
    _selectedTag = 2;
}

#pragma mark -- 镇点击
- (void)townBtnClick:(UIButton *)btn {
    [self getAreaList:self.districtStr];
    _selectedTag = 3;
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_selectedTag == 0) {
        JKProvinceModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.pName;
    } else if (_selectedTag == 1) {
        JKCityModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.cName;
    } else if (_selectedTag == 2) {
        JKDistrictModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.dName;
    } else if (_selectedTag == 3) {
        JKTownModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.tName;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedTag == 0) {
        JKProvinceModel *model = self.dataSource[indexPath.row];
        [self getAreaList:model.pId];
        self.provinceStr = model.pId;
        [self.provinceBtn setTitle:model.pName forState:UIControlStateNormal];
        [self.provinceBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        
        [self.cityBtn removeFromSuperview];
        self.cityBtn = nil;
        [self.districtBtn removeFromSuperview];
        self.districtBtn = nil;
        [self.townBtn removeFromSuperview];
        self.townBtn = nil;
        
        [self.topView addSubview:self.cityBtn];
        [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self.provinceBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(_btnWidth, 30));
        }];
        _selectedTag = 1;
    } else if (_selectedTag == 1) {
        JKCityModel *model = self.dataSource[indexPath.row];
        [self getAreaList:model.cId];
        self.cityStr = model.cId;
        [self.cityBtn setTitle:model.cName forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];

        [self.districtBtn removeFromSuperview];
        self.districtBtn = nil;
        [self.townBtn removeFromSuperview];
        self.townBtn = nil;
        
        [self.topView addSubview:self.districtBtn];
        [self.districtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self.cityBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(_btnWidth, 30));
        }];
        _selectedTag = 2;
    } else if (_selectedTag == 2) {
        JKDistrictModel *model = self.dataSource[indexPath.row];
        [self getAreaList:model.dId];
        self.districtStr = model.dId;
        [self.districtBtn setTitle:model.dName forState:UIControlStateNormal];
        [self.districtBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        
        [self.townBtn removeFromSuperview];
        self.townBtn = nil;
        
        [self.topView addSubview:self.townBtn];
        [self.townBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self.districtBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(_btnWidth, 30));
        }];
        _selectedTag = 3;
    } else if (_selectedTag == 3) {
        JKTownModel *model = self.dataSource[indexPath.row];
        self.townStr = model.tId;
        [self.townBtn setTitle:model.tName forState:UIControlStateNormal];
        
        NSString *regionStr = [NSString stringWithFormat:@"%@%@%@%@",
                            self.provinceBtn.titleLabel.text,
                            self.cityBtn.titleLabel.text,
                            self.districtBtn.titleLabel.text,
                            self.townBtn.titleLabel.text];
        if ([_delegate respondsToSelector:@selector(popRegion:withTownId:)]) {
            [_delegate popRegion:regionStr withTownId:self.townStr];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
