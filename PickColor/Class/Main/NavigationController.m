//
//  NavigationController.m
//  ViewControllerTransition
//
//  Created by pakho on 2017/6/28.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController
+ (void)initialize {
    
    // 当导航栏使用MRNavigationControlelr时才设定改主题
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    // 设置背景图片
    navigationBar.barTintColor = HZKColor(255, 146, 78);
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    
    [navigationBar setTitleTextAttributes:attrs];
    [navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"=============%@",NSStringFromCGRect(self.navigationBar.frame));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
