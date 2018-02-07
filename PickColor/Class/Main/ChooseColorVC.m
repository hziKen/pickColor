//
//  ChooseColorVC.m
//  PickColor
//
//  Created by fory1 on 2018/1/19.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import "ChooseColorVC.h"
#import "SGPagingView.h"
#import "CollectionModel.h"
#import "ZYInputAlertView.h"
#import "CollectionColorVC.h"

@interface ChooseColorVC ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (nonatomic,strong) UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorText;
@property (weak, nonatomic) IBOutlet UILabel *redValue;
@property (weak, nonatomic) IBOutlet UILabel *greenValue;
@property (weak, nonatomic) IBOutlet UILabel *blueValue;
@property (weak, nonatomic) IBOutlet UILabel *alphaValue;
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation ChooseColorVC
#pragma mark -- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pick Color";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Collection button"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionClick)];
    [self setupPageView];
    [self config];
    [self loadCustomData];
    NSLog(@"%lu",(unsigned long)self.colorArr.count);
}

- (void)config{
    [_redSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_greenSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_blueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_alphaSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
#pragma mark -- 用户点击事件
- (void)collectionClick
{
    CollectionModel *model = [[CollectionModel alloc] init];
    
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.placeholder = @"Enter Happy Things···";
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"collection"] != nil) {
            array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"collection"]];
        }
        model.detail = inputString;
        model.colorArray = [self changeUIColorToRGB:self.colorView.backgroundColor];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        
        [array addObject:data];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"collection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            CollectionColorVC *vc = [[CollectionColorVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    [alertView show];
    
   
}
#pragma mark -- 加载自定义数据
- (void)loadCustomData{
    self.redSlider.value = [self.colorArr[1] integerValue] / 255.0f;
    self.greenSlider.value = [self.colorArr[2] integerValue] / 255.0f;
    self.blueSlider.value = [self.colorArr[3] integerValue] / 255.0f;
    self.alphaSlider.value = [self.colorArr[0] floatValue];
    
    self.alphaValue.text = [NSString stringWithFormat:@"%.3f", self.alphaSlider.value];
    self.redValue.text = [NSString stringWithFormat:@"%.3f", self.redSlider.value];
    self.greenValue.text = [NSString stringWithFormat:@"%.3f", self.greenSlider.value];
    self.blueValue.text = [NSString stringWithFormat:@"%.3f",self.blueSlider.value];
    
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:self.alphaSlider.value];
    self.colorText.text = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
    
}
#pragma mark --  slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == 101) {
        NSLog(@"%f",slider.value);
        self.redSlider.value = slider.value;
    }else if (slider.tag == 102){
        NSLog(@"%f",slider.value);
        self.greenSlider.value = slider.value;
    }else if (slider.tag == 103){
        NSLog(@"%f",slider.value);
        self.blueSlider.value = slider.value;
    }else{
        NSLog(@"%f",slider.value);
        self.alphaSlider.value = slider.value;
    }
    switch (_currentIndex) {
        case 0:
        self.colorText.text = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
            break;
        case 1:
        self.colorText.text = [NSString stringWithFormat:@"UIColor(red: %.2f, green: %.2f, blue: %.2f, alpha: %.2f)",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
            break;
        case 2:
          self.colorText.text = [NSString stringWithFormat:@"Color.FromArgb(%.2f,%.2f,%.2f,%.2f)",self.alphaSlider.value,self.redSlider.value,self.greenSlider.value,self.blueSlider.value];
            break;
        case 3:
             self.colorText.text = [NSString stringWithFormat:@"Color.argb(%.2f, %.2f, %.2f, %.2f)",self.alphaSlider.value,self.redSlider.value,self.greenSlider.value,self.blueSlider.value];
            break;
        case 4:
             self.colorText.text = [NSString stringWithFormat:@"rgba(%.2f,%.2f,%.2f,%.2f)",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
            break;
        default:
            break;
    }
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:self.alphaSlider.value];
    self.alphaValue.text = [NSString stringWithFormat:@"%.3f", self.alphaSlider.value];
    self.redValue.text = [NSString stringWithFormat:@"%.3f", self.redSlider.value];
    self.greenValue.text = [NSString stringWithFormat:@"%.3f", self.greenSlider.value];
    self.blueValue.text = [NSString stringWithFormat:@"%.3f",self.blueSlider.value];
   
}
- (void)setupPageView {
    //    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    //        if (statusHeight == 20.0) {
    //            pageTitleViewY = 64;
    //        } else {
    //            pageTitleViewY = 88;
    //        }
    
    NSArray *titleArr = @[@"Object-C",@"Swift", @"C#", @"Java", @"CSS", @"", @"CSS", @"CSS"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    
    UIView *colorView = [[UIView alloc] init];
    colorView.frame = CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), HZKScreenW, 170);
    colorView.backgroundColor = [UIColor orangeColor];
    self.colorView = colorView;
    [self.view addSubview:colorView];
}
- (IBAction)copyBtnClick:(UIButton *)sender {
    [SVProgressHUD showSuccessWithStatus:@"Copy Success~"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.colorText.text;
    });
    
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    NSLog(@"%ld",selectedIndex);
    self.currentIndex = selectedIndex;
    switch (selectedIndex) {
        case 0:
        self.colorText.text = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
            break;
        case 1:
            self.colorText.text = [NSString stringWithFormat:@"UIColor(red: %.2f, green: %.2f, blue: %.2f, alpha: %.2f)",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
//         UIColor(red: 55/255, green: 186/255, blue: 89/255, alpha: 0.5)
            break;
        case 2:
        self.colorText.text = [NSString stringWithFormat:@"Color.FromArgb(%.2f,%.2f,%.2f,%.2f)",self.alphaSlider.value,self.redSlider.value,self.greenSlider.value,self.blueSlider.value];
//            Color.FromArgb(100,200,200,200)
            break;
        case 3:
            self.colorText.text = [NSString stringWithFormat:@"Color.argb(%.2f, %.2f, %.2f, %.2f)",self.alphaSlider.value,self.redSlider.value,self.greenSlider.value,self.blueSlider.value];
//            Color.argb(alpha, red, green, blue)
            break;
        case 4:
            self.colorText.text = [NSString stringWithFormat:@"rgba(%.2f,%.2f,%.2f,%.2f)",self.redSlider.value,self.greenSlider.value,self.blueSlider.value,self.alphaSlider.value];
//            rgba(r,g,b,透明度)
            break;
        default:
            break;
    }
}

//将UIColor转换为RGB值
- (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    float a = [[RGBArr objectAtIndex:4] floatValue];
    RGBStr = [NSString stringWithFormat:@"%f",a];
    [RGBStrValueArr addObject:RGBStr];
    
//    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    int r = [[RGBArr objectAtIndex:1] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

@end

