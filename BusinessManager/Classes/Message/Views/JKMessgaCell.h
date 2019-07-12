//
//  JKMessgaCell.h
//  BusinessManager
//
//  Created by  on 2018/6/15.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKMessageModel;

@protocol JKMessgaCellDelegate <NSObject>
- (void)cellClick:(JKMessageModel *)model;
@end

@interface JKMessgaCell : UITableViewCell
@property (nonatomic, weak) id<JKMessgaCellDelegate> delegate;
- (void)messgeInfoWithModel:(JKMessageModel *)model;

@end
