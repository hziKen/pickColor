//
//  MainViewController.m
//  PickColor
//
//  Created by fory1 on 2018/1/19.
//  Copyright © 2018年 fory1. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "ChooseColorVC.h"
#import "Masonry.h"
#import "ChooseColorVC.h"
#import "UIViewController+CWLateralSlide.h"
#import "PickView.h"
#import "ShowDepositView.h"

@interface MainViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *backgroundImageV;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *viewCircle;
@property(nonatomic,assign)CGFloat scale;
@property (nonatomic,assign) CGFloat totalScale;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSMutableArray *colorArr;
@property (nonatomic,strong) PickView *pickView;

@end

@implementation MainViewController
#pragma mark -- lazyloading
- (NSMutableArray *)colorArr
{
    if (!_colorArr) {
        _colorArr = [[NSMutableArray alloc] init];
    }
    return _colorArr;
}
#pragma mark -- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Select";
    [self setUpView];
    [self createUI];
    [self setupNavBarItem];
}
#pragma mark -- 自定义方法
- (void)setUpView
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil) {
        ShowDepositView *view = [ShowDepositView instance];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)setupNavBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu button"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Introduction button"] style:UIBarButtonItemStylePlain target:self action:@selector(question)];
      UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Album button"] style:UIBarButtonItemStylePlain target:self action:@selector(selectImageBtnClick)];
    self.navigationItem.rightBarButtonItems = @[select,question];
    

}
- (void)createUI{
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake((HZKScreenW - 300) / 2, (HZKScreenH - 300) / 2 - 100, 300, 300);
//    selectBtn.backgroundColor = [UIColor orangeColor];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"Selectanimage"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"Selectanimage"] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(selectImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [self.view addSubview:selectBtn];
}
#pragma mark -- 用户点击事件
- (void)question{
    ShowDepositView *view = [ShowDepositView instance];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}
- (void)selectImageBtnClick
{
    //自定义消息框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"From Album", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}
// 导航栏左边按钮的点击事件
- (void)leftClick {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    vc.drawerType = DrawerDefaultLeft;
    
    // 或者这样调用
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
    
}
#pragma mark -- 图片颜色相关
//计算imageView的frame
-(CGRect)getImageByScaleFromImage:(UIImage *)image
{
    CGFloat widthScale = image.size.width / HZKScreenW;
    CGFloat heightScale = image.size.height / HZKScreenH;
    self.scale = MAX(widthScale, heightScale);
    //    return CGRectMake(0, (HZKScreenH - (image.size.height - 64) / self.scale) / 2.0, image.size.width / self.scale, image.size.height / self.scale);
    return CGRectMake(0, 0, image.size.width / self.scale, image.size.height / self.scale);
}
//修正图片的旋转方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (void)configWithImage:(UIImage *)selectImage{

    self.imageView = nil;
    self.scrollView = nil;
    self.backgroundImageV = nil;
    self.viewCircle = nil;
    UIImage *image = [self fixOrientation:selectImage];
    NSLog(@"123  %f %f",image.size.width,image.size.height);
    
    //将照片放入UIImageView对象中；
    self.imageView=[[UIImageView alloc]init];
    self.imageView.frame=[self getImageByScaleFromImage:image];
    self.imageView.image = image;
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView setMultipleTouchEnabled:YES];
    self.totalScale = 1.0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTappedPickerView:)];
    
    [singleTap setNumberOfTapsRequired:1];
    [self.imageView addGestureRecognizer:singleTap];

    self.backgroundImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y, image.size.width, image.size.height)];
    self.backgroundImageV.image = image;
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
//    scrollView.contentSize = image.size;
    scrollView.delegate=self;
    //设置最大伸缩比例
    scrollView.maximumZoomScale=5.0;
    //设置最小伸缩比例
    scrollView.minimumZoomScale=1.0;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;

    [self.view addSubview:self.backgroundImageV];
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.imageView];
    
    PickView *pickView = [PickView sharePickView];
    pickView.frame = CGRectMake(0,0, 60, 60);
    self.pickView = pickView;
    [self.imageView addSubview:pickView];

    //取色按钮
    UIButton *pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pickBtn.frame = CGRectMake((HZKScreenW - 180) / 2, HZKScreenH - 150, 180, 50);
    pickBtn.layer.cornerRadius = 10;
    pickBtn.layer.masksToBounds = YES;
    pickBtn.backgroundColor = [UIColor orangeColor];
    [pickBtn setTitle:@"Pick Color" forState:UIControlStateNormal];
    [pickBtn addTarget:self action:@selector(pickBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickBtn];
    
}
- (void)pickBtnClick
{
    if (self.colorArr.count == 0 || self.colorArr == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择一种颜色~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    ChooseColorVC *vc = [[ChooseColorVC alloc] init];
    vc.colorArr = self.colorArr;
    [self.navigationController pushViewController:vc animated:YES];
}
  //取得所点击的点的坐标
- (void)sigleTappedPickerView:(UIGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:_imageView];
    self.viewCircle.center = point;
    self.pickView.center = point;
    NSLog(@"x=%fy=%f",point.x,point.y);
    self.color = [self getPixelColorAtLocation:point];
}


