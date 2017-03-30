//
//  JMActionSheet.m
//  gmu
//
//  Created by carl on 16/7/18.
//  Copyright © 2016年 yu. All rights reserved.
//

/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

//设置颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define RGBONLYCOLOR(x) [UIColor colorWithRed:(x)/255.0 green:(x)/255.0 blue:(x)/255.0 alpha:1]
#define RGBAONLYCOLOR(x,a) [UIColor colorWithRed:(x)/255.0 green:(x)/255.0 blue:(x)/255.0 alpha:(a)]
#define RGBREDCOLOR [UIColor colorWithRed:(255)/255.0 green:(51)/255.0 blue:(0)/255.0 alpha:1]

#import "JMActionSheet.h"
#import "UIView+addition.h"

@implementation JMActionSheet

+ (JMActionSheet *)shareJMActionSheet {
    static dispatch_once_t once;
    static JMActionSheet *sharedJMActionSheet;
    dispatch_once(&once, ^ {
        sharedJMActionSheet = [[self alloc] init];

        sharedJMActionSheet.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        sharedJMActionSheet.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissJMActionSheet:)];
        [sharedJMActionSheet addGestureRecognizer:tap];
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 6 * 2, SCREEN_HEIGHT)];
        bgView.alpha = 0.95;
        bgView.tag = 4001;
        bgView.layer.cornerRadius = 10;

        for (int i = 0; i < 10; i++) {
            
            UIButton * sheetButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sheetButton.tag = 3000 + i;
            
            sheetButton.titleLabel.font = [UIFont systemFontOfSize:15];
            sheetButton.frame = CGRectMake(999, 999, bgView.frame.size.width, 55);
            [sheetButton addTarget:self action:@selector(alertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [sharedJMActionSheet addSubview:sheetButton];
            
            
        }
        
        [sharedJMActionSheet addSubview:bgView];
        
        
        
    });
    return sharedJMActionSheet;
}

+ (void)showTitle:(NSArray *)array type:(JMActionSheetType)type {
    UIView * shareJMActionSheet = [self shareJMActionSheet];

    shareJMActionSheet.alpha = 1;
    if (array.count <= 0 || array.count > 10) {
        NSLog(@"JMActionSheet错误!!!!!!!!!");
        return;
    }
    UIView * bgView = [shareJMActionSheet viewWithTag:4001];
    UIButton * tempSheetButton = [shareJMActionSheet viewWithTag:(3000 + 0)];
    bgView.top = SCREEN_HEIGHT - (tempSheetButton.height * array.count);
    bgView.height = (tempSheetButton.height * array.count);
    
    for (int i = 0; i < array.count; i++) {
        UIButton * sheetButton = [shareJMActionSheet viewWithTag:(3000 + i)];
        sheetButton.left = 6;
        sheetButton.top = i * sheetButton.height + bgView.top;
        [sheetButton setTitle:array[i] forState:UIControlStateNormal];
        [shareJMActionSheet addSubview:sheetButton];
        
        UIView * lineView = [[UIView alloc] init];
        if (type == JMActionSheetTypeYellow) {
            lineView.backgroundColor = [UIColor blackColor];
            bgView.backgroundColor = RGBONLYCOLOR(238);
            bgView.alpha = 1;
            [sheetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else {
            lineView.backgroundColor = [UIColor whiteColor];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha = 0.9;
            [sheetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        lineView.tag = 5001;
        lineView.alpha = 0.4;
        lineView.frame = CGRectMake(sheetButton.left, sheetButton.bottom - 1, sheetButton.width, 0.5);
        [shareJMActionSheet addSubview:lineView];
    }

    [self startAnimation];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        [window addSubview:shareJMActionSheet];
    });
}

+ (void)startAnimation {
    UIView * shareJMActionSheet = [self shareJMActionSheet];
    shareJMActionSheet.top = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        shareJMActionSheet.top = -6;
        
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)alertButtonAction:(UIButton *)sneder {
    [self dismissJMActionSheet:sneder.titleLabel.text];
    
}

+ (void)dismissJMActionSheet:(NSString *)title {
    
    JMActionSheet * shareJMActionSheet = [self shareJMActionSheet];
    
    [UIView animateWithDuration:0.2 animations:^{
        shareJMActionSheet.alpha = 0;
    } completion:^(BOOL finished) {
        shareJMActionSheet.alpha = 0;
        if (finished) {
            NSArray * lineArray = shareJMActionSheet.subviews;
            for (int i = 0; i < lineArray.count; i++) {
                if ([lineArray[i] isKindOfClass:[UIView class]]) {
                    UIView * lineView = lineArray[i];
                    if (lineView.tag == 5001) {
                        [lineView removeFromSuperview];
                    }
                    
                    if ([lineArray[i] isKindOfClass:[UIButton class]]) {
                        UIButton * button = lineArray[i];
                        button.left = 9999;
                    }
                }
            }
            [shareJMActionSheet removeFromSuperview];
            if ([title isKindOfClass:[NSString class]] && title.length > 0) {
                if (shareJMActionSheet.clickCancle) {
                    shareJMActionSheet.clickCancle(title);
                }
            }
        }
    }];
}



















@end
