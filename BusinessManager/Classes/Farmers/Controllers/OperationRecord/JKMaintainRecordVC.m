//
//  JKMaintainRecordVC.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainRecordVC.h"
#import "JKMaintainCell.h"
#import "JKMaintainInfoVC.h"

@interface JKMaintainRecordVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JKMaintainRecordVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"维护记录";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALE_SIZE(200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    JKMaintainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[JKMaintainCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.maintainType = JKMaintainEd;
//    [cell createUI];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKMaintainInfoVC *miVC = [[JKMaintainInfoVC alloc] init];
    miVC.maintainType = JKMaintainEd;
    [self.navigationController pushViewController:miVC animated:YES];
}

@end
