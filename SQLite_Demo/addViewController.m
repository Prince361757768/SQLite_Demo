//
//  addViewController.m
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/3/21.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic) NSDictionary *pushDic;
@property (strong, nonatomic) NSString *userId;
@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addinformation:(id)sender {
    self.nameTextField.text = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.ageTextField.text = [self.ageTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.addressTextField.text = [self.addressTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""] || self.ageTextField.text == nil || [self.ageTextField.text isEqualToString:@""] || self.addressTextField.text == nil || [self.addressTextField.text isEqualToString:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"内容错误" message:@"请输入完整信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        

        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }

    self.dic = [NSMutableDictionary dictionaryWithObjects:@[self.nameTextField.text,self.ageTextField.text,self.addressTextField.text] forKeys:@[@"name",@"age",@"address"]];
    if ([self.delegate respondsToSelector:@selector(addinformation:)]) {
        [self.delegate addinformation:self.dic];
    }
    if ([self.delegate respondsToSelector:@selector(updateInformation:)]) {
        [self.dic setObject:self.userId forKey:@"userId"];
        [self.delegate updateInformation:self.dic];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushWithDic:(NSDictionary *)dic{
    self.pushDic = dic;
    self.userId = [dic objectForKey:@"userId"];
}

- (void)updateView{
    self.nameTextField.text = [self.pushDic objectForKey:@"name"];
    self.ageTextField.text = [self.pushDic objectForKey:@"age"];
    self.addressTextField.text = [self.pushDic objectForKey:@"address"];
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
