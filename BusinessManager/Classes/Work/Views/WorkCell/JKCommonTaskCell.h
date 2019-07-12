//
//  JKCommonTaskCell.h
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKCommonTaskCellDelegate <NSObject>
- (void)commonTaskBtnsClick:(UIButton *)btn;
@end

@interface JKCommonTaskCell : UITableViewCell
@property (nonatomic, weak) id<JKCommonTaskCellDelegate> delegate;
- (void)createUI:(NSMutableArray *)dataSource;
@end
