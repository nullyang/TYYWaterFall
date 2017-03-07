//
//  TYYLayout.h
//  瀑布流
//
//  Created by null on 15/7/3.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TYYLayoutDelegate <NSObject>
//返回多少列
- (NSInteger)numberOfColumns;
//cell的高度
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface TYYLayout : UICollectionViewLayout
- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace;
@property (nonatomic ,assign)id <TYYLayoutDelegate>delegate;
@end
