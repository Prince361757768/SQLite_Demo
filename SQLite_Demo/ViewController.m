//
//  ViewController.m
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/2/22.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"

#define DBNAME    @"person.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"
@interface ViewController ()

@property (nonatomic, assign) sqlite3 *db;
@end

@implementation ViewController
@synthesize db;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSLog(@"打开数据库成功");
    [self createTable];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addTouch:(id)sender {
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"西城区"];
    [self execSql:sql1];

    NSString *sql2 = @"INSERT INTO 'PERSONINFO' ('name', 'age', 'address') VALUES ('大麦', '23', '元嘉国际')";
    [self execSql:sql2];
}
- (IBAction)delete:(id)sender {
    
}
- (IBAction)update:(id)sender {

}
- (IBAction)select:(id)sender {
    
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
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
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"row:%@   name:%@  age:%d  address:%@",statement,nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(db);
}
//数据库操作
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库操作数据失败:%s",err);
    }else{
        NSLog(@"%@",sql);
    }
    sqlite3_close(db);
}

@end
