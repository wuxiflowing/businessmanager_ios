//
//  JKInstallationMidView.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKInstallationMidViewDelegate <NSObject>
- (void)getSelectArray:(NSMutableArray *)selectedArr;
@end

@interface JKInstallationMidView : UIView
@property (nonatomic, weak) id<JKInstallationMidViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) NSInteger deviceCount;
- (instancetype)initWithFromSigningContractVC:(BOOL)isFrom;
@end
