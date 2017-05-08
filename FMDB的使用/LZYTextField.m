//
//  LZYTextField.m
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/15.
//  Copyright © 2017年 View. All rights reserved.
//

#import "LZYTextField.h"

@implementation LZYTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.alpha = 0.6;
        //修改光标颜色
        self.tintColor = [UIColor orangeColor];
    }
    return self;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width, bounds.size.height);
    
    return inset;
}


//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width, bounds.size.height);
    
    return inset;
    
}


@end
