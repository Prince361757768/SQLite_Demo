//
//  updateViewController.m
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/3/22.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "updateViewController.h"
#import "addViewController.h"
#import "ViewController.h"

@interface updateViewController ()<addinformationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) NSDictionary *dic;
@end

@implementation updateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
    NSLog(@"%s   %d",__FUNCTION__,__LINE__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self updateView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushWithDic:(NSDictionary *)dic{
    self.dic = dic;
}

- (void)updateView{
    self.name.text = [self.dic objectForKey:@"name"];
    self.age.text = [self.dic objectForKey:@"age"];
    self.address.text = [self.dic objectForKey:@"address"];
    self.userId.text = [self.dic objectForKey:@"userId"];
}
- (IBAction)changeInfor:(id)sender {
    addViewController *addVC = [[addViewController alloc]init];
    addVC.delegate = self;
    [addVC pushWithDic:self.dic];
    [self presentViewController:addVC animated:YES completion:nil];
}
#pragma mark - addViewDelegate
- (void)updateInformation:(NSDictionary *)dic{
    self.dic = dic;
    [self updateView];
    [[ViewController sharedDB] updateDBWithDic:dic];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
