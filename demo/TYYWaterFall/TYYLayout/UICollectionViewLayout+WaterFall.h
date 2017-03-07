//
//  UICollectionViewLayout+WaterFall.h
//  TYYWaterFall
//
//  Created by Null on 17/3/7.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYYLayoutDelegate <NSObject>
/**
    列数（默认是2）
 */
- (NSInteger)numberOfColumns;
/**
    每个cell的高度
 */
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewLayout (WaterFall)

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace;

@property (nonatomic ,assign)id <TYYLayoutDelegate>delegate;

@end
