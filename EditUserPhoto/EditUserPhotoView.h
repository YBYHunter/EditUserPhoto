//
//  EditUserPhotoView.h
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditUserSquareView.h"
#import "EditUserSquareModel.h"
@class EditUserPhotoView;

@protocol EditUserPhotoViewDelegate <NSObject>

- (void)editUserSquareView:(EditUserSquareView *)editUserSquareView didSelectNumIndex:(NSInteger)index;

@end

@interface EditUserPhotoView : UIView

@property (nonatomic,weak) id <EditUserPhotoViewDelegate> editUserPhotoViewDelegate;

//获取当前排序 可能含有临时数据
- (NSArray *)arrayWithCurrentSucceedSortModelArray;

//是否修改过 - yes 修改了
- (BOOL)hasModifiedWithModelArray;

//是否有临时数据 - yes 有临时数据
- (BOOL)hasTempDataWithModelArray;

//刷新数据
- (void)refreshImageData:(NSArray *)imageUrlArray sortID:(NSArray *)sortID;

//删除 移动位置
- (void)deleteEditUserSquareView:(EditUserSquareView *)squareView index:(NSInteger)index;

//增加 移动位置
- (void)addEditUserSquareView:(EditUserSquareView *)squareView;

//修改/更新数据 (增加后需要刷新数据)
- (void)modifyUserSquareView:(EditUserSquareView *)squareView type:(EditUserSquareModelType)type;





















@end
