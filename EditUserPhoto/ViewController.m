//
//  ViewController.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ViewController.h"
#import "EditUserPhotoView.h"

@interface ViewController () <EditUserPhotoViewDelegate>

@property (nonatomic,strong) EditUserPhotoView * editUserPhotoView;

@property (nonatomic,strong) UIButton * remakesButton;

@property (nonatomic,strong) UIButton * exportDataButton;

@property (nonatomic,strong) UIButton * uploadDataButton;

@property (nonatomic,strong) EditUserSquareView * deleteEditUserSquareView;
@property (nonatomic,assign) NSInteger deleteIndex;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.editUserPhotoView];
    [self.view addSubview:self.remakesButton];
    [self.view addSubview:self.exportDataButton];
    [self.view addSubview:self.uploadDataButton];
}

- (void)remakesButAction {
    self.editUserPhotoView = nil;
    [self.editUserPhotoView removeFromSuperview];
    [self.view addSubview:self.editUserPhotoView];
}

- (void)exportDataButtonAction {
    NSLog(@"导出 === %@",self.editUserPhotoView.currentImageArray);
}

- (void)uploadDataButtonAction {
    NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/00014da1677b8ea062056c4949ccc911.jpeg"];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/00019e87ce44f48fd443e6b1b399b49f.jpeg"];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/0001fff6da7febafcd433fcc6c05853c.jpeg"];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/0002517de13e064276a37dc17eb4e47b.jpeg"];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/0003493831fdd92ee5a6dd05672e9702.jpeg"];
    [arrayImage addObject:@"http://7vzoqx.com1.z0.glb.clouddn.com/00040ccc8e5f3e785c3208541b15d5d8.jpeg"];

    NSLog(@"刷新");
    [self.editUserPhotoView refreshImageData:[arrayImage copy]];
}

#pragma mark - EditUserPhotoViewDelegate

- (void)editUserSquareView:(EditUserSquareView *)editUserSquareView didSelectNumIndex:(NSInteger)index {
    
    _deleteEditUserSquareView = editUserSquareView;
    _deleteIndex = index;
    
    if (editUserSquareView.currentType == EditUserSquareViewTypeNone) {
        //需要添加图片
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否上传图片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 3002;
        [alert show];
    }
    else if (editUserSquareView.currentType == EditUserSquareViewTypeImageLoadSuccessful) {
        //需要删除图片
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否删除" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 3001;
        [alert show];
    }
    else if (editUserSquareView.currentType == EditUserSquareViewTypeImageLoadFailure) {
        //需要重新发送图片
    }

    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == 3001 && [title isEqualToString:@"确定"]) {
        [self.editUserPhotoView deleteEditUserSquareView:_deleteEditUserSquareView index:_deleteIndex];
    }
    else if (alertView.tag == 3002 && [title isEqualToString:@"确定"]) {
        NSString * addImageUrl = @"http://7vzoqx.com1.z0.glb.clouddn.com/0044755a3c76171d48d188ebba77a8e3.jpeg";
        [self.editUserPhotoView addEditUserSquareView:_deleteEditUserSquareView imageNetPatch:addImageUrl];
    }
}

#pragma mark - getter

- (EditUserPhotoView *)editUserPhotoView {
    if (_editUserPhotoView == nil) {
        _editUserPhotoView = [[EditUserPhotoView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
        _editUserPhotoView.backgroundColor = [UIColor grayColor];
        _editUserPhotoView.editUserPhotoViewDelegate = self;
    }
    return _editUserPhotoView;
}

- (UIButton *)remakesButton {
    if (_remakesButton == nil) {
        _remakesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remakesButton setTitle:@"重制" forState:UIControlStateNormal];
        [_remakesButton addTarget:self action:@selector(remakesButAction) forControlEvents:UIControlEventTouchUpInside];
        _remakesButton.frame = CGRectMake(10, self.editUserPhotoView.frame.size.height + self.editUserPhotoView.frame.origin.y  + 10, self.view.frame.size.width - 20, 44);
        _remakesButton.backgroundColor = [UIColor grayColor];
    }
    return _remakesButton;
}


- (UIButton *)exportDataButton {
    if (_exportDataButton == nil) {
        _exportDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportDataButton setTitle:@"导出" forState:UIControlStateNormal];
        [_exportDataButton addTarget:self action:@selector(exportDataButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _exportDataButton.frame = CGRectMake(10, self.remakesButton.frame.size.height + self.remakesButton.frame.origin.y  + 10, self.view.frame.size.width - 20, 44);
        _exportDataButton.backgroundColor = [UIColor grayColor];
    }
    return _exportDataButton;
}

- (UIButton *)uploadDataButton {
    if (_uploadDataButton == nil) {
        _uploadDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadDataButton setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadDataButton addTarget:self action:@selector(uploadDataButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _uploadDataButton.frame = CGRectMake(10, self.exportDataButton.frame.size.height + self.exportDataButton.frame.origin.y  + 10, self.view.frame.size.width - 20, 44);
        _uploadDataButton.backgroundColor = [UIColor grayColor];
    }
    return _uploadDataButton;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
