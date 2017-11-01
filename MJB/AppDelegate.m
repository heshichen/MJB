//
//  AppDelegate.m
//  MJB
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "AppDelegate.h"

#import "SNWebBrowserViewController.h"
#import <AVOSCloud.h>
#import <JPUSHService.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define IS_OPEN_PUSH             ![[NSUserDefaults standardUserDefaults] boolForKey:@"is_open_push"]  // 是否开启本地推送



@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 推送相关
    [self addlocalnotification:application];
    [self jpushnotification:launchOptions];
    // 清除角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    UIViewController *con = [[UIViewController alloc] init];
    con.view.backgroundColor = [UIColor whiteColor];
    UIImageView* imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgview.image = [UIImage imageNamed:@"loding"];
    [con.view addSubview:imgview];
    self.window.rootViewController = con;
    
    
    // 注册LeanCloud服务
    [self registerLeanCloud];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(void)jpushnotification:(NSDictionary*)launchOptions
{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    NSString* appkey = JPUSH_KEY;
    
    
    BOOL production = true;
#ifdef DEBUG
    
    production = false;
    
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:appkey channel:@"appstore" apsForProduction:production];
    
}

- (void)registerLeanCloud
{
    // 初始化LeanCloud
    [AVOSCloud setApplicationId:LC_APP_KEY clientKey:LC_CLIENT_KEY];
    
    // 获取应用的 BundleID
    NSString *bunldeID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    AVQuery *query = [AVQuery queryWithClassName:@"config"];
    [query whereKeyExists:@"appid"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error || objects.count == 0) {
            // 从故事版中加载
            UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController = [stryBoard instantiateInitialViewController];
        } else {
            
            int number = 0;
            
            for (AVObject *obj in objects) {
                if ([[obj objectForKey:@"appid"] isEqualToString:bunldeID]) {
                    
                    NSLog(@"🌲哈哈%@", obj);
                    
                    NSLog(@"🍀%zd",  [[obj objectForKey:@"show"] boolValue]);
                    
                    BOOL isShow = [[obj objectForKey:@"show"] boolValue];
                    
                    if (isShow) {
                        // 显示网页浏览器
                        NSString *url = (NSString *)[obj objectForKey:@"url"];
                        SNWebBrowserViewController *webBrowserVc = [[SNWebBrowserViewController alloc]init];
                        webBrowserVc.url = url;
                        self.window.rootViewController = webBrowserVc;
                    } else {
                        // 从故事版中加载
                        UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        self.window.rootViewController = [stryBoard instantiateInitialViewController];
                    }
                    
                    number ++;
                    
                    break;
                }
            }
            if (number==0) {
                // 从故事版中加载
                UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.window.rootViewController = [stryBoard instantiateInitialViewController];
            }
        }
    }];
}


-(void)addlocalnotification:(UIApplication*)application
{
    if (IS_OPEN_PUSH) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            //iOS10特有
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
            center.delegate = self;
            
        }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
            //iOS8 - iOS10
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            
        }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            //iOS8系统以下
            [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
        }
        // 注册获得device Token
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}
// 获得Device Token失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body; // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body; // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
    
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end

