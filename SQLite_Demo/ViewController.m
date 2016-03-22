//
//  ViewController.m
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/2/22.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"
#import "addViewController.h"
#import "updateViewController.h"


#define DBNAME    @"person.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,addinformationDelegate>

@property (nonatomic, assign) sqlite3 *db;
@property (weak, nonatomic) IBOutlet UITableView *DBTableView;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation ViewController
@synthesize db;

+(ViewController *)sharedDB{
    static dispatch_once_t pred;
    static ViewController *vc = nil;
    dispatch_once(&pred, ^{
        vc = [[ViewController alloc] init];
    });
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [[NSMutableArray alloc]init];
    
    [self openDB];
    [self createTable];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self select:nil];
}
- (void)openDB{
    
    //获取沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [path stringByAppendingPathComponent:DBNAME];
    NSLog(@"数据库目录：%@",dbPath);
    
    //打开数据库
    db = NULL;
    int ret=sqlite3_open([dbPath cStringUsingEncoding:NSUTF8StringEncoding],&db);
    if (ret != SQLITE_OK){
        NSLog(@"打开数据库文件失败:%s", sqlite3_errmsg(db));
        return;
    }
}
- (void)createTable{
    //创建表

    NSString *sql = @"create table if not exists PERSONINFO(id integer primary key, name varchar(20), age int, address TEXT)";
    char *errmsg = NULL;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errmsg) != SQLITE_OK) {
        NSLog(@"数据库操作数据失败!");
    }else{
        NSLog(@"%@",sql);
    }
}

- (void)updateDBWithDic:(NSDictionary *)dic{
    NSString *sql=[NSString stringWithFormat:@"UPDATE PERSONINFO SET name='%@' , age = '%@', address = '%@' WHERE id='%@'",dic[@"name"], dic[@"age"], dic[@"address"],dic[@"userId"]];
    [self execSql:sql];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClickAction
- (IBAction)addTouch:(id)sender {
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//                      TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"西城区"];
//    [self execSql:sql1];
//
//    NSString *sql2 = @"INSERT INTO 'PERSONINFO' ('name', 'age', 'address') VALUES ('大麦', '23', '元嘉国际')";
//    [self execSql:sql2];

    addViewController *addVC = [[addViewController alloc]init];
    addVC.delegate = self;
    [self presentViewController:addVC animated:YES completion:nil];

}
- (IBAction)delete:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"是否删除所有记录\n(左滑列表可以删除单条数据)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *sql=[NSString stringWithFormat:@"DELETE FROM PERSONINFO"];
        [self execSql:sql];
    
    }];
    
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        }];

    // Add the actions.
    [alertController addAction:otherAction];
    [alertController addAction:determineAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)close:(id)sender {
    sqlite3_close(db);
    exit(0);
}
- (IBAction)select:(id)sender {
    
    [self.array removeAllObjects];
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
//    [self execSql:sqlQuery];
    sqlite3_stmt * statement;
    //sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去. 使用该接口访问数据库是当前比较好的的一种方法
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //第一个参数跟前面一样，是个sqlite3 * 类型变量，
        //第二个参数是一个 sql 语句。
        //第三个参数我写的是-1，这个参数含义是前面 sql 语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以\0结尾的字符串）。
        //第四个参数是sqlite3_stmt 的指针的指针。解析以后的sql语句就放在这个结构里。
        //第五个参数是错误信息提示，一般不用,为nil就可以了。
        //如果这个函数执行成功（返回值是 SQLITE_OK 且 statement 不为NULL ），那么下面就可以开始插入二进制数据。
        
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            NSString *ageStr = [NSString stringWithFormat:@"%d",age];
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            int ID = sqlite3_column_int(statement, 0);
            NSString *IDStr = [NSString stringWithFormat:@"%d",ID];
            
            NSLog(@"row:%d   name:%@  age:%d  address:%@",ID,nsNameStr,age, nsAddressStr);
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[IDStr,nsNameStr,ageStr,nsAddressStr] forKeys:@[@"userId",@"name",@"age",@"address"]];

            [self.array addObject:dic];
        }
    }
    sqlite3_close(db);
    [self.DBTableView reloadData];
}
//数据库操作
-(void)execSql:(NSString *)sql
{
    [self openDB];
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库操作数据失败:%s",err);
    }else{
        NSLog(@"%@",sql);
    }
//    sqlite3_close(db);
    
}

#pragma mark - tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"address"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    updateViewController *updateVC = [[updateViewController alloc]init];
    NSDictionary *userDic =  [self.array objectAtIndex:indexPath.row];
    [updateVC pushWithDic:userDic];
    [self presentViewController:updateVC animated:YES completion:nil];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        NSDictionary *userDic =  [self.array objectAtIndex:indexPath.row];
        NSString *userId = [userDic objectForKey:@"userId"];
        [self.array removeObjectAtIndex:indexPath.row];  //删除数组里的数据
        //删除数据库信息
        NSString *sql=[NSString stringWithFormat:@"DELETE FROM PERSONINFO WHERE id ='%@'",userId];
        [self execSql:sql];
        [self.DBTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];//删除对应数据的cell
        
    }
}

#pragma mark - AddInformationDelegate
-(void)addinformation:(NSDictionary *)dic{
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, dic[@"name"], dic[@"age"], dic[@"address"]];
    [self execSql:sql1];
    [self.DBTableView reloadData];
}



@end
