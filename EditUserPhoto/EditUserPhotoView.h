//
//  EditUserPhotoView.h
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditUserSquareView.h"
@class EditUserPhotoView;

@protocol EditUserPhotoViewDelegate <NSObject>

- (void)editUserSquareView:(EditUserSquareView *)editUserSquareView didSelectNumIndex:(NSInteger)index;

@end

@interface EditUserPhotoView : UIView

//获取当前排序
@property (nonatomic,strong) NSArray * currentImageArray;

@property (nonatomic,weak) id <EditUserPhotoViewDelegate> editUserPhotoViewDelegate;

- (void)refreshImageData:(NSArray *)imageUrlArray;

//删除
- (void)deleteEditUserSquareView:(EditUserSquareView *)squareView index:(NSInteger)index;

//增加
- (void)addEditUserSquareView:(EditUserSquareView *)squareView imageNetPatch:(NSString *)imageNetPatch;























@end
