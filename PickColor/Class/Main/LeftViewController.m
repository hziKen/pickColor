//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 何梓坤 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"

#import "UIViewController+CWLateralSlide.h"

#import "NextTableViewCell.h"
#import "CollectionColorVC.h"
#import "SourceCodeViewController.h"
#import "AuthorViewController.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LeftViewController



- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"Select color button",@"Collection button",@"Author button",@"Original code button"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
      
    _titleArray = @[@"Pick Color",@"Favorites",@"Author",@"Source Code"];

    }
    return _titleArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupHeader];
    
    [self setupTableView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = CGRectGetWidth(self.view.frame) * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
}




- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    //    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 150)];
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:imageV];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
    cell.imageName = self.imageArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    if (indexPath.row == 0) { // 点击最后一个主动收起抽屉
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (indexPath.row == 2) { // 显示alertView
        vc = [[AuthorViewController alloc] init];
        vc.title = @"Author";
        [self cw_pushViewController:vc];
        return;
    }
    if (indexPath.row == 1) {
        vc = [[CollectionColorVC alloc] init];
        [self cw_pushViewController:vc];
        return;
    }
    
    if (indexPath.row == 3) {
        vc = [[SourceCodeViewController alloc] init];
        vc.title = @"Source Code";
        [self cw_pushViewController:vc];
        return;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
