//
//  EditUserSquareView.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "EditUserSquareView.h"

@interface EditUserSquareView ()

@property (nonatomic,strong) UIImageView * showImageView;

@property (nonatomic,strong) UIActivityIndicatorView * loadingActivityIndicator;

@end

@implementation EditUserSquareView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.showImageView];
        [self addSubview:self.loadingActivityIndicator];
    }
    return self;
}

- (void)changeType:(EditUserSquareViewType)squareViewType otherData:(id)otherData {
    _currentType = squareViewType;
    if (squareViewType == EditUserSquareViewTypeImageLoading) {
        if ([otherData isKindOfClass:[NSString class]]) {
            [self.loadingActivityIndicator startAnimating];
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:otherData]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loadingActivityIndicator stopAnimating];
                self.showImageView.image = [UIImage imageWithData:imageData];
                _currentType = EditUserSquareViewTypeImageLoadSuccessful;
            });
        }
    }
    else if (squareViewType == EditUserSquareViewTypeNone) {
        self.showImageView.image = nil;
    }
}

- (void)layoutSubviews {
    
    self.showImageView.frame = self.bounds;
    
    self.loadingActivityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
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

@end
