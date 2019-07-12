//
//  JKDateTimePickerView.h
//  GuoRenCar
//
//  Created by  on 2018/3/16.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKDateTimePickerViewDelegate <NSObject>
- (void)didClickFinishDateTimePickerView:(NSString*)date;
- (void)didClickFinishDateTimePickerView:(NSString*)date withTag:(NSInteger)tag;
@end


@interface JKDateTimePickerView : UIView
@property (nonatomic, strong) id<JKDateTimePickerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger contractCellTag;

- (void)showDateTimePickerView;

@end
