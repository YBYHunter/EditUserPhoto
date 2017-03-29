//
//  EditUserSquareView.h
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditUserSquareViewType) {
    EditUserSquareViewTypeNone,                 //没有图片      //不可以移动
    EditUserSquareViewTypeImageLoading,         //图片加载中     //可以移动
    EditUserSquareViewTypeImageLoadSuccessful,  //图片加载完成    //可以移动
    EditUserSquareViewTypeImageLoadFailure,     //图片加载完成    //可以移动
    EditUserSquareViewTypeOnly,                 //唯一的图片      //不可能移动
};


@interface EditUserSquareView : UIView

@property (nonatomic,assign,readonly) EditUserSquareViewType currentType;

- (void)changeType:(EditUserSquareViewType)squareViewType otherData:(id)otherData;

@end
