//
//  JKChooseRecyceDeviceVC.h
//  BusinessManager
//
//  Created by  on 2018/10/16.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@protocol JKChooseRecyceDeviceVCDelegate <NSObject>
- (void)saveSelectArr:(NSMutableArray *)arr;
@end

@interface JKChooseRecyceDeviceVC : JKBaseVC
@property (nonatomic, weak) id<JKChooseRecyceDeviceVCDelegate> delegate;
@property (nonatomic, strong) NSString *famerId;
@end
