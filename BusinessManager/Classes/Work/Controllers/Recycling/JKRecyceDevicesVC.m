//
//  JKRecyceDevicesVC.m
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDevicesVC.h"

@interface JKRecyceDevicesVC () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _agreeOrUndo;//同意回收或者撤销回收
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *undoBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) NSMutableArray *resultBtnTitleArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UITextView *textV;
@end

@implementation JKRecyceDevicesVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)resultBtnTitleArr {
    if (!_resultBtnTitleArr) {
        _resultBtnTitleArr = [[NSMutableArray alloc] init];
    }
    return _resultBtnTitleArr;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] init];
    }
    return _selectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设备回收";
    
    _agreeOrUndo = YES;
    
    [self getRecyceList];
}

#pragma mark -- 获取回收原因多选项
- (void)getRecyceList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/recycleList/recycling",kUrl_Base];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSString *reason in responseObject[@"data"]) {
                [self.resultBtnTitleArr addObject:[NSString stringWithFormat:@"  %@",reason]];
            }
            [self.view addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.safeAreaTopView.mas_bottom);
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(90 + 20 + 100 + (self.resultBtnTitleArr.count / 2  + self.resultBtnTitleArr.count % 2) * 30);
            }];
            
            UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            submitBtn.titleLabel.font = JKFont(17);
            [self.view addSubview:submitBtn];
            [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tableView.mas_bottom).offset(SCALE_SIZE(25));
                make.left.equalTo(self.view).offset(SCALE_SIZE(15));
                make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(SCALE_SIZE(44));
            }];
        }
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 提交
- (void)submitBtnClick:(UIButton *)btn {
    if (_agreeOrUndo) {
        if (self.selectArr.count == 0) {
            [YJProgressHUD showMessage:@"请选择回收原因" inView:self.view];
            return;
        }
    } else {
        if (self.textV.text.length == 0) {
            [YJProgressHUD showMessage:@"请填写撤销原因" inView:self.view];
            return;
        }
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(_agreeOrUndo) forKey:@"isAgree"];
    if (self.selectArr.count != 0) {
        NSString *resMulti = [self.selectArr componentsJoinedByString:@","];
        [dict setObject:resMulti forKey:@"resMulti"];
    }
    if (self.textV.text.length != 0) {
       [dict setObject:self.textV.text forKey:@"remark"];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    [params setObject:loginId forKey:@"loginid"];
    [params setObject:dict forKey:@"appData"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"提交中..." inView:self.view];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
            });
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 单选
- (void)singleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.undoBtn.selected = NO;
        } else {
            self.agreeBtn.selected = NO;
        }
        _agreeOrUndo = !_agreeOrUndo;
    }
}

#pragma mark -- 多选
- (void)moreSelected:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSString *tagStr = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
    
    if (btn.selected) {
        [self.selectArr addObject:tagStr];
    } else {
        [self.selectArr removeObject:tagStr];
    }
    NSLog(@"%@",self.selectArr);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 45;
    } else if (indexPath.row == 1) {
        return 45;
    } else if (indexPath.row == 2) {
        return (self.resultBtnTitleArr.count / 2  + self.resultBtnTitleArr.count % 2) * 30 + 20;
    } else {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {
        cell.textLabel.text = @"设备回收";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(15);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"选择类型";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(15);
        
        UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [undoBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [undoBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [undoBtn setTitle:@"  撤销回收" forState:UIControlStateNormal];
        [undoBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [undoBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        undoBtn.titleLabel.font = JKFont(13);
        undoBtn.tag = 1;
        undoBtn.selected = NO;
        [undoBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:undoBtn];
        [undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(90, SCALE_SIZE(30)));
        }];
        self.undoBtn = undoBtn;
        
        UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreeBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [agreeBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [agreeBtn setTitle:@"  同意回收" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [agreeBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        agreeBtn.titleLabel.font = JKFont(13);
        agreeBtn.tag = 0;
        agreeBtn.selected = YES;
        [agreeBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(undoBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(90, SCALE_SIZE(30)));
        }];
        self.agreeBtn = agreeBtn;
        
    } else if (indexPath.row == 2) {
        UILabel *resultLb = [[UILabel alloc] init];
        resultLb.text = @"回收原因";
        resultLb.textColor = RGBHex(0x333333);
        resultLb.textAlignment = NSTextAlignmentLeft;
        resultLb.font = JKFont(13);
        [cell addSubview:resultLb];
        [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(80);
            make.height.mas_equalTo(48);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(resultLb.mas_right);
            make.height.mas_equalTo(SCALE_SIZE((self.resultBtnTitleArr.count / 2  + self.resultBtnTitleArr.count % 2) * 30));
        }];
        
        CGFloat width = (SCREEN_WIDTH - 30 - 70) / 2;
        
        for (NSInteger i = 0; i < self.resultBtnTitleArr.count; i++) {
            NSInteger col = i / 2;
            NSInteger row = i % 2;
            
            UIButton *resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_off"] forState:UIControlStateNormal];
            [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_on"] forState:UIControlStateSelected];
            [resultBtn setTitle:self.resultBtnTitleArr[i] forState:UIControlStateNormal];
            [resultBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
            resultBtn.titleLabel.font = JKFont(13);
            resultBtn.selected = NO;
            resultBtn.tag = i;
            resultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
            [resultBtn addTarget:self action:@selector(moreSelected:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:resultBtn];
            [resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(30 * col);
                make.left.equalTo(bgView.mas_left).offset((width + 10) * row);
                make.size.mas_equalTo(CGSizeMake(width, 30));
            }];
        }
    } else {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = @"同意/撤销原因";
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.font = JKFont(15);
        [cell addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top);
            make.left.equalTo(cell.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(120, 50));
        }];
        
        UITextView *textV = [[UITextView alloc] init];
        textV.font = JKFont(13);
        textV.textColor = RGBHex(0x666666);
        textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        textV.layer.borderWidth = 1;
        [textV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
        [cell addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.left.equalTo(titleLb.mas_right);
            make.right.equalTo(cell.mas_right).offset(-10);
            make.bottom.equalTo(cell.mas_bottom).offset(-10);
        }];
        self.textV = textV;
    }

    return cell;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
