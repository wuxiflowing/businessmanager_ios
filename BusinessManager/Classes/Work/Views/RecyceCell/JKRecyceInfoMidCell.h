//
//  JKRecyceInfoMidCell.h
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceInfoMidCellDelegate <NSObject>
- (void)clickOrderBtn:(UIButton *)btn;
- (void)clickPendBtn:(UIButton *)btn;
@end

@interface JKRecyceInfoMidCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceInfoMidCellDelegate> delegate;
@property (nonatomic, assign) JKRecyce recyceType;

- (void)createUI;
@end
