//
//  DBDataBaseManager.h
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/20.
//  Copyright © 2017年 View. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase *db;
//创建单例的方法
+(DBDataBaseManager *)sharedDBDataBaseManager;

//建表
-(void)createTable:(NSString *)tableName andModel:(id )modelName;

//增
-(void)addDBDataBaseManager:(NSString *)tableName andModel:(id )modelName;
//单个删除
-(void)deleteOneDBDataBaseManager:(NSString *)tableName andModel:(id )modelName andName:(NSString *)name;
//全部删除
-(void)deleteAllDBDataBaseManager:(NSString *)tableName;
//修改
-(void)alterDBDataBaseManager:(NSString *)tableName andModel:(id )modelName;
//查看单个
-(id)checkOneDBDataBaseManager:(NSString *)tableName andModel:(id )modelName;
//查看全部
-(NSMutableArray *)checkAllDBDataBaseManager:(NSString *)tableName andModel:(id )modelName;

@end
