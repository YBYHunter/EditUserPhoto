//
//  ViewController.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ViewController.h"
#import "EditUserPhotoView.h"

@interface ViewController ()

@property (nonatomic,strong) EditUserPhotoView * editUserPhotoView;

@property (nonatomic,strong) UIButton * remakesBut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.editUserPhotoView];
    [self.view addSubview:self.remakesBut];
}

- (void)remakesButAction {
    self.editUserPhotoView = nil;
    [self.editUserPhotoView removeFromSuperview];
    [self.view addSubview:self.editUserPhotoView];
}

- (EditUserPhotoView *)editUserPhotoView {
    if (_editUserPhotoView == nil) {
        _editUserPhotoView = [[EditUserPhotoView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
        _editUserPhotoView.backgroundColor = [UIColor redColor];
        
    }
    return _editUserPhotoView;
}

- (UIButton *)remakesBut {
    if (_remakesBut == nil) {
        _remakesBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remakesBut setTitle:@"重制" forState:UIControlStateNormal];
        [_remakesBut addTarget:self action:@selector(remakesButAction) forControlEvents:UIControlEventTouchUpInside];
        _remakesBut.frame = CGRectMake(10, self.editUserPhotoView.frame.size.height + self.editUserPhotoView.frame.origin.y  + 10, self.view.frame.size.width - 20, 44);
        _remakesBut.backgroundColor = [UIColor redColor];
    }
    return _remakesBut;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
