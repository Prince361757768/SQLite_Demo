//
//  ViewController.h
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/2/22.
//  Copyright © 2016年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

+ (ViewController *)sharedDB;

- (void)updateDBWithDic:(NSDictionary *)dic;
@end