- (UIColor*)getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = [UIColor whiteColor];
    [self.colorArr removeAllObjects];
    if (point.x < self.imageView.frame.size.width && point.x > 0 && point.y < self.imageView.frame.size.height && point.y > 0) {
        
        UIImageView *colorImageView=self.backgroundImageV;
        
        CGImageRef inImage = colorImageView.image.CGImage;
        
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        
        CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
        
        if (cgctx == NULL)
        {
            return nil;
        }

        size_t w = CGImageGetWidth(inImage);
        
        size_t h = CGImageGetHeight(inImage);
        
        CGRect rect = {{0,0},{w,h}};
      
        // Draw the image to the bitmap context. Once we draw, the memory
        
        // allocated for the context for rendering will then contain the
        
        // raw image data in the specified color space.
        
        CGContextDrawImage(cgctx, rect, inImage);
       
        // Now we can get a pointer to the image data associated with the bitmap
        
        // context.
        
        unsigned char* data = CGBitmapContextGetData (cgctx);
        
        if (data != NULL)
            
        {//offset locates the pixel in the data from x,y.
            
            //4 for 4 bytes of data per pixel, w is width of one row of data.
            
            @try
            {
                int offset = 4*((w*round(point.y * self.scale))+round(point.x * self.scale));
                
                //NSLog(@"offset: %d", offset);
                
                int alpha =  data[offset];
                
                int red = data[offset+1];
                
                int green = data[offset+2];
                
                int blue = data[offset+3];
                
                //            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
                NSLog(@"%d%d%d",red,green,blue);
                [self.colorArr addObject:@(alpha / 255.0f)];
                [self.colorArr addObject:@(red)];
                [self.colorArr addObject:@(green)];
                [self.colorArr addObject:@(blue)];
                color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];

                
            }
            @catch (NSException * e)
            {
                NSLog(@"%@",[e reason]);
            }
            @finally
            {
           
            }
    
        }
 
        // When finished, release the context
        
        CGContextRelease(cgctx);
        
        // Free image data memory for the context
        
        if (data)
        {
            free(data);
        }
        
    }
    self.pickView.backgroundColor = color;
    return color;
    
}



- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage

{
    CGContextRef    context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *          bitmapData;
    
    int             bitmapByteCount;
    
    int             bitmapBytesPerRow;

    // Get image width, height. We'll use the entire image.
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    
    // alpha.
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    
    bitmapByteCount     =(int)(bitmapBytesPerRow * pixelsHigh);
 
    // Use the generic RGB color space.
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    
    if (colorSpace == NULL)
        
    {
        
        fprintf(stderr, "Error allocating color space\n");
        
        return NULL;
        
    }
    // Allocate memory for image data. This is the destination in memory
    
    // where any drawing to the bitmap context will be rendered.
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
        
    {
        
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
        
    }
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    
    // per component. Regardless of what the source image format is
    
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    
    // specified here by CGBitmapContextCreate.
    
    context = CGBitmapContextCreate (bitmapData,
                                     
                                     pixelsWide,
                                     
                                     pixelsHigh,
                                     
                                     8,      // bits per component
                                     
                                     bitmapBytesPerRow,
                                     
                                     colorSpace,
                                     
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
        
    {
        
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
        
    }
// Make sure and release colorspace before returning
    
    CGColorSpaceRelease( colorSpace );
  
    return context;

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
//    CGRect frame = self.imageView.frame;
    
//    frame.origin.y = (self.scrollView.frame.size.height - self.imageView.frame.size.height) > 0 ? (self.scrollView.frame.size.height - self.imageView.frame.size.height) * 0.5 : 0;
//    frame.origin.x = (self.scrollView.frame.size.width - self.imageView.frame.size.width) > 0 ? (self.scrollView.frame.size.width - self.imageView.frame.size.width) * 0.5 : 0;
//    self.imageView.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width + 10, self.imageView.frame.size.height + 10);
}
#pragma mark -- delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    [self configWithImage:image];
    [self.selectBtn removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2550) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
                
            }else if (buttonIndex == 1) {
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
@end
