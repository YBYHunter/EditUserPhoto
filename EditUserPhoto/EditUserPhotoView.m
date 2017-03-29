//
//  EditUserPhotoView.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "EditUserPhotoView.h"


static CGFloat const EachViewInterval = 2;

static CGFloat const LongPressNarrowWidth = 64;



@interface EditUserPhotoView ()<UIGestureRecognizerDelegate>

//初始化固定顺序的数组 count == 6
@property (nonatomic,strong) NSArray * imagesArray;

//改变顺序的可变数组 count == 6
@property (nonatomic,strong) NSMutableArray * changeOrderimagesArray;

//里面的数据为NSValue类型 count == 6
@property (nonatomic,strong) NSArray * imagesFrameArray;

//图片URL的数组 count <= 6 (最大为6)
@property (nonatomic,strong) NSMutableArray * imagesUrlArray;

@property (nonatomic,strong) NSMutableArray * testLabArray;

//上一次进入的View
@property (nonatomic,strong) EditUserSquareView * lastPassIntoView;

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

//刷新数据
- (void)refreshImageData:(NSArray *)imageUrlArray {
    self.imagesUrlArray = [imageUrlArray mutableCopy];
    
    NSInteger num = MIN(self.imagesUrlArray.count, _changeOrderimagesArray.count);
    
    for (int i = 0; i < num; i++) {
        EditUserSquareView * editUserSquareView = _changeOrderimagesArray[i];
        [editUserSquareView changeType:EditUserSquareViewTypeImageLoading otherData:self.imagesUrlArray[i]];
    }
}

//删除
- (void)deleteEditUserSquareView:(EditUserSquareView *)squareView index:(NSInteger)index {
    
    if (self.imagesUrlArray.count <= 0 || (self.imagesUrlArray.count - 1) >= _changeOrderimagesArray.count) {
        NSLog(@"error:deleteEditUserSquareView:出错了");
    }
    //点击的View
    EditUserSquareView * toSquareView = squareView;
    EditUserSquareView * fromeSquareView = _changeOrderimagesArray[self.imagesUrlArray.count - 1];
    
    //更改点击View的状态
    [toSquareView changeType:EditUserSquareViewTypeNone otherData:nil];
    
    //移动
    toSquareView.frame = fromeSquareView.frame;
    [self moveUserSquareViewWithToView:toSquareView fromView:fromeSquareView];
    
    //更新数据
    [self.imagesUrlArray removeObjectAtIndex:index];
}

//增加
- (void)addEditUserSquareView:(EditUserSquareView *)squareView imageNetPatch:(NSString *)imageNetPatch {
    
    if (self.imagesUrlArray.count >= _changeOrderimagesArray.count) {
        NSLog(@"error:addEditUserSquareView:出错了");
        return;
    }
    //点击的View
    EditUserSquareView * toSquareView = squareView;
    EditUserSquareView * fromeSquareView = _changeOrderimagesArray[self.imagesUrlArray.count];
    
    //更改点击View的状态
    [toSquareView changeType:EditUserSquareViewTypeImageLoading otherData:imageNetPatch];
    
    //移动
    toSquareView.frame = fromeSquareView.frame;
    [self moveUserSquareViewWithToView:toSquareView fromView:fromeSquareView];
    
    //更新数据
    [self.imagesUrlArray addObject:imageNetPatch];
}

//替换
- (void)replaceEditUserSquareView:(EditUserSquareView *)squareView imageNetPatch:(NSString *)imageNetPatch {
    
    [squareView changeType:EditUserSquareViewTypeNone otherData:imageNetPatch];
    [squareView changeType:EditUserSquareViewTypeImageLoading otherData:imageNetPatch];
    
    //获取第几个View需要替换
    NSInteger toIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:squareView];
    //更新数据
    [self.imagesUrlArray replaceObjectAtIndex:toIndex withObject:imageNetPatch];
    
}

#pragma mark - UITapGestureRecognizer

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    EditUserSquareView * tapEditUserSquareView = (EditUserSquareView *)tap.view;

    if (_imagesUrlArray.count <= 1 && tapEditUserSquareView.currentType == EditUserSquareViewTypeImageLoadSuccessful) {
        [tapEditUserSquareView changeType:EditUserSquareViewTypeOnly otherData:nil];
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
    if (imageView.currentType == EditUserSquareViewTypeNone) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.frame = CGRectMake(point.x - LongPressNarrowWidth/2, point.y - LongPressNarrowWidth/2, LongPressNarrowWidth, LongPressNarrowWidth);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        imageView.center = CGPointMake(point.x, point.y);
        //进入到哪个View
        EditUserSquareView * passIntoView = [self getPassIntoView:imageView touchPoint:point];
        
        //没有照片不移动
        if (passIntoView.currentType == EditUserSquareViewTypeNone) {
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
        if (passIntoView.currentType == EditUserSquareViewTypeNone) {
            //没有照片不移动
            NSValue * toFrameValue = self.imagesFrameArray[toIndex];
            passIntoViewFrame = [toFrameValue CGRectValue];
        }
        else {
            passIntoViewFrame = [self rectPassIntoViewFrameWithtouchPoint:point touchNum:toIndex];
        }
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
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
        editUserSquareView.backgroundColor = [UIColor lightGrayColor];
        editUserSquareView.tag = i;
        editUserSquareView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [editUserSquareView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.1;
        [editUserSquareView addGestureRecognizer:longPress];
        
        [imagesMutableArray addObject:editUserSquareView];
        [self addSubview:editUserSquareView];
        
        UILabel * lab = [[UILabel alloc] init];
        lab.text = [NSString stringWithFormat:@"%ld",(long)editUserSquareView.tag];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [editUserSquareView addSubview:lab];
        
        //测试
        [self.testLabArray addObject:lab];
        
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
        
        UILabel * lab = self.testLabArray[i];
        lab.frame = CGRectMake(0, 0, minWidth, minWidth);
    }
    self.imagesFrameArray = [imagesFrameMutableArray copy];
}


#pragma mark - getter


- (NSMutableArray *)testLabArray {
    if (_testLabArray == nil) {
        _testLabArray = [[NSMutableArray alloc] init];
    }
    return _testLabArray;
}



- (NSArray *)currentImageArray {
    _currentImageArray = [_changeOrderimagesArray copy];
    return _currentImageArray;
}



- (NSMutableArray *)imagesUrlArray {
    if (_imagesUrlArray == nil) {
        _imagesUrlArray = [[NSMutableArray alloc] init];
    }
    return _imagesUrlArray;
}



















@end
