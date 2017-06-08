//
//  LWPropressHUD.h
//  LWLoadingView
//
//  Created by kuxing on 16-4-10.
//  Copyright (c) 2016年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HGPropressHUDType)
{
    HGPropressHUDOnlyText,
    HGPropressHUDOnlyIndicator,
    HGPropressHUDOnlyCustom,
    HGPropressHUDIndicatorWithText,
    HGPropressHUDCustomWithText,
};

@interface HGPropressHUD : UIView

- (id)initWithTargetView:(UIView *)targetView;

@property (nonatomic, strong) UIView            *customView;
@property (nonatomic, copy  ) NSString          *textString;
@property (nonatomic, assign) HGPropressHUDType type;
@property (nonatomic, assign) NSInteger         offset_y;
@property (nonatomic, assign) BOOL              touchHidden;// 仅支持LWPropressHudCustomType

//- (void)show;
- (void)setBGColor:(UIColor *)bgColor;
- (void)setTextColor:(UIColor *)textColor;
- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString;
- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString hiddenAfterDelay:(NSTimeInterval)interval;
- (void)showWithType:(HGPropressHUDType)type andTextString:(NSString *)textString hiddenAfterDelay:(NSTimeInterval)interval completion:(void (^)(void))completion;
- (void)hidden;
- (void)showAfterDelay:(NSTimeInterval)interval;
- (void)hiddeAfterDelay:(NSTimeInterval)interval;
- (void)hiddenWithCompletion:(void (^)(void))completion;

@end
