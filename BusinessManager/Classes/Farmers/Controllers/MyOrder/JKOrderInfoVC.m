//
//  JKOrderInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOrderInfoVC.h"
#import "JKOrderInfoTopCell.h"
#import "JKOrderInfoMidCell.h"
#import "JKOrderInfoBottomCell.h"

@interface JKOrderInfoVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JKOrderInfoVC

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

    self.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCALE_SIZE(60);
    } else if (indexPath.row == 1) {
        return SCALE_SIZE(245);
    } else {
        if (self.infoType == JKOrderInfoService) {
            return SCALE_SIZE(230) + 100;
        } else if (self.infoType == JKOrderInfoDeposit) {
            return SCALE_SIZE(230) + 100;
        } else if (self.infoType == JKOrderInfoPrepayment) {
            return SCALE_SIZE(280) + 100;
        } else {
            return SCALE_SIZE(380) + 100;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"JKOrderInfoTopCell";
        JKOrderInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKOrderInfoTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKOrderInfoMidCell";
        JKOrderInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKOrderInfoMidCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else {
        static NSString *ID = @"JKOrderInfoBottomCell";
        JKOrderInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKOrderInfoBottomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell createOrderInfoBottomUI:self.infoType];
        
        return cell;
    }
}

@end
