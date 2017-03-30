//
//  EditUserPhotoView.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "EditUserPhotoView.h"

static CGFloat const EachViewInterval = 1;

static CGFloat const LongPressNarrowWidth = 80;


@interface EditUserPhotoView ()<UIGestureRecognizerDelegate>

//初始化固定顺序的数组 count == 6
@property (nonatomic,copy) NSArray * imagesArray;

//改变顺序的可变数组 count == 6
@property (nonatomic,strong) NSMutableArray * changeOrderimagesArray;

//里面的数据为NSValue类型 count == 6
@property (nonatomic,copy) NSArray * imagesFrameArray;

//上一次进入的View
@property (nonatomic,strong) EditUserSquareView * lastPassIntoView;

//初始化ID数据
@property (nonatomic,copy) NSArray * fristImagesIDArray;

@end


@implementation EditUserPhotoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initAllView];
        [self layoutSubviewsWithFrame:frame];
    
        _changeOrderimagesArray = [NSMutableArray arrayWithArray:self.imagesArray];
    }
    return self;
}

#pragma mark - 对外暴露方法

//获取当前排序 可能含有临时数据
- (NSArray *)arrayWithCurrentSortModelArray {
    
    NSMutableArray * currentSortIDArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _changeOrderimagesArray.count; i++) {
        EditUserSquareView * editUserSquareView = _changeOrderimagesArray[i];
        //加载成功
        if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadSuccessful || editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeOnly ||
            editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoading ||
            editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageUploading ||
            editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadFailure) {
            
            [currentSortIDArray addObject:editUserSquareView.editUserSquareModel];
        }
        else {
            //没有图片
            //EditUserSquareModelTypeNone
            
        }
    }
    
    return [currentSortIDArray copy];
}

//获取当前排序
- (NSArray *)arrayWithCurrentSucceedSortModelArray {
    
    NSMutableArray * currentSortIDArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _changeOrderimagesArray.count; i++) {
        EditUserSquareView * editUserSquareView = _changeOrderimagesArray[i];
        
        if (editUserSquareView.editUserSquareModel.squareViewID && editUserSquareView.editUserSquareModel.squareViewID.length > 0) {
            
            [currentSortIDArray addObject:editUserSquareView.editUserSquareModel];
        }
        else {
            
        }
    }
    
    return [currentSortIDArray copy];
}

//是否修改过
- (BOOL)hasModifiedWithModelArray {
    
    NSArray * currentImagesIDArray = [self arrayWithCurrentSucceedSortModelArray];
    
    BOOL isSame = YES;
    if (currentImagesIDArray.count == _fristImagesIDArray.count) {
        
        for (int i = 0; i < _fristImagesIDArray.count; i++) {
            
            EditUserSquareModel * fristModel = [_fristImagesIDArray objectAtIndex:i];
            EditUserSquareModel * currentModel = [currentImagesIDArray objectAtIndex:i];
            if (![fristModel.squareViewID isEqualToString:currentModel.squareViewID]) {
                isSame = NO;
                break;
            }
        }
    }
    else {
        isSame = NO;
    }
    
    return isSame;
}

- (BOOL)hasTempDataWithModelArray {
    
    BOOL hasTempData = NO;
    for (int i = 0; i < _changeOrderimagesArray.count; i++) {
        EditUserSquareView * editUserSquareView = _changeOrderimagesArray[i];
        if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoading ||
            editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageUploading ||
            editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadFailure) {
            
            hasTempData = YES;
            return hasTempData;
        }
    }
    return hasTempData;
}

