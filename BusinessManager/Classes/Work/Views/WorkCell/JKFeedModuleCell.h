//
//  JKFeedModuleCell.h
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKFeedModuleCellDelegate <NSObject>
- (void)feedModuleBtnsClick:(UIButton *)btn;
@end

@interface JKFeedModuleCell : UITableViewCell
@property (nonatomic, weak) id<JKFeedModuleCellDelegate> delegate;
@end
