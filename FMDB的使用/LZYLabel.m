//
//  LZYLabel.m
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/15.
//  Copyright © 2017年 View. All rights reserved.
//

#import "LZYLabel.h"

@implementation LZYLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.alpha = 0.6;
        
    }
    return self;
}

@end
