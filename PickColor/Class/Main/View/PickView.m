//
//  PickView.m
//  PickColor
//
//  Created by fory1 on 2018/1/23.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import "PickView.h"

@implementation PickView

+ (instancetype)sharePickView
{
    return [[NSBundle mainBundle] loadNibNamed:@"PickView" owner:nil options:nil].firstObject;
}

@end