//刷新数据
- (void)refreshImageData:(NSArray *)imageUrlArray sortID:(NSArray *)sortID {
    
    for (int i = 0; i < _changeOrderimagesArray.count; i++) {
        
        //初始化model数据
        EditUserSquareView * editUserSquareView = _changeOrderimagesArray[i];
        if (i >= imageUrlArray.count) {
            editUserSquareView.editUserSquareModel.squareType = EditUserSquareModelTypeNone;
        }
        else {
            editUserSquareView.editUserSquareModel.squareType = EditUserSquareModelTypeImageLoadSuccessful;
            editUserSquareView.editUserSquareModel.squareViewID = sortID[i];
            editUserSquareView.editUserSquareModel.squareImageUrl = imageUrlArray[i];
        }
        
        _fristImagesIDArray = [self arrayWithCurrentSucceedSortModelArray];
        //更新UI
        [editUserSquareView changeTypeWithSquareView:editUserSquareView];
    }
}

//删除
- (void)deleteEditUserSquareView:(EditUserSquareView *)squareView index:(NSInteger)index {
    
    NSArray * currentSortModelArray = [self arrayWithCurrentSortModelArray];
    
    if (currentSortModelArray.count <= 0 || (currentSortModelArray.count - 1) >= _changeOrderimagesArray.count) {
        NSLog(@"error:deleteEditUserSquareView:出错了");
    }
    
    //更新model和UI
    EditUserSquareView * toSquareView = squareView;
    [self modifyUserSquareView:toSquareView type:EditUserSquareModelTypeNone];
    
    //移动 fromeSquareView 只要更新frame就可以
    EditUserSquareView * fromeSquareView = _changeOrderimagesArray[currentSortModelArray.count - 1];
    if (fromeSquareView != toSquareView) {
        toSquareView.frame = fromeSquareView.frame;
        [self moveUserSquareViewWithToView:toSquareView fromView:fromeSquareView];
    }

    
}

//增加
- (void)addEditUserSquareView:(EditUserSquareView *)squareView {
    
    NSArray * currentSortModelArray = [self arrayWithCurrentSortModelArray];
    
    if (currentSortModelArray.count >= _changeOrderimagesArray.count) {
        NSLog(@"error:addEditUserSquareView:出错了");
        return;
    }
    
    [self modifyUserSquareView:squareView type:EditUserSquareModelTypeImageUploading];
    //移动
    EditUserSquareView * fromeSquareView = _changeOrderimagesArray[currentSortModelArray.count];
    if (fromeSquareView != squareView) {
        squareView.frame = fromeSquareView.frame;
        [self moveUserSquareViewWithToView:squareView fromView:fromeSquareView];
    }
}

- (void)modifyUserSquareView:(EditUserSquareView *)squareView type:(EditUserSquareModelType)type {
    //更新model和UI
    squareView.editUserSquareModel.squareType = type;
    [squareView changeTypeWithSquareView:squareView];
    
}

#pragma mark - UITapGestureRecognizer

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    EditUserSquareView * tapEditUserSquareView = (EditUserSquareView *)tap.view;
    NSArray * currentSortIDArray = [self arrayWithCurrentSortModelArray];
    
    if (currentSortIDArray.count <= 1 && tapEditUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadSuccessful) {
        tapEditUserSquareView.editUserSquareModel.squareType = EditUserSquareModelTypeOnly;
    }
    
    NSInteger toIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:tap.view];
    if ([self.editUserPhotoViewDelegate respondsToSelector:@selector(editUserSquareView:didSelectNumIndex:)]) {
        [self.editUserPhotoViewDelegate editUserSquareView:tapEditUserSquareView didSelectNumIndex:toIndex];
    }
}


#pragma mark - Animation


