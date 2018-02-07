//
//  CollectionColorCell.h
//  PickColor
//
//  Created by fory1 on 2018/1/22.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionModel;

@interface CollectionColorCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deletaBtn;
@property (nonatomic,strong) CollectionModel *model;
@end
