//
//  DBDataBaseManager.m
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/20.
//  Copyright © 2017年 View. All rights reserved.
//


/*
///
//目前只支持字符串，整形，浮点型
//成员变量是Key，成员变量类型是Value
//把需要设为Key的成员变量放在该类属性的第一位
//添加对应的模型头文件，成员变量需要暴露在外部，不同模型不要使用相同的变量名
///
 */



#import "DBDataBaseManager.h"
#import "Preson.h"
#import <objc/runtime.h>

/** SQLite五种数据类型 */
#define SQLTEXT     @"text"
#define SQLINTEGER  @"integer"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"


static DBDataBaseManager *manager = nil;

@implementation DBDataBaseManager

+(DBDataBaseManager *)sharedDBDataBaseManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        manager = [[DBDataBaseManager alloc]init];
        //创建数据库
        [manager createDataBase];

    });
    return manager;
}

-(void)createDataBase{
    //存储路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"haqu.db"];
    
    NSLog(@"-----数据库存储路径:%@",path);
    //创建数据库
    _db = [FMDatabase databaseWithPath:path];
    
}

-(void)createTable:(NSString *)tableName andModel:(id )modelName{
    
    [_db open];
    
    //获取类名
    NSString *idClass = NSStringFromClass([modelName class]);
    //根据类型获取成员变量和成员变量类型
    NSDictionary *dict = [self parseAClass:idClass];
    //根据字典返回对应的字符串
    NSString * nameTypeStr = [self parseADictionary:dict];
    
    //建表
    NSString *str = [NSString stringWithFormat:@"create table if not exists %@(%@)",tableName,nameTypeStr];
    
//    BOOL success = [_db executeUpdate:@"create table if not exists Preson(id integer PRIMARY KEY AUTOINCREMENT, name text, number text)"];
    BOOL success = [_db executeUpdate:str];
    if (success) {
        NSLog(@"-----建表成功-----");
    }else{
        NSLog(@"-----建表失败-----");
    }
    
    [_db close];
}

//增
-(void)addDBDataBaseManager:(NSString *)tableName andModel:(id )modelName{
    
    [_db open];

    //获取类名
    NSString *idClass = NSStringFromClass([modelName class]);
    //根据类型获取成员变量和成员变量类型
    NSDictionary *dict = [self parseAClass:idClass];
    
    NSArray *array = [dict allKeys][0];
    
    NSMutableString *nameMutableStr = [NSMutableString string];
    NSMutableString *questionMarkMutableStr = [NSMutableString string];
    
    for (NSUInteger i = 0; i < array.count; i++) {
        [nameMutableStr appendFormat:@"%@,",array[i]];
        [questionMarkMutableStr appendString:@"?,"];
    }
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",[nameMutableStr substringToIndex:[nameMutableStr length] - 1]];
    NSString *questionMarkStr = [NSString stringWithFormat:@"%@",[questionMarkMutableStr substringToIndex:[questionMarkMutableStr length] - 1]];
    
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)",tableName,nameStr,questionMarkStr];
    
    //
    //需要自己写
    //
    
    //判断传递的类是哪个类，然后自定义对应的SQL语句
    //    if () {
    //          [modelName presonName]
    //    }else{
    //          [modelName presonName]
    //    }
    
    BOOL success = [self.db executeUpdate:sqlStr,[modelName presonName],[modelName presonNumber]];

    if (success == NO) {
        NSLog(@"---插入数据失败---");
    }else{
        NSLog(@"---插入数据成功---");
    }

    [_db close];
    
}

//单个删除
-(void)deleteOneDBDataBaseManager:(NSString *)tableName andModel:(id )modelName andName:(NSString *)name{
    
    [_db open];
    
    NSString *idClass = NSStringFromClass([modelName class]);
    //根据类型获取成员变量和成员变量类型
    NSDictionary *dict = [self parseAClass:idClass];
    
    NSArray *array = [dict allKeys][0];
    
    NSString *str = [NSString stringWithFormat:@"delete from %@ where %@ = ?",tableName,array[0]];
    
    BOOL success = [_db executeUpdate:str,name];
    
    if (success == NO) {
        NSLog(@"---数据库单个删除失败---");
    }else{
        NSLog(@"---数据库单个删除成功---");
    }
    
    [_db close];
    
}

//全部删除
-(void)deleteAllDBDataBaseManager:(NSString *)tableName{
    
    [_db open];
    NSString *str = [NSString stringWithFormat:@"delete from %@",tableName];
    
//    BOOL success = [_db executeUpdate:@"delete from preson"];
    BOOL success = [_db executeUpdate:str];
    
    if (success == NO) {
        NSLog(@"---数据库全部删除失败---");
    }else{
        NSLog(@"---数据库全部删除成功---");
    }
    [_db close];
}

