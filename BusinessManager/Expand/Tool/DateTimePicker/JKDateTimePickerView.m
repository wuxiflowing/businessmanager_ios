//
//  JKDateTimePickerView.m
//  GuoRenCar
//
//  Created by  on 2018/3/16.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKDateTimePickerView.h"

@interface JKDateTimePickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _yearRange;
    NSInteger _dayRange;
    NSInteger _startYear;
    NSInteger _selectedYear;
    NSInteger _selectedMonth;
    NSInteger _selectedDay;
    NSInteger _selectedHour;
    NSInteger _selectedMinute;
    NSInteger _selectedSecond;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *dateTimeStr;
@end

@implementation JKDateTimePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.alpha = 0;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 244)];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    toolBar.backgroundColor = kBgColor;
    [bgView addSubview:toolBar];
    
    //左边的取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12, 0, 40, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelButton];

    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(SCREEN_WIDTH - 52, 0, 40, 40);
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.backgroundColor = [UIColor clearColor];
    chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [chooseButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:chooseButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
    pickerView.backgroundColor = kWhiteColor;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    [bgView addSubview:pickerView];
    self.pickerView = pickerView;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    _startYear=year-15;
    _yearRange=50;
    [self setCurrentDate:[NSDate date]];
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return _yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return _dayRange;
        }
            break;
//        case 3:
//        {
//            return 24;
//        }
//            break;
//        case 4:
//        {
//            return 60;
//        }
//            break;
//
//        case 5:
//        {
//            return 60;
//        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate {
    //获取当前时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
//    NSInteger hour=[comps hour];
//    NSInteger minute=[comps minute];
//    NSInteger second=[comps second];
    
    _selectedYear=year;
    _selectedMonth=month;
    _selectedDay=day;
//    _selectedHour=hour;
//    _selectedMinute=minute;
//    _selectedSecond=second;
    _dayRange=[self isAllDay:year andMonth:month];
    
    [self.pickerView selectRow:year-_startYear inComponent:0 animated:NO];
    [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
    [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
//    [self.pickerView selectRow:hour inComponent:3 animated:NO];
//    [self.pickerView selectRow:minute inComponent:4 animated:NO];
//    [self.pickerView selectRow:second inComponent:5 animated:NO];
    
    [self pickerView:self.pickerView didSelectRow:year-_startYear inComponent:0];
    [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
    [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
//    [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
//    [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
//    [self pickerView:self.pickerView didSelectRow:second inComponent:5];
    
    [self.pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([UIScreen mainScreen].bounds.size.width-40)/6;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*component/6.0, 0,SCREEN_WIDTH/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.text=[NSString stringWithFormat:@"%ld",(long)(_startYear + row)];
        }
            break;
        case 1:
        {
            label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
        }
            break;
        case 2:
        {
            
            label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
        }
            break;
//        case 3:
//        {
//            label.textAlignment=NSTextAlignmentRight;
//            label.text=[NSString stringWithFormat:@"%ld",(long)row];
//        }
//            break;
//        case 4:
//        {
//            label.textAlignment=NSTextAlignmentRight;
//            label.text=[NSString stringWithFormat:@"%ld",(long)row];
//        }
//            break;
//        case 5:
//        {
//            label.textAlignment=NSTextAlignmentRight;
//            label.text=[NSString stringWithFormat:@"%ld",(long)row];
//        }
//            break;
            
        default:
            break;
    }
    
    return label;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            _selectedYear = _startYear + row;
            _dayRange = [self isAllDay:_selectedYear andMonth:_selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            _selectedMonth = row + 1;
            _dayRange = [self isAllDay:_selectedYear andMonth:_selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            _selectedDay = row + 1;
        }
            break;
//        case 3:
//        {
//            _selectedHour = row;
//        }
//            break;
//        case 4:
//        {
//            _selectedMinute = row;
//        }
//            break;
//        case 5:
//        {
//            _selectedSecond = row;
//        }
            break;
            
        default:
            break;
    }
    
    self.dateTimeStr =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",_selectedYear,_selectedMonth,_selectedDay];
}

#pragma mark -- 平闰年天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month {
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- show and hidden
- (void)showDateTimePickerView {
    [self setCurrentDate:[NSDate date]];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT-244, SCREEN_WIDTH, 244);
    } completion:^(BOOL finished) {

    }];
}

- (void)hideDateTimePickerView{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

#pragma mark -- cancle
- (void)cancelButtonClick:(UIButton *)btn {
    [self hideDateTimePickerView];
}

#pragma mark -- choose
- (void)chooseButtonClick:(UIButton *)btn {
    if (self.contractCellTag > 0) {
        if ([_delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:withTag:)]) {
            [_delegate didClickFinishDateTimePickerView:self.dateTimeStr withTag:self.contractCellTag];
        }
        [self hideDateTimePickerView];
    } else {
        if ([_delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
            [_delegate didClickFinishDateTimePickerView:self.dateTimeStr];
        }
        [self hideDateTimePickerView];
    }
}


@end
