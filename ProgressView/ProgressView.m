//
//  ProgressView.m
//  ArrcenKit
//
//  Created by Arrcen-LG on 2018/7/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "ProgressView.h"

#define PADDING 40
#define UNIT_SIZE CGSizeMake(3, 12)
#define UNIT_COLOR [UIColor colorWithRed:78/255.0 green:136/255.0 blue:185/255.0 alpha:1]
#define UNIT_COLOR_COMPLETE [UIColor whiteColor]
#define UNIT_COUNT 81
#define TextColor [UIColor whiteColor]

@interface ProgressView ()

@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *completeLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) NSMutableArray<CALayer *> *unitLayers;

@end

@implementation ProgressView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    NSLog(@"%f", self.complete * 1.0 /self.total);
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.unitLayers = [NSMutableArray array];
    self.progressUnitDefaultColor = UNIT_COLOR;
    
    [self addUnitLayers];
    
    [self addSubview:self.msgLabel];
    [self addSubview:self.progressLabel];
    [self addSubview:self.completeLabel];
    [self addSubview:self.totalLabel];
}

#pragma mark - override
- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    CGSize size = bounds.size;
    
    [self.msgLabel sizeToFit];
    [self.msgLabel setCenter:CGPointMake(size.width/2, size.height/2-50)];
    
    [self.progressLabel sizeToFit];
    [self.progressLabel setCenter:CGPointMake(size.width/2, size.height/2)];
    
    [self.completeLabel sizeToFit];
    [self.completeLabel setCenter:CGPointMake(size.width/4, size.height-20)];
    
    [self.totalLabel sizeToFit];
    [self.totalLabel setCenter:CGPointMake(size.width-size.width/4, size.height-20)];
    
    CGPoint selfCenter = CGPointMake(size.width/2-bounds.origin.x, size.height/2-bounds.origin.y);
    
    CGFloat r = MAX(size.width, size.height)/2 - PADDING;
    
//    NSLog(@"%@", NSStringFromCGPoint(selfCenter));
//    NSLog(@"%f", r);
    double total = M_PI*2*5/6;
    double unit = 0;
    if (self.unitLayers.count>1) {
        unit = total/(self.unitLayers.count-1);
    }
    [self.unitLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        double ao = M_PI*2/3 + idx*unit;
//        double ao = M_PI_4;
        CGFloat x = selfCenter.x + r*cos(ao);
        CGFloat y = selfCenter.y + r*sin(ao);
        CGPoint center = CGPointMake(x, y);
        [layer setPosition:center];
        [layer setTransform:CATransform3DMakeRotation(ao-M_PI_2, 0, 0, 1.0)];
        
        [self.layer addSublayer:layer];
    }];
}

#pragma mark -

- (void)setProgressUnitDefaultColor:(UIColor *)progressUnitDefaultColor {
    _progressUnitDefaultColor = progressUnitDefaultColor;
    
    [self.totalLabel setTextColor:progressUnitDefaultColor];
    for (CALayer *layer in self.unitLayers) {
        layer.backgroundColor = progressUnitDefaultColor.CGColor;
    }
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        [_msgLabel setTextColor:TextColor];
        [_msgLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _msgLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        [_progressLabel setTextColor:TextColor];
        [self updateProgressMsgWithProgress:0];
    }
    return _progressLabel;
}
- (UILabel *)completeLabel {
    if (!_completeLabel) {
        _completeLabel = [[UILabel alloc] init];
        [_completeLabel setText:@"0MB"];
        [_completeLabel setTextColor:TextColor];
    }
    return _completeLabel;
}
- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        [_totalLabel setText:@"0MB"];
        [_totalLabel setTextColor:self.progressUnitDefaultColor];
    }
    return _totalLabel;
}

#pragma mark - private
- (CALayer *)unitLayer {
    CALayer *layer = [[CALayer alloc] init];
    [layer setBounds:CGRectMake(0, 0, UNIT_SIZE.width, UNIT_SIZE.height)];
    [layer setBackgroundColor:self.progressUnitDefaultColor.CGColor];
    layer.anchorPoint = CGPointMake(0.5, 0);
    return layer;
}

- (void)addUnitLayers {
    for (int i=0 ; i< UNIT_COUNT; i++) {
        CALayer *layer = [self unitLayer];
        [self.unitLayers addObject:layer];
        [self.layer addSublayer:layer];
    }
}

- (void)setComplete:(NSInteger)complete {
    if (complete > _total) {
        _complete = _total;
    } else {
        _complete = complete;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%ldMB", _complete/1024/1024];
    [self.completeLabel setText:msg];
    [self.completeLabel sizeToFit];
    [self update];
}

- (void)setTotal:(NSInteger)total {
    _total = total;
    
    NSString *msg = [NSString stringWithFormat:@"%ldMB", total/1024/1024];
    [self.totalLabel setText:msg];
    [self.totalLabel sizeToFit];
}

- (void)updateProgressMsgWithProgress:(NSInteger)progress {
    
    NSAttributedString *str1 = [[NSAttributedString alloc]
                                initWithString:@"%"
                                attributes:@{
                                             NSFontAttributeName: [UIFont systemFontOfSize:30],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                             }];
    NSAttributedString *str2 = [[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"%ld",(long)progress]
                                attributes:@{
                                             NSFontAttributeName: [UIFont systemFontOfSize:60],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                             }];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:str2];
    [str appendAttributedString:str1];
    [self.progressLabel setAttributedText:str];
    [self.progressLabel sizeToFit];
}

- (void)update {
    float percent = 0;
    if (_total>0) {
        percent = _complete*1.0/_total;
    }
    
    [self updateProgressMsgWithProgress:roundf(percent*100)];
    
    NSInteger stopIndex = round(UNIT_COUNT*percent);
    if (stopIndex == 0) {
        return;
    }
    [self.unitLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < stopIndex) {
            [obj setBackgroundColor:UNIT_COLOR_COMPLETE.CGColor];
            CGFloat zoom = idx+1 == stopIndex ? 1.5 : 1.0;
            [obj setBounds:CGRectMake(0, 0, UNIT_SIZE.width, UNIT_SIZE.height*zoom)];
        } else {
            [obj setBackgroundColor:self.progressUnitDefaultColor.CGColor];
            [obj setTransform:CATransform3DMakeScale(0, 0, 0)];
        }
    }];
}

#pragma mark - public
- (void)showMessage:(NSString *)msg {
    [self.msgLabel setText:msg];
    [self.msgLabel sizeToFit];
}
@end
