//
//  MJBFeedBackViewController.m
//  MJB
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MJBFeedBackViewController.h"
#import <MBProgressHUD.h>
#import <AVOSCloud.h>

@interface MJBFeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *alertLb;
//文字输入框
@property (weak, nonatomic) IBOutlet UITextView *textView;
//邮件按钮
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
//发送邮件
- (IBAction)sendMailSender:(id)sender;

@end

@implementation MJBFeedBackViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"feedbackTitle", nil);;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)setup
{
    //提示语
    self.alertLb.text = NSLocalizedString(@"oj1-eV-OvB", nil);
    //邮箱
    [_mailButton setTitle:[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"SXZ-72-c8m", nil),_mail] forState:UIControlStateNormal];
    //导航
    UIBarButtonItem *cancenBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSneder:)];
    self.navigationItem.leftBarButtonItem = cancenBtn;
    
    UIBarButtonItem *commitBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"commit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(commitSender:)];
    self.navigationItem.rightBarButtonItem = commitBtn;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = MJBCoror(51, 51, 51);
    
    if ([textView.text isEqualToString:@"请留下您宝贵的意见和建议，200字以内。"]) {
        textView.text = nil;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.textColor = MJBCoror(153, 153, 153);
        textView.text = @"请留下您宝贵的意见和建议，200字以内。";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)showHUDWithTitle:(NSString *)title model:(MBProgressHUDMode)model
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            [view removeFromSuperview];
        }
    }
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
    hud.mode = model;
    hud.label.text = title;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
}

//发送邮件
- (IBAction)sendMailSender:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"mailto://%@",self.mail];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//取消
- (void)cancelSneder:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)commitSender:(id)sender
{
    NSString *content = _textView.text;
    if (content.length == 0 || [content isEqualToString:@"请留下您宝贵的意见和建议，200字以内。"]) {
        [self showHUDWithTitle:@"请输入意见" model:MBProgressHUDModeText];
        [self.textView beginningOfDocument];
    } else
    {
        [self.view endEditing:YES];
        [self showHUDWithTitle:@"提交中..." model:MBProgressHUDModeIndeterminate];
        
        AVObject *feedback = [AVObject objectWithClassName:@"Feedback"];
        [feedback setObject:_textView.text forKey:@"content"];
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self showHUDWithTitle:@"提交成功" model:MBProgressHUDModeText];
                [self performSelector:@selector(cancelSneder:) withObject:nil afterDelay:1.5];
            } else {
                [self showHUDWithTitle:@"提交失败，请重新再试" model:MBProgressHUDModeText];
            }
        }];
    }
}

@end