- (void)moveAnimationWithFrame:(CGRect)frame moveView:(UIView *)moveView delay:(NSInteger)delay {
    
    [UIView animateWithDuration:0.5 delay:delay * 0.05 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        moveView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - handleTableviewCellLongPressed

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    EditUserSquareView * imageView = (EditUserSquareView *)gestureRecognizer.view;
    //没有照片不可以长按
    if (imageView.editUserSquareModel.squareType == EditUserSquareModelTypeNone) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGFloat trans = LongPressNarrowWidth/imageView.frame.size.width;
        [UIView animateWithDuration:0.2 animations:^{
            imageView.center = point;
            imageView.transform = CGAffineTransformMakeScale(trans, trans);
        }];
        [self bringSubviewToFront:imageView];
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        imageView.center = CGPointMake(point.x, point.y);
        //进入到哪个View
        EditUserSquareView * passIntoView = [self getPassIntoView:imageView touchPoint:point];
        
        //没有照片不移动
        if (passIntoView.editUserSquareModel.squareType == EditUserSquareModelTypeNone) {
            
            return;
        }
        
        //上次进入和这次进入 相同 不移动
        if (passIntoView == _lastPassIntoView) {
            return;
        }
        
        _lastPassIntoView = passIntoView;
        
        [self moveUserSquareViewWithToView:imageView fromView:passIntoView];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        NSInteger toIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:imageView];
        //进入到哪个View
        EditUserSquareView * passIntoView = [self getPassIntoView:imageView touchPoint:point];
        
        CGRect passIntoViewFrame = CGRectZero;
        if (passIntoView.editUserSquareModel.squareType == EditUserSquareModelTypeNone) {
            //没有照片不移动
            NSValue * toFrameValue = self.imagesFrameArray[toIndex];
            passIntoViewFrame = [toFrameValue CGRectValue];
        }
        else {
            passIntoViewFrame = [self rectPassIntoViewFrameWithtouchPoint:point touchNum:toIndex];
        }

        imageView.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.82 initialSpringVelocity:25 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.frame = passIntoViewFrame;
        } completion:^(BOOL finished) {
            
        }];
        
        _lastPassIntoView = nil;
    }
}

- (void)moveUserSquareViewWithToView:(UIView *)toView fromView:(UIView *)passIntoView {
    
    NSInteger toIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:toView];
    NSInteger fromIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:passIntoView];
    
    if (passIntoView && toIndex != fromIndex) {
        
        //往数组队列前
        if (toIndex > fromIndex) {
            //先删除
            [_changeOrderimagesArray removeObjectAtIndex:toIndex];
            
            //计算出可能需要移动的View
            NSRange range = NSMakeRange(0, toIndex);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            NSArray * needMoveImageArray = [_changeOrderimagesArray objectsAtIndexes:indexSet];
            
            for (int i = 0; i < needMoveImageArray.count; i++) {
                //只有需要移动的View大于移动到的View 才真的移动
                if (i >= fromIndex) {
                    
                    UIView * upNeedMoveView = needMoveImageArray[i];
                    NSValue * frameValue = self.imagesFrameArray[i + 1];
                    
                    [self moveAnimationWithFrame:[frameValue CGRectValue] moveView:upNeedMoveView delay:i];
                }
            }
            //然后添加进去
            [_changeOrderimagesArray insertObject:toView atIndex:fromIndex];
        }
        else {
            //往数组队列后
            
            //计算出可能需要移动的View
            NSRange range = NSMakeRange(toIndex + 1, self.imagesFrameArray.count - 1 - toIndex);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            NSArray * needMoveImageArray = [_changeOrderimagesArray objectsAtIndexes:indexSet];
            
            for (int i = 0; i < needMoveImageArray.count; i++) {
                
                NSInteger tempIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:needMoveImageArray[i]];
                //只有需要移动的View大于移动到的View 才真的移动
                if (tempIndex <= fromIndex) {
                    UIView * upNeedMoveView = needMoveImageArray[i];
                    NSValue * frameValue = nil;
                    frameValue = self.imagesFrameArray[tempIndex - 1];
                    
                    [self moveAnimationWithFrame:[frameValue CGRectValue] moveView:upNeedMoveView delay:i];
                }
            }
            
            [_changeOrderimagesArray removeObjectAtIndex:toIndex];
            [_changeOrderimagesArray insertObject:toView atIndex:fromIndex];
        }
        
    }
    else {
        
    }
}


