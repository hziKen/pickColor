//
//  CollectionModel.h
//  PickColor
//
//  Created by fory1 on 2018/1/22.
//  Copyright © 2018年 fory1. All rights reserved.
//  用于存储用户收藏的

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject<NSCoding>

@property(copy , nonatomic) NSArray *colorArray;//颜色数组(rgba)

@property(copy , nonatomic) NSString *detail;//描述
@end
