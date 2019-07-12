//
//  JKContractListView.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractListView.h"

@interface JKContractListView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _male;//同意回收或者撤销回收
}
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIButton *womanBtn;
@property (nonatomic, strong) UIButton *manBtn;
@end

@implementation JKContractListView

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.titleArr = @[@"*养殖户姓名", @"*联系方式", @" 身份证号", @"*年龄", @"*性别", @"*家庭所在区域", @" 家庭详细地址", @"", @"", @"", @""];

        _male = NO;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 0) {
        NSLog(@"%@",textField.text);
    } else if (textField.tag == 1) {
        NSLog(@"%@",textField.text);
    } else if (textField.tag == 2) {
        NSLog(@"%@",textField.text);
    } else if (textField.tag == 3) {
        NSLog(@"%@",textField.text);
    } else if (textField.tag == 6) {
        NSLog(@"%@",textField.text);
    }
}

#pragma mark -- 单选
- (void)singleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.womanBtn.selected = NO;
        } else {
            self.manBtn.selected = NO;
        }
        _male = !_male;
    }
    NSLog(@"%d",_male);
}

#pragma mark -- 正面照
- (void)positiveBtnClick:(UIButton *)btn {
    NSLog(@"正面");
}

#pragma mark -- 反面照
- (void)negativeBtnClick:(UIButton *)btn {
    NSLog(@"反面");
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return 180;
    } else if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10) {
        return 100;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if ([cell.textLabel.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [attString addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, 1)];
        cell.textLabel.attributedText = attString;
    }
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6) {
        UITextField *textField = [[UITextField alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell);
            make.right.equalTo(cell).offset(-15);
            make.left.equalTo(cell.textLabel.mas_right).offset(20);
        }];
        
        if (indexPath.row == 0) {
            textField.placeholder = @"请输入姓名";
        } else if (indexPath.row == 1) {
            textField.placeholder = @"请输入联系电话";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if (indexPath.row == 2) {
            textField.placeholder = @"请输入身份证号码";
        } else if (indexPath.row == 3) {
            textField.placeholder = @"请输入年龄";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if (indexPath.row == 6) {
            textField.placeholder = @"请输入详细地址";
        }
    } else if (indexPath.row == 4) {
        UIButton *womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [womanBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [womanBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [womanBtn setTitle:@"  女" forState:UIControlStateNormal];
        [womanBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [womanBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        womanBtn.titleLabel.font = JKFont(14);
        womanBtn.tag = 1;
        womanBtn.selected = NO;
        [womanBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:womanBtn];
        [womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.womanBtn = womanBtn;
        
        UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [manBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [manBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [manBtn setTitle:@"  男" forState:UIControlStateNormal];
        [manBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [manBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        manBtn.titleLabel.font = JKFont(14);
        manBtn.tag = 0;
        manBtn.selected = YES;
        [manBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:manBtn];
        [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(womanBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.manBtn = manBtn;
    } else if (indexPath.row == 5) {
        cell.detailTextLabel.text = @"江苏省无锡市滨湖区";
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.font = JKFont(14);
        [cell addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(48);
        }];
        
        if (indexPath.row == 7) {
            titleLb.text = @"上传身份证";
            
            UIImageView *positiveImgV = [[UIImageView alloc] init];
            positiveImgV.image = [UIImage imageNamed:@"ic_id_card"];
            positiveImgV.contentMode = UIViewContentModeScaleAspectFit;
            positiveImgV.userInteractionEnabled = YES;
            [cell addSubview:positiveImgV];
            [positiveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLb.mas_bottom);
                make.left.equalTo(cell).offset(15);
                make.right.equalTo(cell.mas_centerX).offset(-7.5);
                make.height.mas_equalTo(100);
            }];
            
            UILabel *positiveLb = [[UILabel alloc] init];
            positiveLb.text = @"正面照";
            positiveLb.textColor = RGBHex(0x333333);
            positiveLb.textAlignment = NSTextAlignmentCenter;
            positiveLb.font = JKFont(13);
            [cell addSubview:positiveLb];
            [positiveLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(positiveImgV.mas_bottom);
                make.left.equalTo(positiveImgV.mas_left);
                make.right.equalTo(positiveImgV.mas_right);
                make.bottom.equalTo(cell.mas_bottom);
            }];
            
            UIButton *positiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [positiveBtn addTarget:self action:@selector(positiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [positiveImgV addSubview:positiveBtn];
            [positiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(positiveImgV);
            }];
            
            UIImageView *negativeImgV = [[UIImageView alloc] init];
            negativeImgV.image = [UIImage imageNamed:@"ic_id_card"];
            negativeImgV.contentMode = UIViewContentModeScaleAspectFit;
            negativeImgV.userInteractionEnabled = YES;
            [cell addSubview:negativeImgV];
            [negativeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLb.mas_bottom);
                make.right.equalTo(cell).offset(-15);
                make.left.equalTo(cell.mas_centerX).offset(7.5);
                make.height.mas_equalTo(100);
            }];
            
            UILabel *negativeLb = [[UILabel alloc] init];
            negativeLb.text = @"反面照";
            negativeLb.textColor = RGBHex(0x333333);
            negativeLb.textAlignment = NSTextAlignmentCenter;
            negativeLb.font = JKFont(13);
            [cell addSubview:negativeLb];
            [negativeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(negativeImgV.mas_bottom);
                make.left.equalTo(negativeImgV.mas_left);
                make.right.equalTo(negativeImgV.mas_right);
                make.bottom.equalTo(cell.mas_bottom);
            }];
            
            UIButton *negativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [negativeBtn addTarget:self action:@selector(negativeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [negativeImgV addSubview:negativeBtn];
            [negativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(negativeImgV);
            }];
            
        } else if (indexPath.row == 8) {
            titleLb.text = @"上传登记表";
        } else if (indexPath.row == 9) {
            titleLb.text = @"上传养殖户照片";
        } else if (indexPath.row == 10) {
            titleLb.text = @"上传鱼塘照片";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        NSLog(@"弹出选择器");
    }
}

@end
