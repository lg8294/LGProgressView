//
//  ProgressView.h
//  ArrcenKit
//
//  Created by Arrcen-LG on 2018/7/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger complete;

@property (nonatomic, strong) UIColor *progressUnitDefaultColor;

- (void)showMessage:(NSString *)msg;

@end
