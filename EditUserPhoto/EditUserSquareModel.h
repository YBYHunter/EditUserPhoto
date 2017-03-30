//
//  EditUserSquareModel.h
//  gmu
//
//  Created by 于博洋 on 2017/3/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditUserSquareModelType) {
    EditUserSquareModelTypeNone,                 //没有图片      //不可以移动
    EditUserSquareModelTypeImageUploading,       //图片上传中     //可以移动
    EditUserSquareModelTypeImageLoading,         //图片下载中     //可以移动
    EditUserSquareModelTypeImageLoadSuccessful,  //图片加载完成    //可以移动
    EditUserSquareModelTypeImageLoadFailure,     //图片加载完成    //可以移动
    EditUserSquareModelTypeOnly,                 //唯一的图片      //不可能移动
};

@interface EditUserSquareModel : NSObject

@property (nonatomic,copy) NSString * squareViewID;

@property (nonatomic,copy) NSString * squareImageUrl;

@property (nonatomic,assign) EditUserSquareModelType squareType;

//临时数据 重新上传需要
@property (nonatomic,strong) UIImage * tempImage;

@end


















