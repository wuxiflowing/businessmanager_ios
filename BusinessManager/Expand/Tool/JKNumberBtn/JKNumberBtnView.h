//
//  JKNumberBtnView.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKNumberBtnViewDelegate <NSObject>
- (void)getCurrentNumber:(NSInteger)number withTag:(NSInteger)tag;
@end


@interface JKNumberBtnView : UIView
@property (nonatomic, weak) id<JKNumberBtnViewDelegate> delegate;
@property (nonatomic, assign) NSInteger minCount;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) NSInteger currentCount;
- (void)creatUI;
@end
