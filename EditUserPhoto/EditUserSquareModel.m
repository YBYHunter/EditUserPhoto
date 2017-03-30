//
//  EditUserSquareModel.m
//  gmu
//
//  Created by 于博洋 on 2017/3/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "EditUserSquareModel.h"

@implementation EditUserSquareModel

- (void)setSquareViewID:(NSString *)squareViewID {
    if (![squareViewID isKindOfClass:[NSString class]]) {
        squareViewID = [NSString stringWithFormat:@"%@",squareViewID];
    }
    _squareViewID = squareViewID;
}

@end
