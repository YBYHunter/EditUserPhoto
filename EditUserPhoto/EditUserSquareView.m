//
//  EditUserSquareView.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)


#import "EditUserSquareView.h"

@interface EditUserSquareView ()

@property (nonatomic,strong) UIImageView * showImageView;

@property (nonatomic,strong) UIImageView * failureImageView;



@end

@implementation EditUserSquareView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.showImageView];
        [self addSubview:self.loadingActivityIndicator];
        [self addSubview:self.failureImageView];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)changeTypeWithSquareView:(EditUserSquareView *)squareView {
    
    self.failureImageView.hidden = YES;
    if (squareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoading) {
        
        [self.loadingActivityIndicator startAnimating];
        
        EditUserSquareModel * editUserSquareModel = squareView.editUserSquareModel;
        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",editUserSquareModel.squareImageUrl]];
        NSData * data = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.showImageView.image = [UIImage imageWithData:data];
            [self.loadingActivityIndicator stopAnimating];
            //加载完成后自动更新状态
            squareView.editUserSquareModel.squareType = EditUserSquareModelTypeImageLoadSuccessful;
        });
    }
    else if (squareView.editUserSquareModel.squareType == EditUserSquareModelTypeNone) {
        
        [self.loadingActivityIndicator stopAnimating];
        self.showImageView.image = nil;
    }
    else if (squareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadSuccessful) {
        
        [self.loadingActivityIndicator stopAnimating];
        EditUserSquareModel * editUserSquareModel = squareView.editUserSquareModel;
        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@@w_%d",editUserSquareModel.squareImageUrl,(int)SCREEN_WIDTH]];
        NSData * data = [NSData dataWithContentsOfURL:imageUrl];
        self.showImageView.image = [UIImage imageWithData:data];
    }
    else if (squareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageUploading) {
        
        self.showImageView.image = nil;
        [self.loadingActivityIndicator startAnimating];
    }
    else if (squareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadFailure) {
        
        self.failureImageView.hidden = NO;
        [self.loadingActivityIndicator stopAnimating];
        self.showImageView.image = nil;
    }
}

- (void)layoutSubviews {
    
    self.showImageView.frame = self.bounds;
    
    self.loadingActivityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    self.failureImageView.frame = self.loadingActivityIndicator.frame;
    
}

#pragma mark - getter

- (UIActivityIndicatorView *)loadingActivityIndicator {
    if (_loadingActivityIndicator == nil) {
        _loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingActivityIndicator.color = [UIColor whiteColor];
        [_loadingActivityIndicator setHidesWhenStopped:YES];
    }
    return _loadingActivityIndicator;
}

- (UIImageView *)showImageView {
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UIImageView *)failureImageView {
    if (_failureImageView == nil) {
        _failureImageView = [[UIImageView alloc] init];
        _failureImageView.image = [UIImage imageNamed:@"chat_add"];
        _failureImageView.hidden = YES;
    }
    return _failureImageView;
}

- (EditUserSquareModel *)editUserSquareModel {
    if (_editUserSquareModel == nil) {
        _editUserSquareModel = [[EditUserSquareModel alloc] init];
    }
    return _editUserSquareModel;
}

@end
