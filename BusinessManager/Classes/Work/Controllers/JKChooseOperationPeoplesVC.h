//
//  JKChooseOperationPeoplesVC.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@protocol JKChooseOperationPeoplesVCDelegate <NSObject>
- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName;
- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName withTag:(NSInteger)tag;
@end

@interface JKChooseOperationPeoplesVC : JKBaseVC
@property (nonatomic, weak) id<JKChooseOperationPeoplesVCDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@end