//获取进入那个View
- (EditUserSquareView *)getPassIntoView:(EditUserSquareView *)gesView touchPoint:(CGPoint)touchPoint {
    for (int i = 0;  i < _changeOrderimagesArray.count; i++) {
        //进入的View
        EditUserSquareView * tempView = _changeOrderimagesArray[i];
        NSValue * frameValue = self.imagesFrameArray[i];
        CGRect tempFrame = [frameValue CGRectValue];
        //排除自己
        if (gesView != tempView) {
            if (touchPoint.x >= tempFrame.origin.x && touchPoint.x <= tempFrame.origin.x + tempFrame.size.width) {
                if (touchPoint.y >= tempFrame.origin.y && touchPoint.y <= tempFrame.origin.y + tempFrame.size.height) {
                    return tempView;
                }
            }
        }
    }
    return gesView;
}

//获取进入那个View返回那个View的初始大小
- (CGRect)rectPassIntoViewFrameWithtouchPoint:(CGPoint)touchPoint touchNum:(NSInteger)touchNum {
    for (int i = 0;  i < self.imagesFrameArray.count; i++) {
        //进入的View
        NSValue * frameValue = self.imagesFrameArray[i];
        CGRect tempFrame = [frameValue CGRectValue];
        
        if (touchPoint.x >= tempFrame.origin.x && touchPoint.x <= tempFrame.origin.x + tempFrame.size.width) {
            if (touchPoint.y >= tempFrame.origin.y && touchPoint.y <= tempFrame.origin.y + tempFrame.size.height) {
                return tempFrame;
            }
        }
    }
    NSValue * toFrameValue = self.imagesFrameArray[touchNum];
    return [toFrameValue CGRectValue];
}


#pragma mark - init 初始化

- (void)initAllView {
    
    NSMutableArray * imagesMutableArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i++) {
        
        EditUserSquareView * editUserSquareView = [[EditUserSquareView alloc] init];
        editUserSquareView.tag = i;
        editUserSquareView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [editUserSquareView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.1;
        [editUserSquareView addGestureRecognizer:longPress];
        
        [imagesMutableArray addObject:editUserSquareView];
        [self addSubview:editUserSquareView];
    }
    
    self.imagesArray = [imagesMutableArray copy];
}

//初始化frame
- (void)layoutSubviewsWithFrame:(CGRect)frame {
    
    NSMutableArray * imagesFrameMutableArray = [[NSMutableArray alloc] init];
    CGFloat minWidth = (frame.size.width - EachViewInterval * 2)/3;
    CGFloat maxWidth = minWidth * 2 + EachViewInterval;
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        
        EditUserSquareView * imageView = self.imagesArray[i];
        if (i == 0) {
            imageView.frame = CGRectMake(0, 0, maxWidth, maxWidth);
        }
        else if (i == 1) {
            imageView.frame = CGRectMake(maxWidth + EachViewInterval, 0, minWidth, minWidth);
        }
        else if (i == 2) {
            imageView.frame = CGRectMake(maxWidth + EachViewInterval, minWidth + EachViewInterval, minWidth, minWidth);
        }
        else if (i == 3) {
            imageView.frame = CGRectMake(maxWidth + EachViewInterval, maxWidth + EachViewInterval, minWidth, minWidth);
        }
        else if (i == 4) {
            imageView.frame = CGRectMake(minWidth + EachViewInterval, maxWidth + EachViewInterval, minWidth, minWidth);
        }
        else if (i == 5) {
            imageView.frame = CGRectMake(0, maxWidth + EachViewInterval, minWidth, minWidth);
        }
        
        NSValue * frameValue = [NSValue valueWithCGRect:imageView.frame];
        [imagesFrameMutableArray addObject:frameValue];
        
    }
    self.imagesFrameArray = [imagesFrameMutableArray copy];
}


#pragma mark - getter





















@end