//修改
-(void)alterDBDataBaseManager:(NSString *)tableName andModel:(id )modelName{
    
    [_db open];
  
    NSString *idClass = NSStringFromClass([modelName class]);

    //根据类型获取成员变量和成员变量类型
    NSDictionary *dict = [self parseAClass:idClass];
    
    NSArray *array = [dict allKeys][0];
    
    //根据姓名修改电话号码
    //
    //需要自己写
    //
    
    //判断传递的类是哪个类，然后自定义对应的SQL语句
//    if () {
//          [modelName presonName]
//    }else{
//          [modelName presonName]
//    }
    
    NSString *str = [NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,array[1],array[0]];
    
    BOOL success = [_db executeUpdate:str,[modelName presonNumber],[modelName presonName]];
    
    if (success == NO) {
        NSLog(@"---修改失败---");
    }else{
        NSLog(@"---修改成功---");
    }
//
    [_db close];
    
}

//查看单个
-(id)checkOneDBDataBaseManager:(NSString *)tableName andModel:(id)modelName{
    
    [_db open];
    
    NSString *idClass = NSStringFromClass([modelName class]);
    
    //根据类型获取成员变量和成员变量类型
    NSDictionary *dict = [self parseAClass:idClass];
    
    NSArray *array = [dict allKeys][0];
    
    id newModel = [[[modelName class] alloc]init];
    
    NSString *str = [NSString stringWithFormat:@"select * from %@ where %@=?",tableName,array[0]];
    
    //判断传递的类是哪个类，然后自定义对应的SQL语句
    //    if () {
    //      [modelName presonName]
    //    }else{
    //      [modelName presonName]
    //    }
    
    FMResultSet *set = [_db executeQuery:str,[modelName presonName]];
    
    while ([set next]) {
        
        //当前记录转为字典
        NSDictionary *dict = [set resultDictionary];
        //保存数据到模型中(KVC方法)
        [newModel setValuesForKeysWithDictionary:dict];
        
    }

    [_db close];
    
    return newModel;
    
}

//查看全部
-(NSMutableArray *)checkAllDBDataBaseManager:(NSString *)tableName andModel:(id )modelName{
    
    [_db open];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSString *str = [NSString stringWithFormat:@"select * from %@",tableName];
    
//    FMResultSet *set = [_db executeQuery:@"select * from Preson"];
    
    FMResultSet *set = [_db executeQuery:str];
    
    while ([set next]) {
    
        id newModel = [[[modelName class] alloc]init];

        //当前记录转为字典
        NSDictionary *dict = [set resultDictionary];
        //保存数据到模型中(KVC方法)
        [newModel setValuesForKeysWithDictionary:dict];
        
        [dataArray addObject:newModel];
    }
    
    [_db close];
    
    return dataArray;
    
}

//解析一个类
-(NSDictionary *)parseAClass:(id)className{

    //存放成员变量的数组
    NSMutableArray *variableNameArray = [NSMutableArray array];
    //存放成员变量数据类型的数组
    NSMutableArray *variableTypeArray = [NSMutableArray array];
    
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(NSClassFromString(className), &numIvars);
    
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        
        Ivar thisIvar = vars[i];
        //获取成员变量的名字
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        if ([[key substringToIndex:1] isEqualToString:@"_"]) {
            key = [key substringFromIndex:1];
        }
        
        [variableNameArray addObject:key];

        //获取成员变量的数据类型
        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
        
        //转换为FMDB可以保存的类型
        if ([key isEqualToString:@"@\"NSString\""]) {
            //字符串
            [variableTypeArray addObject:SQLTEXT];
            
        }else if ([key isEqualToString:@"^q"] || [key isEqualToString:@"^Q"] || [key isEqualToString:@"^i"]){
            //NSInteger,NSUInteger,int
            [variableTypeArray addObject:SQLINTEGER];
            
        }else if ([key isEqualToString:@"^f"] || [key isEqualToString:@"^d"]){
            //float,double
            [variableTypeArray addObject:SQLREAL];
        }
        
    }
    free(vars);
    
    //成员变量是Key，成员变量类型是Value
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:variableTypeArray forKey:variableNameArray];
    
    return dict;
}

//解析一个字典
-(NSString *)parseADictionary:(NSDictionary*)dict{
    
    NSArray *nameArray = [NSArray array];
    NSArray *typeArray = [NSArray array];
    
    nameArray = [dict allKeys][0];
    typeArray = [dict allValues][0];
    
    NSMutableString *nameTpyeStr = [NSMutableString string];
    
    for (NSUInteger i = 0; i < nameArray.count; i++) {
        [nameTpyeStr appendFormat:@"%@ %@,",nameArray[i],typeArray[i]];
    }
    
    NSString *str =[NSString stringWithFormat:@"%@",[nameTpyeStr substringToIndex:[nameTpyeStr length]-1]];
    
    return str;
   
}


@end
