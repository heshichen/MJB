//
//  SNWebBrowserViewController.m
//  SecurityNote
//
//  Created by admin on 2017/10/26.
//  Copyright © 2017年 JoonSheng. All rights reserved.
//

#import "SNWebBrowserViewController.h"

@interface SNWebBrowserViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSMutableArray *urlList;
@property (assign, nonatomic) NSInteger backNumber;

/** 首页  */
- (IBAction)homeSender:(id)sender;
/** 返回 */
- (IBAction)backSender:(id)sender;
/** 前进 */
- (IBAction)forwardSender:(id)sender;
/** 刷新 */
- (IBAction)refreshSender:(id)sender;

@end

@implementation SNWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    //设置网址
    NSURLRequest *urlRequest = [self generateURLAddressForStr:_url];
    [self.webView loadRequest:urlRequest];
}

- (NSMutableArray *)urlList
{
    if (!_urlList) {
        _urlList = [NSMutableArray array];
    }
    return _urlList;
}

/** 生成 NSURLRequest 对象*/
- (NSURLRequest *)generateURLAddressForStr:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}

/** 首页  */
- (IBAction)homeSender:(id)sender
{
    NSURLRequest *urlRequest = [self generateURLAddressForStr:_url];
    [self.webView loadRequest:urlRequest];
}

/** 返回 */
- (IBAction)backSender:(id)sender
{
    [self.webView goBack];
}

/** 前进 */
- (IBAction)forwardSender:(id)sender
{
    [self.webView goForward];
}

/** 刷新 */
- (IBAction)refreshSender:(id)sender
{
    NSURLRequest *urlRequest = [self generateURLAddressForStr:self.webView.request.URL.absoluteString];
    [self.webView loadRequest:urlRequest];
}


@end
