//
//  ViewController.m
//  EditUserPhoto
//
//  Created by 于博洋 on 2017/3/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ViewController.h"
#import "EditUserPhotoView.h"
#import "JMActionSheet.h"

@interface ViewController () <EditUserPhotoViewDelegate>

@property (nonatomic,strong) EditUserPhotoView * editUserPhotoView;

@property (nonatomic,strong) EditUserSquareView * selectEditUserSquareView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.editUserPhotoView];
}

#pragma mark - EditUserPhotoViewDelegate

- (void)editUserSquareView:(EditUserSquareView *)editUserSquareView didSelectNumIndex:(NSInteger)index {
    
    _selectEditUserSquareView = editUserSquareView;
    
    NSMutableArray * titleArray = [[NSMutableArray alloc] init];
    
    if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeNone) {
        
        [titleArray addObject:@"从相册选择"];
        [titleArray addObject:@"拍一张照片"];
    }
    else if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadSuccessful) {
        
        [titleArray addObject:@"删除该照片"];
    }
    else if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoadFailure) {
        
        [titleArray addObject:@"删除该照片"];
        [titleArray addObject:@"再试一次"];
    }
    else if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeOnly) {
        
        [titleArray addObject:@"从相册选择"];
        [titleArray addObject:@"拍一张照片"];
    }
    else if (editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageLoading || editUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeImageUploading) {
        
        [titleArray addObject:@"删除该照片"];
    }
    
    [titleArray addObject:@"取消"];
    [JMActionSheet showTitle:[titleArray copy] type:JMActionSheetTypeBlack];
    __weak __typeof(self)weakSelf = self;
    [JMActionSheet shareJMActionSheet].clickCancle = ^(NSString * title) {
        if ([title isEqualToString:@"从相册选择"]) {
            [weakSelf cameraViewController:0 didFinishPickingMediaWithInfo:[UIImage imageNamed:@"che.jpg"]];
        }
        else if ([title isEqualToString:@"拍一张照片"]) {
            [weakSelf cameraViewController:0 didFinishPickingMediaWithInfo:[UIImage imageNamed:@"che.jpg"]];
        }
        else if ([title isEqualToString:@"删除该照片"]) {
            [weakSelf.editUserPhotoView deleteEditUserSquareView:editUserSquareView index:index];
            weakSelf.selectEditUserSquareView = nil;
        }
        else if ([title isEqualToString:@"再试一次"]) {
            [weakSelf cameraViewController:0 didFinishPickingMediaWithInfo:weakSelf.selectEditUserSquareView.editUserSquareModel.tempImage];
            weakSelf.selectEditUserSquareView = nil;
        }
    };

    

}

- (void)cameraViewController:(NSInteger )type didFinishPickingMediaWithInfo:(UIImage *)image {
    
    if (_selectEditUserSquareView) {
        if (_selectEditUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeOnly) {
            //替换
            [self.editUserPhotoView modifyUserSquareView:_selectEditUserSquareView type:EditUserSquareModelTypeImageUploading];
        }
        else if (_selectEditUserSquareView.editUserSquareModel.squareType == EditUserSquareModelTypeNone){
            //上传图片
            [self.editUserPhotoView addEditUserSquareView:_selectEditUserSquareView];
        }
        _selectEditUserSquareView.editUserSquareModel.tempImage = image;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * imageUrl = @"http://7vzoqx.com1.z0.glb.clouddn.com/00019e87ce44f48fd443e6b1b399b49f.jpeg";
        NSString * imageID = @"1";
        if (imageUrl && imageID) {
            //需要添加图片
            _selectEditUserSquareView.editUserSquareModel.squareViewID = [NSString stringWithFormat:@"%@",imageID];
            _selectEditUserSquareView.editUserSquareModel.squareImageUrl = imageUrl;
            [weakSelf.editUserPhotoView modifyUserSquareView:_selectEditUserSquareView type:EditUserSquareModelTypeImageLoading];
        }
        else {
            [weakSelf.editUserPhotoView modifyUserSquareView:_selectEditUserSquareView type:EditUserSquareModelTypeImageLoadFailure];
        }
    });
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
