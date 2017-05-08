//
//  HomePageViewController.m
//  FMDB的使用
//
//  Created by 李自杨 on 17/2/15.
//  Copyright © 2017年 View. All rights reserved.
//

#import "HomePageViewController.h"
#import "Preson.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *pic;

//姓名
@property (nonatomic, strong) LZYLabel *nameLabel;
@property (nonatomic, strong) LZYTextField *nameTextField;
@property (nonatomic, strong) LZYButton *nameDecideBtn;

//电话号码
@property (nonatomic, strong) LZYLabel *numberLabel;
@property (nonatomic, strong) LZYTextField *numberTextField;
@property (nonatomic, strong) LZYButton *numberDecideBtn;

//UITableView
@property (nonatomic, strong) UITableView *mainTableView;

////数据库
//@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) DBDataBaseManager *manager;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    bgImageView.image = [UIImage imageNamed:@"fengjing"];
    [self.view addSubview:bgImageView];
    
    _pic = @"";
    /*
     数据库
     */
    [self createDataBase];
    
    /*
     创建各种控件
    */
    [self createName];
    [self createNumber];
    [self createButton];
    [self createTableView];
    
}

#pragma mark -- 懒加载
-(NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark -- 创建数据库
//创建数据库
-(void)createDataBase{
    
    _manager = [DBDataBaseManager sharedDBDataBaseManager];
    //建表
    Preson *preson = [[Preson alloc]init];
    
    [_manager createTable:presonTable andModel:preson];
    [self checkAllOnClcik];
    
}

#pragma mark -- 姓名UI
-(void)createName{
    //UILabel
    _nameLabel = [[LZYLabel alloc]init];
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(74);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
    }];
    _nameLabel.text = @"昵称";
    
    //UITextField
    _nameTextField = [[LZYTextField alloc]init];
    [self.view addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(74);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        make.height.mas_equalTo(_nameLabel.mas_height);
        make.width.mas_equalTo(@180);
    }];
    _nameTextField.placeholder = @"请输入您的昵称";
    
    //UIButton
    _nameDecideBtn = [[LZYButton alloc]init];
    [self.view addSubview:_nameDecideBtn];
    [_nameDecideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(74);
        make.left.mas_equalTo(_nameTextField.mas_right).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(_nameTextField.mas_height);
    }];
    [_nameDecideBtn setTitle:@"Data" forState:UIControlStateNormal];
    [_nameDecideBtn addTarget:self action:@selector(nameOnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)nameOnClick{
    
    if ([_nameTextField.text isEqualToString:@""]) {
        NSLog(@"-----昵称为空-----");
        return;
    }
    
    NSLog(@"-----昵称 : %@-----",_nameTextField.text);
    
}

#pragma mark -- 电话号码UI
-(void)createNumber{
    //UILabel
    _numberLabel = [[LZYLabel alloc]init];
    [self.view addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.width.mas_equalTo(_nameLabel.mas_width);
        make.height.mas_equalTo(_nameLabel.mas_height);
    }];
    _numberLabel.text = @"电话号码";
    
    //UITextField
    _numberTextField = [[LZYTextField alloc]init];
    [self.view addSubview:_numberTextField];
    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameTextField.mas_bottom).offset(10);
        make.left.mas_equalTo(_numberLabel.mas_right).offset(10);
        make.height.mas_equalTo(_numberLabel.mas_height);
        make.width.mas_equalTo(@180);
    }];
    _numberTextField.placeholder = @"请输入您的电话号码";
    
    //UIButton
    _numberDecideBtn = [[LZYButton alloc]init];
    [self.view addSubview:_numberDecideBtn];
    [_numberDecideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameDecideBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(_numberTextField.mas_right).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(_numberTextField.mas_height);
    }];
    [_numberDecideBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_numberDecideBtn addTarget:self action:@selector(numberOnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)numberOnClick{
    
    if ([_numberTextField.text isEqualToString:@""]) {
        NSLog(@"-----电话号码为空-----");
        return;
    }
    NSLog(@"-----电话号码 : %@-----",_numberTextField.text);
    
}

#pragma mark -- 本地数据操作UI
-(void)createButton{
    
    NSArray *btnNameArray = [NSArray arrayWithObjects:@"增加",@"单个删除",@"删除全部",@"修改",@"单个查看",@"查看全部",@"清空列表", nil];
    
    for (int i = 0; i < btnNameArray.count; i++) {
        
        LZYButton *btn = [[LZYButton alloc]init];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(10);
            make.top.mas_equalTo(_numberLabel.mas_bottom).offset(20 + (50 + 20) * i);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@50);
        }];
        [btn setTitle:btnNameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        switch (btn.tag) {
            case 100:
                [btn addTarget:self action:@selector(addOnClick) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 101:
                [btn addTarget:self action:@selector(deleteOneOnClick) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 102:
                [btn addTarget:self action:@selector(deleteAllOnClcik) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                break;
                
            case 103:
                [btn addTarget:self action:@selector(alterOnClcik) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 104:
                [btn addTarget:self action:@selector(checkOneOnClcik) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 105:
                [btn addTarget:self action:@selector(checkAllOnClcik) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 106:
                [btn addTarget:self action:@selector(deleteTable) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        
    }
}

//增
-(void)addOnClick{
    
    if ([_nameTextField.text isEqualToString:@""] || [_numberTextField.text isEqualToString:@""]) {
        NSLog(@"-----插入数据失败，请输入您要添加的数据-----");
        return;
    }else{

        Preson *preson = [[Preson alloc]init];
        preson.presonName = _nameTextField.text;
        preson.presonNumber = _numberTextField.text;
        
        [_manager addDBDataBaseManager:presonTable andModel:preson];

        _nameTextField.text = @"";
        _numberTextField.text = @"";

    }
    
    [self checkAllOnClcik];
    
}

//单个删除
-(void)deleteOneOnClick{
    
    if ([_nameTextField.text isEqualToString:@""]) {
        NSLog(@"-----数据库单个删除失败，请输入昵称-----");
        return;
    }
    
    Preson *pre = [[Preson alloc]init];
    
    [_manager deleteOneDBDataBaseManager:presonTable andModel:pre andName:_nameTextField.text];
    
    _nameTextField.text = @"";
    _numberTextField.text = @"";
    
    [self checkAllOnClcik];

    
}

//全部删除
-(void)deleteAllOnClcik{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要删除全部吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
            [_manager deleteAllDBDataBaseManager:presonTable];

            [self checkAllOnClcik];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        return ;
        
    }]];
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//修改
-(void)alterOnClcik{
    
    if ([_nameTextField.text isEqualToString:@""] || [_numberTextField.text isEqualToString:@""]) {
        NSLog(@"-----请输入您要修改的姓名和电话号码-----");
        return;
    }
    //修改所有的name
//    BOOL success = [_db executeUpdate:@"update Preson set name=?",_nameTextField.text];
    //修改所有的number
//    BOOL success = [_db executeUpdate:@"update Preson set number=?",_numberTextField.text];
    
    //根据姓名修改电话号码
    Preson *preson = [[Preson alloc]init];
    preson.presonName = _nameTextField.text;
    preson.presonNumber = _numberTextField.text;
    [_manager alterDBDataBaseManager:presonTable andModel:preson];
    
    [self checkAllOnClcik];
    
}

//查看单个
-(void)checkOneOnClcik{
    
    [self.dataArray removeAllObjects];
    
    if ([_nameTextField.text isEqualToString:@""]) {
        NSLog(@"-----请输入您要查找的姓名-----");
        [self.mainTableView reloadData];
        return;
    }
    
    Preson *preson = [[Preson alloc]init];
    preson.presonName = _nameTextField.text;
    preson = [_manager checkOneDBDataBaseManager:presonTable andModel:preson];

    [self.dataArray addObject:preson];

    [self.mainTableView reloadData];
    
}

//查看全部
-(void)checkAllOnClcik{
    
    [self.dataArray removeAllObjects];
    
    Preson *pre = [[Preson alloc]init];
    
    self.dataArray = [_manager checkAllDBDataBaseManager:presonTable andModel:pre];
    
    [self.mainTableView reloadData];
}

-(void)deleteTable{
    
    NSLog(@"-----清空列表-----");
    
    [self.dataArray removeAllObjects];
    
    [self.mainTableView reloadData];
}


#pragma mark -- 创建TableViewUI
-(void)createTableView{
    
    _mainTableView = [[UITableView alloc]init];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberTextField.mas_bottom).offset(20);
        make.left.mas_equalTo(_numberTextField.mas_left);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
    }];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.alpha = 0.6;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
}

//分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    Preson *pre = [[Preson alloc]init];
    pre = _dataArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"head"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",pre.presonName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",pre.presonNumber];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
