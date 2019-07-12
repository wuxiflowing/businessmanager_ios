//
//  JKChooseRecyceDeviceVC.m
//  BusinessManager
//
//  Created by  on 2018/10/16.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKChooseRecyceDeviceVC.h"
#import "JKPondModel.h"
#import "JKChooseRecyceDeviceCell.h"
#import "JKChooseOperationPeoplesVC.h"

@interface JKChooseRecyceDeviceVC () <UITableViewDelegate, UITableViewDataSource, JKChooseRecyceDeviceCellDelegate, JKChooseOperationPeoplesVCDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) JKChooseRecyceDeviceCell *crdCell;
@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) NSMutableArray *childArr;
@end

@implementation JKChooseRecyceDeviceVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)rowNumberArr {
    if (!_rowNumberArr) {
        _rowNumberArr = [[NSMutableArray alloc] init];
    }
    return _rowNumberArr;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] init];
    }
    return _selectArr;
}

//- (NSMutableArray *)childArr {
//    if (!_childArr) {
//        _childArr = [[NSMutableArray alloc] init];
//    }
//    return _childArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择回收设备";
    
    self.index = 0;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    [self getFishRawData];
}

#pragma mark -- 鱼塘设备状态列表
- (void)getFishRawData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"0" forKey:@"startTime"];
    [params setObject:@"0" forKey:@"endTime"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/pondData",kUrl_Base, self.famerId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.name = dict[@"name"];
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.maintainKeeper = dict[@"maintainKeeper"];
                pModel.maintainKeeperID = dict[@"maintainKeeperID"];
                NSArray *childDeviceList = dict[@"childDeviceList"];

                NSMutableArray *childDeviceInfoList = [[NSMutableArray alloc] init];
                if (childDeviceList.count != 0) {
                    for (NSDictionary *dic in childDeviceList) {
                        BOOL isSelected = NO;
                        NSString *ident = dic[@"identifier"];
                        NSString *deviceId = dic[@"id"];
                        NSString *type = dic[@"type"];
                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                        [params setObject:ident forKey:@"identifier"];
                        [params setObject:deviceId forKey:@"id"];
                        [params setObject:type forKey:@"type"];
                        [params setObject:@(isSelected) forKey:@"isSelected"];
                        [childDeviceInfoList addObject:params];
                    }
                    pModel.childDeviceList = [childDeviceInfoList copy];
                    [self.dataSource addObject:pModel];
                }
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 确定
- (void)save:(UIButton *)btn {
    [self.selectArr removeAllObjects];
    for (JKPondModel *model in self.dataSource) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSMutableArray *childArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in model.childDeviceList) {
            if ([dict[@"isSelected"] boolValue]) {
                [childArr addObject:dict];
            }
        }
        
        if (childArr.count != 0) {
            [params setObject:model.maintainKeeperID forKey:@"maintainKeeperID"];
            [params setObject:model.name forKey:@"name"];
            [params setObject:model.pondId forKey:@"pondId"];
            [params setObject:model.pondAddress forKey:@"pondAddress"];
            [params setObject:model.maintainKeeper forKey:@"maintainKeeper"];
            [params setObject:childArr forKey:@"childDeviceList"];
            [self.selectArr addObject:params];
        }
    }
    
    if (self.selectArr.count == 0) {
        [YJProgressHUD showMessage:@"请选择回收设备" inView:self.view];
        return;
    }

    if ([_delegate respondsToSelector:@selector(saveSelectArr:)]) {
        [_delegate saveSelectArr:self.selectArr];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMaintainKeeper:(NSInteger)tag {
    JKChooseOperationPeoplesVC *copVC = [[JKChooseOperationPeoplesVC alloc] init];
    copVC.tag = tag;
    copVC.delegate = self;
    [self.navigationController pushViewController:copVC animated:YES];
}

- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName withTag:(NSInteger)tag {
    JKPondModel *pModel = self.dataSource[tag];
    pModel.maintainKeeper = memName;
    pModel.maintainKeeperID = memId;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)changeBtnState:(NSInteger)tag withIndex:(NSInteger)index withSelected:(BOOL)isSelected {
    JKPondModel *model = self.dataSource[index];
    NSMutableDictionary *dict = model.childDeviceList[tag];
    dict[@"isSelected"] = @(isSelected);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKPondModel *pModel = self.dataSource[indexPath.row];
    return 48 * 2 + pModel.childDeviceList.count * 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    JKChooseRecyceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[JKChooseRecyceDeviceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKPondModel *model = self.dataSource[indexPath.row];
    [cell sendPondModel:model];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

@end
