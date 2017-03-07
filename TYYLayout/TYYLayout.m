//
//  TYYLayout.m
//  瀑布流
//
//  Created by null on 15/7/3.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "TYYLayout.h"

@implementation TYYLayout
{
    UIEdgeInsets _sectionInsets;
    CGFloat _itemSpace;
    CGFloat _lineSpace;
    //列数
    NSInteger _column;
    //存储每一列的高度
    NSMutableArray *_heightArray;
    //存储frame属性的数组
    NSMutableArray *_attrArray;
}
- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace
{
    if (self = [super init]) {
        _sectionInsets = sectionInsets;
        _lineSpace = lineSpace;
        _itemSpace = itemSpace;
        _column = 2;
        _heightArray = [NSMutableArray array];
        _attrArray = [NSMutableArray array];
    }
    return self;
}
//每次刷新网格视图时调用
- (void)prepareLayout
{
    [super prepareLayout];
    //获取多少列
    if ([self.delegate performSelector:@selector(numberOfColumns)]) {
        _column = [self.delegate numberOfColumns];
    }
    //初始化frame属性数组
    [_attrArray removeAllObjects];
    //初始化高度的数组
    [_heightArray removeAllObjects];
    for (int i = 0; i<_column; i++) {
        NSNumber *n= [NSNumber numberWithFloat:_sectionInsets.top];
        [_heightArray addObject:n];
    }
    //计算位置
    //计算每一个cell的位置
    NSInteger cellCont = [self.collectionView numberOfItemsInSection:0];
    //宽度
    CGFloat width = (self.collectionView.bounds.size.width - _sectionInsets.left -_sectionInsets.right -_itemSpace *(_column - 1))/_column;
    for (int i = 0; i<cellCont; i++) {
        //计算高度
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat height = [self.delegate heightAtIndexPath:indexPath];
        //X值,确定cell放在第几列,先知道那一列最低
        NSInteger index = [self lowestColumnIndex];
        // index == 0
        // index == 1
        // index == 2
        CGFloat x = _sectionInsets.left + (width +_itemSpace)*index;
        CGFloat y = [_heightArray[index] floatValue];
        //设置frame
        CGRect frame = CGRectMake(x, y, width, height);
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
        [_attrArray addObject:attr];
        //更新Y值
        _heightArray[index] = [NSNumber numberWithFloat:(y +height +_lineSpace)];
    }
}

//找出当前位置最低列的序号
- (NSInteger)lowestColumnIndex
{
    NSInteger index = -1;
    CGFloat height = CGFLOAT_MAX;
    for (int i = 0; i<_heightArray.count; i++) {
        NSNumber *n = _heightArray[i];
        if (n.floatValue <height) {
            height = n.floatValue;
            index = i;
        }
    }
    return index;
}
//返回frame属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attrArray;
}
//设置网格视图的大小
- (CGSize)collectionViewContentSize
{
    CGFloat height = [[_heightArray objectAtIndex:[self highestColumn]] floatValue];
    CGFloat width = self.collectionView.bounds.size.width;
    return CGSizeMake(width, height);
}

//计算最大值
- (NSInteger)highestColumn
{
    NSInteger index = -1;
    CGFloat height = CGFLOAT_MIN;
    for (int i = 0; i<_heightArray.count; i++) {
        if ([_heightArray[i] floatValue]>height) {
            height = [_heightArray[i] floatValue];
            index = i;
        }
    }
    return index;
}
@end
