//
//  JKChooseOperationPeoplesVC.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKChooseOperationPeoplesVC.h"
#import "JKMaMemberModel.h"

@interface JKChooseOperationPeoplesVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableArray *rowArr;
@end

@implementation JKChooseOperationPeoplesVC

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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr = [[NSMutableArray alloc] init];
    }
    return _sectionArr;
}

- (NSMutableArray *)rowArr {
    if (!_rowArr) {
        _rowArr = [[NSMutableArray alloc] init];
    }
    return _rowArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择运维管家";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getMaMemberList];
}

#pragma mark -- 获取安装运维人员列表
- (void)getMaMemberList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/maMember/%@",kUrl_Base,loginId];
    
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
//            for (NSDictionary *dict in responseObject[@"data"]) {
//                JKMaMemberModel *model = [[JKMaMemberModel alloc] init];
//                model.memId = dict[@"memId"];
//                model.memName = dict[@"memName"];
//                model.picture = dict[@"picture"];
//                model.taskCount = dict[@"taskCount"];
//                model.totalTaskCount = dict[@"totalTaskCount"];
//                model.region = dict[@"region"];
//                [self.sectionArr addObject:model];
//
//                for (JKMaMemberModel *rModel in self.sectionArr) {
//                    [self.rowArr addObject:rModel];
//                    if ([model.region isEqualToString:rModel.region]) {
//                        [self.sectionArr addObject:rModel];
//                    }
//                }
//            }
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject[@"data"]];
//            NSMutableArray *dateMutableArray = [@[] mutableCopy];
            for (int i = 0; i < array.count; i ++) {
                NSDictionary *dict = array[i];
                JKMaMemberModel *model = [[JKMaMemberModel alloc] init];
                model.memId = dict[@"memId"];
                model.memName = dict[@"memName"];
                model.picture = dict[@"picture"];
                model.taskCount = dict[@"taskCount"];
                model.totalTaskCount = dict[@"totalTaskCount"];
                model.region = dict[@"region"];
                NSMutableArray *tempArray = [@[] mutableCopy];
                [tempArray addObject:model];
                for (int j = i+1; j < array.count; j ++) {
                    NSDictionary *dic = array[j];
                    JKMaMemberModel *rModel = [[JKMaMemberModel alloc] init];
                    rModel.memId = dic[@"memId"];
                    rModel.memName = dic[@"memName"];
                    rModel.picture = dic[@"picture"];
                    rModel.taskCount = dic[@"taskCount"];
                    rModel.totalTaskCount = dic[@"totalTaskCount"];
                    rModel.region = dic[@"region"];
                    if([[NSString stringWithFormat:@"%@",model.region] isEqualToString:[NSString stringWithFormat:@"%@",rModel.region]]){
                        [tempArray addObject:rModel];
                        [array removeObjectAtIndex:j];
                        j -= 1;
                    }
                }
                [self.dataSource addObject:tempArray];
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    headerView.backgroundColor = RGBHex(0xdddddd);
    
    JKMaMemberModel *model = self.dataSource[section][0];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = model.region;
    titleLb.textColor = RGBHex(0x333333);
    titleLb.font = JKFont(14);
    [headerView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left).offset(15);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKMaMemberModel *model = self.dataSource[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ic_head_default"];
    cell.textLabel.text = model.memName;
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(15);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"维护设备数量：%@   当前任务数量：%@", model.totalTaskCount, model.taskCount];
    cell.detailTextLabel.textColor = RGBHex(0x999999);
    cell.detailTextLabel.font = JKFont(14);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKMaMemberModel *model = self.dataSource[indexPath.section][indexPath.row];
    if (self.tag == 999) {
        if ([_delegate respondsToSelector:@selector(popMemId:withMemName:)]) {
            [_delegate popMemId:model.memId withMemName:model.memName];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(popMemId:withMemName:withTag:)]) {
            [_delegate popMemId:model.memId withMemName:model.memName withTag:self.tag];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
