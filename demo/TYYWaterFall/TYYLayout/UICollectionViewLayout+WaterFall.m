//
//  UICollectionViewLayout+WaterFall.m
//  TYYWaterFall
//
//  Created by Null on 17/3/7.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "UICollectionViewLayout+WaterFall.h"
#import <objc/runtime.h>

@interface UICollectionViewLayout ()
@property (nonatomic ,assign)UIEdgeInsets sectionInsets;
@property (nonatomic ,assign)CGFloat itemSpace;
@property (nonatomic ,assign)CGFloat lineSpace;
@property (nonatomic ,assign)NSInteger column;
@property (nonatomic ,strong)NSMutableArray *columnHeightArray;
@property (nonatomic ,strong)NSMutableArray *frameAttrArray;
@end

@implementation UICollectionViewLayout (WaterFall)

- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace{
    if (self = [self init]) {
        self.sectionInsets = sectionInsets;
        self.lineSpace = lineSpace;
        self.itemSpace = itemSpace;
        self.column = 2;
        self.columnHeightArray = @[].mutableCopy;
        self.frameAttrArray = @[].mutableCopy;
    }
    return self;
}

- (void)prepareLayout{
    if ([self.delegate performSelector:@selector(numberOfColumns)]) {
        self.column = [self.delegate numberOfColumns];
    }
    [self.frameAttrArray removeAllObjects];
    [self.columnHeightArray removeAllObjects];
    for (int i = 0; i<self.column; i++) {
        NSNumber *n= [NSNumber numberWithFloat:self.sectionInsets.top];
        [self.columnHeightArray addObject:n];
    }
    //计算位置
    //计算每一个cell的位置
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //宽度
    CGFloat cellWidth = (self.collectionView.bounds.size.width - self.sectionInsets.left -self.sectionInsets.right -self.itemSpace *(self.column - 1))/self.column;

    for (int i = 0; i < cellCount; i++) {
        //计算高度
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat height = [self.delegate heightAtIndexPath:indexPath];
        //X值,确定cell放在第几列,先知道那一列最低
        NSInteger index = [self lowestHeightColumnIndex];
        // index == 0
        // index == 1
        // index == 2
        CGFloat x = self.sectionInsets.left + (cellWidth +self.itemSpace)*index;
        CGFloat y = [self.columnHeightArray[index] floatValue];
        //设置frame
        CGRect frame = CGRectMake(x, y, cellWidth, height);
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
        [self.frameAttrArray addObject:attr];
        //更新Y值
        self.columnHeightArray[index] = [NSNumber numberWithFloat:(y + height +self.lineSpace)];
    }
}

//找出当前位置最低列的序号
- (NSInteger)lowestHeightColumnIndex{
    NSInteger index = -1;
    CGFloat height = CGFLOAT_MAX;
    for (int i = 0; i < self.columnHeightArray.count; i++) {
        NSNumber *n = self.columnHeightArray[i];
        if (n.floatValue < height) {
            height = n.floatValue;
            index = i;
        }
    }
    return index;
}

//返回frame属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.frameAttrArray;
}

- (CGSize)collectionViewContentSize{
    CGFloat height = [[self.columnHeightArray objectAtIndex:[self highestColumnValue]] floatValue];
    CGFloat width = self.collectionView.bounds.size.width;
    return CGSizeMake(width, height);
}

- (NSInteger)highestColumnValue{
    NSInteger index = -1;
    CGFloat height = CGFLOAT_MIN;
    for (int i = 0; i < self.columnHeightArray.count; i++) {
        if ([self.columnHeightArray[i] floatValue] > height) {
            height = [self.columnHeightArray[i] floatValue];
            index = i;
        }
    }
    return index;
}

#pragma ---

- (id<TYYLayoutDelegate>)delegate{
    return objc_getAssociatedObject(self, @"delegate");
}

- (void)setDelegate:(id<TYYLayoutDelegate>)delegate{
    objc_setAssociatedObject(self, @"delegate", delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets{
    objc_setAssociatedObject(self, @"sectionInsets", NSStringFromUIEdgeInsets(sectionInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIEdgeInsets)sectionInsets{
    NSString *insetString = objc_getAssociatedObject(self, @"sectionInsets");
    return UIEdgeInsetsFromString(insetString);
}

- (CGFloat)itemSpace{
    NSNumber *itemSpace = objc_getAssociatedObject(self, @"itemSpace");
    return [itemSpace doubleValue];
}

- (void)setItemSpace:(CGFloat)itemSpace{
    objc_setAssociatedObject(self, @"itemSpace", @(itemSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lineSpace{
    NSNumber *lineSpace = objc_getAssociatedObject(self, @"lineSpace");
    return [lineSpace doubleValue];
}

- (void)setLineSpace:(CGFloat)lineSpace{
    objc_setAssociatedObject(self, @"lineSpace", @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)column{
    NSNumber *column = objc_getAssociatedObject(self, @"column");
    return [column integerValue];
}

- (void)setColumn:(NSInteger)column{
    objc_setAssociatedObject(self, @"column", @(column), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)columnHeightArray{
    return objc_getAssociatedObject(self, @"columnHeightArray");
}

- (void)setColumnHeightArray:(NSMutableArray *)columnHeightArray{
    objc_setAssociatedObject(self, @"columnHeightArray", columnHeightArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)frameAttrArray{
    return objc_getAssociatedObject(self, @"frameAttrArray");
}

- (void)setFrameAttrArray:(NSMutableArray *)frameAttrArray{
    objc_setAssociatedObject(self, @"frameAttrArray", frameAttrArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
