//
//  EditUserSquareView.h
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditUserSquareModel.h"

@interface EditUserSquareView : UIView

@property (nonatomic,strong) EditUserSquareModel * editUserSquareModel;

@property (nonatomic,strong) UIActivityIndicatorView * loadingActivityIndicator;

//通过Type来改变UI
- (void)changeTypeWithSquareView:(EditUserSquareView *)squareView;

@end
