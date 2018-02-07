//
//  CollectionColorCell.m
//  PickColor
//
//  Created by fory1 on 2018/1/22.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import "CollectionColorCell.h"
#import "CollectionModel.h"

@interface CollectionColorCell()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@end

@implementation CollectionColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)setModel:(CollectionModel *)model
{
    _model = model;
    self.colorView.backgroundColor = [UIColor colorWithRed:[model.colorArray[1] integerValue] / 255.0 green:[model.colorArray[2] integerValue] / 255.0 blue:[model.colorArray[3] integerValue] / 255.0 alpha:[model.colorArray[0] floatValue]];
    self.detailLB.text = model.detail;
}
@end
