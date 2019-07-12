//
//  JKRecyceDeviceBottomCell.m
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceDeviceBottomCell.h"
#import "TZImagePickerHelper.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKRecyceDeviceBottomCell () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *resultBtnTitleArr;
@property (nonatomic, strong) NSString *operationPeopleName;
@property (nonatomic, strong) NSString *operationPeopleId;
@property (nonatomic, strong) TZImagePickerHelper *recyceAnnexHelper;
@property (nonatomic, strong) NSMutableArray *imageRecyceAnnexURL;
@property (nonatomic, strong) NSMutableArray *imageRecyceAnnexArr;
@property (nonatomic, strong) UILabel *annexLb;
@end

@implementation JKRecyceDeviceBottomCell

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

- (TZImagePickerHelper *)recyceAnnexHelper {
    if (!_recyceAnnexHelper) {
        _recyceAnnexHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _recyceAnnexHelper.imageType = JKImageTypeRecyceAnnex;
        _recyceAnnexHelper.finishRecyceAnnex = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageRecyceAnnexURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageRecyceAnnexArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _recyceAnnexHelper;
}

- (NSMutableArray *)imageRecyceAnnexURL {
    if (!_imageRecyceAnnexURL) {
        _imageRecyceAnnexURL = [[NSMutableArray alloc] init];
    }
    return _imageRecyceAnnexURL;
}

- (NSMutableArray *)imageRecyceAnnexArr {
    if (!_imageRecyceAnnexArr) {
        _imageRecyceAnnexArr = [[NSMutableArray alloc] init];
    }
    return _imageRecyceAnnexArr;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        [self getRecyceList];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecyceOperationPeople:)name:@"reloadRecyceOperationPeople" object:nil];
        self.titleArr = @[@"回收信息", @"*退款银行", @"*退款户名", @"*退款账号", @""];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
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
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)reloadRecyceOperationPeople:(NSNotification *)noti {
    self.operationPeopleName = noti.userInfo[@"memName"];
    self.operationPeopleId = noti.userInfo[@"memId"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 1) {
        self.bankName = textField.text;
    } else if (textField.tag == 2) {
        self.bankPerson = textField.text;
    } else if (textField.tag == 3) {
        self.bankAccount = textField.text;
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
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 160 + (self.resultBtnTitleArr.count / 2  + self.resultBtnTitleArr.count % 2) * 30;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
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
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = RGBHex(0x333333);
        textField.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 1) {
            textField.placeholder = @"请输入开户银行";
        } else if (indexPath.row == 2) {
            textField.placeholder = @"请输入持卡人";
        } else if (indexPath.row == 3) {
            textField.placeholder = @"请输入卡号";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        textField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-15);
            make.width.mas_offset(SCREEN_WIDTH / 2);
        }];
        
    } else if (indexPath.row == 4) {
        UILabel *resultLb = [[UILabel alloc] init];
        resultLb.text = @"回收原因";
        resultLb.textColor = RGBHex(0x333333);
        resultLb.textAlignment = NSTextAlignmentLeft;
        resultLb.font = JKFont(13);
        [cell.contentView addSubview:resultLb];
        [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(15);
            make.width.mas_offset(80);
            make.height.mas_equalTo(48);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        [cell.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(resultLb.mas_right);
            make.height.mas_equalTo((self.resultBtnTitleArr.count / 2 + self.resultBtnTitleArr.count % 2) *30);
        }];
        
        CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30) - 70) / 2;

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
        
        UITextView *textV = [[UITextView alloc] init];
        textV.font = JKFont(13);
        textV.textColor = RGBHex(0x666666);
        textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        textV.layer.borderWidth = 1;
        [textV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
        textV.delegate = self;
        [cell.contentView addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom).offset(10);
            make.left.equalTo(bgView.mas_left);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        self.textV = textV;
    } else {
//        [self.annexLb removeFromSuperview];
//        UILabel *annexLb = [[UILabel alloc] init];
//        annexLb.text = @"附件图片";
//        annexLb.textColor = RGBHex(0x333333);
//        annexLb.textAlignment = NSTextAlignmentLeft;
//        annexLb.font = JKFont(14);
//        [cell.contentView addSubview:annexLb];
//        [annexLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.contentView);
//            make.left.equalTo(cell.contentView).offset(15);
//            make.right.equalTo(cell.contentView).offset(-15);
//            make.height.mas_equalTo(48);
//        }];
//        self.annexLb = annexLb;
//
//        [self createScrollImageUI:annexLb withCell:cell withImageType:JKImageTypeRecyceAnnex withImageArr:self.imageRecyceAnnexURL];
    }
    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = kWhiteColor;
    [cell.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.left.equalTo(cell.contentView.mas_left).offset(15);
        make.right.equalTo(cell.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(80);
    }];
    
    scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
    
    if (imgArr.count == 0) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 80, 80);
        addBtn.tag = imageType;
        [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:addBtn];
    } else {
        if (imgArr.count == 9) {
            for (NSInteger i = 0; i < imgArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(90 * i , 0, 80, 80);
                [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                [scrollView addSubview:btn];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                deleteBtn.tag = i;
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                [btn addSubview:deleteBtn];
            }
        } else {
            for (NSInteger i = 0; i < imgArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(90 * i , 0, 80, 80);
                [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                [scrollView addSubview:btn];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                deleteBtn.tag = i;
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                [btn addSubview:deleteBtn];
                
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                addBtn.tag = imageType;
                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:addBtn];
            }
        }
    }
}

- (void)btnClick:(UIButton *)btn {
     [self.recyceAnnexHelper showImagePickerControllerWithMaxCount:(9 - self.imageRecyceAnnexArr.count) WithViewController:[self View:self]];
}

- (void)deleteBtnClick:(UIButton *)btn {
    [self.imageRecyceAnnexURL removeObjectAtIndex:btn.tag];
    [self.imageRecyceAnnexArr removeObjectAtIndex:btn.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- view对应的UIViewController
- (UIViewController *)View:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

@end
