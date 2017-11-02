//
//  ViewController.m
//  MJB
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "MJBFeedBackViewController.h"
#import "MJBAboutUsViewController.h"

@interface ViewController ()

//测试意见反馈功能
- (IBAction)testFeedbackSender:(id)sender;
//测试关于我们页面显示
- (IBAction)abuotUsSender:(id)sender;

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
    [self.navigationController pushViewController:vc animated:YES];
}

//测试关于我们页面显示
- (IBAction)abuotUsSender:(id)sender {
    MJBAboutUsViewController *vc = [[MJBAboutUsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
