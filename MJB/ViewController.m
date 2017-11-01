//
//  ViewController.m
//  MJB
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "MJBFeedBackViewController.h"

@interface ViewController ()

//测试意见反馈功能
- (IBAction)testFeedbackSender:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//测试意见反馈功能
- (IBAction)testFeedbackSender:(id)sender {
    MJBFeedBackViewController *vc = [[MJBFeedBackViewController alloc]init];
    vc.mail = @"793308186@qq.com";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
