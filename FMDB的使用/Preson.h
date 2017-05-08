//
//  Preson.h
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/16.
//  Copyright © 2017年 View. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Preson;
@interface Preson : NSObject

@property (nonatomic, copy) NSString *presonName;

@property (nonatomic, copy) NSString *presonNumber;

-(instancetype)init;
    


@end
