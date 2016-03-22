//
//  addViewController.h
//  SQLite_Demo
//
//  Created by Y杨定甲 on 16/3/21.
//  Copyright © 2016年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class addViewController;
@protocol addinformationDelegate <NSObject>

- (void)addinformation:(NSDictionary *)dic;
- (void)updateInformation:(NSDictionary *)dic;
@end
@interface addViewController : UIViewController

@property (weak, nonatomic)id <addinformationDelegate>delegate;

- (void)pushWithDic:(NSDictionary *)dic;
@end
