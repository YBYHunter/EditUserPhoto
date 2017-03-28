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

//初始化固定顺序的数组(不变序)
@property (nonatomic,strong) NSArray * imagesArray;

//改变顺序的可变数组(变序)
@property (nonatomic,strong) NSMutableArray * changeOrderimagesArray;

//里面的数据为NSValue类型(不变序)
@property (nonatomic,strong) NSArray * imagesFrameArray;


@property (nonatomic,strong) NSMutableArray * testLabArray;

//上一次进入的View
@property (nonatomic,strong) UIImageView * lastPassIntoView;

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

- (void)initAllView {
    
    NSMutableArray * imagesMutableArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor grayColor];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.1;
        [imageView addGestureRecognizer:longPress];
        
        [imagesMutableArray addObject:imageView];
        [self addSubview:imageView];
        
        UILabel * lab = [[UILabel alloc] init];
        lab.text = [NSString stringWithFormat:@"%ld",(long)imageView.tag];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:lab];
        
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
        
        UIImageView * imageView = self.imagesArray[i];
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

#pragma mark - UITapGestureRecognizer

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
}


- (void)moveAnimationWithFrame:(CGRect)frame moveView:(UIView *)moveView delay:(NSInteger)delay {
    [UIView animateWithDuration:0.5 delay:delay * 0.05 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        moveView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - handleTableviewCellLongPressed

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    UIImageView * imageView = (UIImageView *)gestureRecognizer.view;
    
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.frame = CGRectMake(point.x - LongPressNarrowWidth/2, point.y - LongPressNarrowWidth/2, LongPressNarrowWidth, LongPressNarrowWidth);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        imageView.center = CGPointMake(point.x, point.y);
        
        NSInteger toIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:imageView];
        //进入到哪个View
        UIImageView * passIntoView = [self getPassIntoView:imageView touchPoint:point];
        NSInteger fromIndex = [_changeOrderimagesArray indexOfObjectIdenticalTo:passIntoView];
    
        //上次进入和这次进入 相同 不执行
        if (passIntoView == _lastPassIntoView) {
            return;
        }
        
        _lastPassIntoView = passIntoView;
        
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
                [_changeOrderimagesArray insertObject:imageView atIndex:fromIndex];
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
                [_changeOrderimagesArray insertObject:imageView atIndex:fromIndex];
            }
            
        }
        else {
            
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect passIntoViewFrame = [self rectPassIntoViewFrameWithtouchPoint:point];
        imageView.frame = passIntoViewFrame;
        _lastPassIntoView = nil;
    }
}


//获取进入那个View
- (UIImageView *)getPassIntoView:(UIImageView *)gesView touchPoint:(CGPoint)touchPoint {
    for (int i = 0;  i < _changeOrderimagesArray.count; i++) {
        //进入的View
        UIImageView * tempView = _changeOrderimagesArray[i];
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
- (CGRect)rectPassIntoViewFrameWithtouchPoint:(CGPoint)touchPoint {
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
    return CGRectMake(0, 0, 0, 0);
}

#pragma mark - getter


- (NSMutableArray *)testLabArray {
    if (_testLabArray == nil) {
        _testLabArray = [[NSMutableArray alloc] init];
    }
    return _testLabArray;
}


























@end
