//
//  MJBAboutUsViewController.m
//  MJB
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MJBAboutUsViewController.h"

@interface MJBAboutUsViewController ()

@end

@implementation MJBAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    self.title = @"关于";
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    UIImageView * logoV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon57x57"]];
    logoV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.3);
    logoV.bounds = CGRectMake(0, 0, 120, 120);
    logoV.layer.cornerRadius = 25;
    logoV.layer.masksToBounds = YES;
    [self.view addSubview:logoV];
    
    
    UILabel * name = [[UILabel alloc]init];
    name.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.45);
    name.bounds = CGRectMake(0, 0, 100, 80);
    name.text = appName;
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:name];
    
    
    UILabel * version = [[UILabel alloc]init];
    version.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.49);
    version.bounds = CGRectMake(0, 0, self.view.frame.size.width, 80);
    NSString *lastVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version.text = [NSString stringWithFormat:@"%@iPhone版%@",appName,lastVersion];
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:version];
    
    UILabel * htc = [[UILabel alloc]init];
    htc.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.96 - TCAddHeight * 1.5 - 64);
    htc.bounds = CGRectMake(0, 0, 250, 80);
    htc.text = @"@XUEQIU All Rights";
    htc.textAlignment = NSTextAlignmentCenter;
    htc.textColor = MJBCoror(147, 147, 147);
    htc.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:htc];
    
    
    UILabel * rights = [[UILabel alloc]init];
    rights.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.98 - TCAddHeight * 1.5 - 64);
    rights.bounds = CGRectMake(0, 0, 250, 80);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    rights.adjustsFontSizeToFitWidth = YES;
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    rights.text = [NSString stringWithFormat:@"©2014-%@ LittleNote @XUEQIU All rights reserved", yearString];
    rights.textAlignment = NSTextAlignmentCenter;
    rights.textColor = MJBCoror(147, 147, 147);
    rights.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:rights];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
