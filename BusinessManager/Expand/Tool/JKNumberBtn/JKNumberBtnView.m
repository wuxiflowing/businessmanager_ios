//
//  JKNumberBtnView.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKNumberBtnView.h"

@interface JKNumberBtnView () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *lineOneLb;
@property (nonatomic, strong) UILabel *lineTwoLb;
@end

@implementation JKNumberBtnView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    self.canEdit = NO;
    
    self.layer.borderColor = RGBHex(0xcbcbcb).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2.0f;
    
    [self.plusBtn removeFromSuperview];
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"ic_add_selected"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"ic_add_unselected"] forState:UIControlStateDisabled];
    [plusBtn addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(30);
    }];
    self.plusBtn = plusBtn;
    
    [self.minusBtn removeFromSuperview];
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:@"ic_minus_selected"] forState:UIControlStateNormal];
    [minusBtn setImage:[UIImage imageNamed:@"ic_minus_unselected"] forState:UIControlStateDisabled];
    [minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(30);
    }];
    self.minusBtn = minusBtn;
    
    [self.lineOneLb removeFromSuperview];
    UILabel *lineOneLb = [[UILabel alloc] init];
    lineOneLb.backgroundColor = RGBHex(0xcbcbcb);
    [self addSubview:lineOneLb];
    [lineOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(minusBtn.mas_right);
        make.width.mas_equalTo(1);
    }];
    self.lineOneLb = lineOneLb;
    
    [self.lineTwoLb removeFromSuperview];
    UILabel *lineTwoLb = [[UILabel alloc] init];
    lineTwoLb.backgroundColor = RGBHex(0xcbcbcb);
    [self addSubview:lineTwoLb];
    [lineTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(plusBtn.mas_left);
        make.width.mas_equalTo(1);
    }];
    self.lineTwoLb = lineTwoLb;
    
    [self.textField removeFromSuperview];
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = RGBHex(0x333333);
    textField.font = JKFont(14);
    [textField setTextAlignment:NSTextAlignmentCenter];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.text = @"0";
    textField.delegate = self;
    textField.enabled = self.canEdit;
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(minusBtn.mas_right);
        make.right.equalTo(plusBtn.mas_left);
    }];
    self.textField = textField;
    
    self.minCount = 1;
    self.maxCount = 100;
    _currentCount = 1;
    self.minusBtn.enabled = NO;
}

- (void)setCurrentCount:(NSInteger)currentCount {
    _currentCount = currentCount;
    self.textField.text = [NSString stringWithFormat:@"%ld", _currentCount];
    if (_currentCount == self.maxCount && _currentCount == self.minCount) {
        self.minusBtn.enabled = NO;
        self.plusBtn.enabled = NO;
    } else if (_currentCount == self.maxCount) {
        self.minusBtn.enabled = YES;
        self.plusBtn.enabled = NO;
    } else if (_currentCount == self.minCount) {
        self.minusBtn.enabled = NO;
        self.plusBtn.enabled = YES;
    }
}

- (void)plusButtonClick:(UIButton *)btn {
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
    self.minusBtn.enabled = YES;
    _currentCount++;
    self.textField.text = [NSString stringWithFormat:@"%ld", _currentCount];
    if (_currentCount >= self.maxCount) {
        self.plusBtn.enabled = NO;
    }
    if ([_delegate respondsToSelector:@selector(getCurrentNumber:withTag:)]) {
        [_delegate getCurrentNumber:_currentCount withTag:self.tag];
    }
}

- (void)minusBtnClick:(UIButton *)btn {
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
    self.plusBtn.enabled = YES;
    _currentCount--;
    self.textField.text = [NSString stringWithFormat:@"%ld", _currentCount];
    if (_currentCount <= self.minCount) {
        self.minusBtn.enabled = NO;
    }
    if ([_delegate respondsToSelector:@selector(getCurrentNumber:withTag:)]) {
        [_delegate getCurrentNumber:_currentCount withTag:self.tag];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _currentCount = [textField.text integerValue];
}

@end
