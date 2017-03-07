//
//  ViewController.m
//  TYYWaterFall
//
//  Created by Null on 17/3/7.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewLayout+WaterFall.h"
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface CollectionViewCellModel : NSObject
@property (nonatomic ,assign)CGFloat itemHeight;
@end

@implementation CollectionViewCellModel

- (CGFloat)itemHeight{
    return 50.0 + arc4random()%50;
}

@end

static NSString *cellId = @"UICollectionViewCellID";
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TYYLayoutDelegate>
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]initWithSectionInsets:UIEdgeInsetsMake(20, 15, 0, 15) itemSpace:10 lineSpace:10];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:NSClassFromString(@"UICollectionViewCell") forCellWithReuseIdentifier:cellId];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)numberOfColumns{
    return 3;
}

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath{
    return [self.datas[indexPath.row] itemHeight];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.contentView.backgroundColor = randomColor;
    return cell;
}

- (NSArray *)datas{
    if (_datas) {
        return _datas;
    }
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < 100; i++) {
        [list addObject:[self model]];
    }
    return list.copy;
}

- (CollectionViewCellModel *)model{
    return [[CollectionViewCellModel alloc]init];
}

@end
