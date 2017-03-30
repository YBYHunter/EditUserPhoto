//
//  JMActionSheet.h
//  gmu
//
//  Created by carl on 16/7/18.
//  Copyright © 2016年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JMActionSheetTypeYellow = 0,
    JMActionSheetTypeBlack = 1,
} JMActionSheetType;

@interface JMActionSheet : UIView

@property (nonatomic,copy) void (^clickCancle)(NSString *);

+ (JMActionSheet *)shareJMActionSheet;

+ (void)showTitle:(NSArray *)array type:(JMActionSheetType)type;

@end
