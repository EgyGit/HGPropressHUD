//
//  LWPropressHUD.m
//  LWLoadingView
//
//  Created by kuxing on 16-4-10.
//  Copyright (c) 2016年 Yang. All rights reserved.
//

#import "HGPropressHUD.h"
#define MaxWith  280.0
#define MinWith  100.0

@interface HGPropressHUD ()

@property (nonatomic, strong) UIView *platView;
@property (nonatomic, assign) UIView *targetView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HGPropressHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (id)initWithTargetView:(UIView *)targetView
{
    CGRect frame = targetView.bounds;
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0))
    {
        frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubViews];
        self.targetView = targetView;
        self.type = HGPropressHUDOnlyIndicator;
        self.offset_y = 0;
    }
    return self;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    return _indicatorView;
}

- (void)setType:(HGPropressHUDType)type
{
    _type = type;
    
    [self updateFrame];
}

- (void)setTextString:(NSString *)textString
{
//    @synchronized (self)
//    {
        textString = [textString isEqualToString:@""] ? nil: textString;
        
        _textString = textString;
        self.textLabel.text = textString;
        //    CGSize labelSize = [textString sizeWithFont:_textLabel.font constrainedToSize:CGSizeMake(MaxWith, MAXFLOAT)];
        CGSize labelSize = [textString boundingRectWithSize:CGSizeMake(MaxWith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size;
        self.textLabel.frame = CGRectMake(10, 0, labelSize.width, labelSize.height);
        
        [self updateFrame];
//    }
}

- (void)setCustomView:(UIView *)customView
{
    _customView = customView;
    
    if (self.type == HGPropressHUDOnlyCustom || self.type == HGPropressHUDCustomWithText)
    {
        [self updateFrame];
    }
}


- (void)updateFrame
{
    float width;
    float height;
    
    switch (self.type)
    {
        case HGPropressHUDOnlyText:
        {
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            [self.customView removeFromSuperview];
            width  = self.textLabel.frame.size.width + 30;
            height = self.textLabel.frame.size.height + 20;
            
            width  = MAX(width, MinWith - 40);
            height = MAX(height, MinWith - 40);
            
            self.textLabel.center = CGPointMake(width/2.0, height/2.0);
        }
            break;
        case HGPropressHUDOnlyIndicator:
        {
            _textString = nil;
            self.textLabel.frame = CGRectZero;
        }
        case HGPropressHUDIndicatorWithText:
        {
            [self.customView removeFromSuperview];
            
            width  = self.textLabel.frame.size.width + 20;
            height = 10 + self.textLabel.frame.size.height + 10 + self.indicatorView.frame.size.width + 20;
            
            width  = (width > MinWith) ? width : MinWith;
            height = (height > MinWith) ? height : MinWith;
            
            if (![self.indicatorView superview])
            {
                [self.platView addSubview:self.indicatorView];
            }
            
            if (self.textLabel.frame.size.height == 0)
            {
                self.indicatorView.center = CGPointMake(width/2.0, height/2.0);
            }else
            {
                self.indicatorView.center = CGPointMake(width / 2.0, (height - self.textLabel.frame.size.height) / 2.0);
                self.textLabel.center = CGPointMake(width / 2.0, (height + self.indicatorView.frame.size.height + 20) / 2.0);
            }
            
            [self.indicatorView startAnimating];
            
        }
            break;
        case HGPropressHUDOnlyCustom:
        {
            _textString = nil;
            self.textLabel.frame = CGRectZero;
        }
        case HGPropressHUDCustomWithText:
        {
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            
            if (![self.customView superview])
            {
                [self.platView addSubview:self.customView];
            }
            
            float tempMaxW = MAX(MAX(self.customView.frame.size.width, self.customView.frame.size.height) * 1.6, MinWith);
            
            width = self.textLabel.frame.size.width + 20;
            height = 10 + self.textLabel.frame.size.height + 10 + self.customView.frame.size.width + 20;
            
            width = MAX(width, tempMaxW);
            height = MAX(height, tempMaxW);
            
            if (self.textLabel.frame.size.height == 0)
            {
                self.customView.center = CGPointMake(width/2.0, height/2.0);
            }else
            {
                self.customView.center = CGPointMake(width / 2.0, (height - self.textLabel.frame.size.height) / 2.0);
                self.textLabel.center = CGPointMake(width / 2.0, (height + self.customView.frame.size.height + 20) / 2.0);
            }
        }
            break;
        default:
            break;
    }
    
    
    self.platView.frame = CGRectMake((self.frame.size.width - width)/2.0, (self.frame.size.height - height)/2.0+self.offset_y, width, height);
}

- (void)createSubViews
{
    //    self.backgroundColor = [UIColor grayColor];
    
    self.platView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 100)/2.0, (self.frame.size.height - 100)/2.0+self.offset_y, 100, 100)];
    self.platView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.platView.layer.cornerRadius = 10;
    [self addSubview:self.platView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    [self.platView addSubview:self.textLabel];
}

- (void)setBGColor:(UIColor *)bgColor
{
    self.platView.backgroundColor = bgColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

- (void)show
{
    if (![self superview])
    {
        [self.targetView addSubview:self];
        if ([[self superview] isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *supView = (UIScrollView *)[self superview];
            supView.scrollEnabled = NO;
        }
    }
}

- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString
{
    if (type == HGPropressHUDOnlyText && !textString && textString.length <= 0)
    {
        return;
    }
    self.type = type;
    self.textString = textString;
    [self show];
}

- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString hiddenAfterDelay:(NSTimeInterval)interval
{
    [self showWithType:type andTextString:textString hiddenAfterDelay:interval completion:nil];
}

- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString hiddenAfterDelay:(NSTimeInterval)interval completion:(void (^)(void))completion
{
    [self showWithType:type andTextString:textString];
    [self hiddeAfterDelay:interval completion:completion];
}

- (void)showAfterDelay:(NSTimeInterval)interval
{
    [self performSelector:@selector(show) withObject:nil afterDelay:interval];
}

- (void)hidden
{
    [self hiddenWithCompletion:nil];
}

- (void)hiddeAfterDelay:(NSTimeInterval)interval
{
    [self performSelector:@selector(hidden) withObject:nil afterDelay:interval];
}

- (void)hiddenWithCompletion:(void (^)(void))completion
{
    if ([[self superview] isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *supView = (UIScrollView *)[self superview];
        supView.scrollEnabled = YES;
    }
    [self removeFromSuperview];
    
    if (completion)
    {
        completion();
    }
}

- (void)hiddeAfterDelay:(NSTimeInterval)interval completion:(void(^)(void))completion
{
    [self performSelector:@selector(hiddenWithCompletion:) withObject:completion afterDelay:interval];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self hidden];
}

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

@end
