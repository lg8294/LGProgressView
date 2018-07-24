//
//  ViewController.m
//  LGProgressView
//
//  Created by Arrcen-LG on 2018/7/20.
//  Copyright © 2018年 Arrcen-LG. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ProgressView alloc] init];
        [_progressView setBounds:CGRectMake(0, 0, 300, 300)];
        [_progressView setBackgroundColor:[UIColor grayColor]];
        [_progressView setProgressUnitDefaultColor:[UIColor colorWithRed:78/255.0 green:136/255.0 blue:185/255.0 alpha:1]];
    }
    return _progressView;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.progressView];
    [self.progressView setCenter:self.view.center];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(handleStart)];
}

#pragma mark - handle
- (void)handleStart {
    if (self.timer) {
        [self.timer invalidate];
    }

    self.progressView.complete = 0;
    self.progressView.total = 1024*1024*100;
    [self.progressView showMessage:@"updating..."];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.progressView.complete += 1024*1024;
        if (self.progressView.complete == self.progressView.total) {
            [timer invalidate];
        }
    }];
//    [self.timer fire];
}

@end
