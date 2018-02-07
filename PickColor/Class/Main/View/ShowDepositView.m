//
//  ShowDepositView.m
//  BCB
//
//  Created by 健 on 2017/9/13.
//  Copyright © 2017年 baicaibang. All rights reserved.
//

#import "ShowDepositView.h"
@interface ShowDepositView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (nonatomic,assign) CGRect oldFrame;
@property (nonatomic,assign) CGRect largeFrame;


@end

@implementation ShowDepositView
- (void)awakeFromNib
{
    [super awakeFromNib];
    // 缩放手势
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [_bgImage setMultipleTouchEnabled:YES];
    [_bgImage setUserInteractionEnabled:YES];
    [_bgImage addGestureRecognizer:pinchGestureRecognizer];

    _oldFrame = _bgImage.frame;
    _largeFrame = CGRectMake(0 - HZKScreenW, 0 - HZKScreenH, 4 * HZKScreenW, 4 * HZKScreenH);
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer

{
    
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
//        if (_bgImage.frame.size.width < _oldFrame.size.width)
//            
//        {
//            
//            _bgImage.frame = _oldFrame;
//            
//            //让图片无法缩得比原图小
//            
//        }
        
        if (_bgImage.frame.size.width > 4 * _oldFrame.size.width)
            
        {
            
            _bgImage.frame = _largeFrame;
            
        }
        
        pinchGestureRecognizer.scale = 1;
        
    }
    
}


+ (instancetype)instance{
    ShowDepositView *view = [[NSBundle mainBundle] loadNibNamed:@"ShowDepositView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, HZKScreenW, HZKScreenH);
    
    return view;
}

- (void)showInView:(UIView *)view {
    
    for (UIView *view1 in view.subviews) {
        if ([view1 isKindOfClass:[self class]]) {
            [view1 removeFromSuperview];
        }
    }
    
    [view addSubview:self];
}



- (IBAction)closeBtnClick:(id)sender {
    
    [self removeFromSuperview];
}

@end
