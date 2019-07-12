//
//  JKRepairTopView.h
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRepairTopViewDelegate <NSObject>
- (void)chooseFarmers;
@end

@interface JKRepairTopView : UIView
@property (nonatomic, weak) id<JKRepairTopViewDelegate> delegate;
@property (nonatomic, strong) NSString *farmerId;
@end
