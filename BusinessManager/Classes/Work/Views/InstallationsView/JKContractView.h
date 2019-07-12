//
//  JKContractView.h
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKContractModel;
@protocol JKContractViewDelegate <NSObject>
- (void)popContractModel:(JKContractModel *)model;
- (void)popContractServiceModel:(JKContractModel *)model;
@end

@interface JKContractView : UIView
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, weak) id<JKContractViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withContractType:(JKContractType) type;
@end
 
