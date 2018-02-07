//
//  CollectionColorVC.m
//  PickColor
//
//  Created by fory1 on 2018/1/22.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import "CollectionColorVC.h"
#import "CollectionColorCell.h"
#import "CollectionModel.h"
#import "ChooseColorVC.h"

@interface CollectionColorVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
static NSString *collectID = @"collection";

@implementation CollectionColorVC
#pragma mark -- 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView {
    
    if(!_collectionView) {

        UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HZKScreenW, HZKScreenH - SafeAreaTopHeight) collectionViewLayout:[self setUpLayout]];
        if (@available(iOS 11.0, *)) {
            cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        cv.alwaysBounceVertical = YES;
        cv.backgroundColor = [UIColor whiteColor];
        cv.delegate = self;
        cv.dataSource = self;
        _collectionView = cv;
    }

    return _collectionView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
    [self loadData];
}
#pragma mark -- 自定义方法
- (void)loadData{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"collection"]];
    if (arr != nil &&arr.count > 0) {
        self.dataArray = arr;
    }
}
- (void)setupCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionColorCell class]) bundle:nil] forCellWithReuseIdentifier:collectID];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
    _collectionView.userInteractionEnabled = YES;
    [_collectionView addGestureRecognizer:longPressGesture];
    
    [self.view addSubview:self.collectionView];
}

- (void)moveAction:(UILongPressGestureRecognizer *)longGes {
    if (longGes.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *selectPath = [self.collectionView indexPathForItemAtPoint:[longGes locationInView:longGes.view]];
        CollectionColorCell *cell = (CollectionColorCell *)[self.collectionView cellForItemAtIndexPath:selectPath];
        cell.deletaBtn.hidden = NO;
        [cell.deletaBtn addTarget:self action:@selector(deleteItemAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deletaBtn.tag = selectPath.item;
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectPath];
    }else if (longGes.state == UIGestureRecognizerStateChanged) {
        [self.collectionView updateInteractiveMovementTargetPosition:[longGes locationInView:longGes.view]];
    }else if (longGes.state == UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
    }else {
        [self.collectionView cancelInteractiveMovement];
    }
}
- (void)deleteItemAction:(UIButton *)btn {

    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"collection"]];
    [array removeObjectAtIndex:btn.tag];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"collection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.dataArray removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
}

- (UICollectionViewFlowLayout* )setUpLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.itemSize = CGSizeMake((HZKScreenW - 20) / 2, 130);

    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    return layout;
}
#pragma mark -- delegate
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectID forIndexPath:indexPath];
    cell.deletaBtn.hidden = YES;
    NSData *data = self.dataArray[indexPath.row];
    CollectionModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [cell setModel:model];
    NSLog(@"%@,%@",model.detail,model.colorArray);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data = self.dataArray[indexPath.row];
    CollectionModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    ChooseColorVC *vc = [[ChooseColorVC alloc] init];
    vc.colorArr = model.colorArray;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//将UIColor转换为RGB值
- (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

@end
