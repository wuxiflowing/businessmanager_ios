//
//  JKInternetOfThingsModuleCell.h
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKInternetOfThingsModuleCellDelegate <NSObject>
- (void)moduleBtnsClick:(UIButton *)btn;
@end

@interface JKInternetOfThingsModuleCell : UITableViewCell
@property (nonatomic, weak) id<JKInternetOfThingsModuleCellDelegate> delegate;
@end
