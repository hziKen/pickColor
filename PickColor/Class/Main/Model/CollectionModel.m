//
//  CollectionModel.m
//  PickColor
//
//  Created by fory1 on 2018/1/22.
//  Copyright © 2018年 fory1. All rights reserved.
//  存储自定义对象需要实现下面两个代理

#import "CollectionModel.h"

@implementation CollectionModel
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.colorArray forKey:@"colorArray"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.colorArray = [aDecoder decodeObjectForKey:@"colorArray"];
    }
    return self;
}
@end


