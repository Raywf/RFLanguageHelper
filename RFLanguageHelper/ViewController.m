//
//  ViewController.m
//  RFLanguageHelper
//
//  Created by Raywf on 2018/2/25.
//  Copyright © 2018年 S.Ray. All rights reserved.
//

#import "ViewController.h"
#import "RFLanguageHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = RFLanguage(@"标题");
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self customUI];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        NSLog(@"nothing");
    }];
}

- (void)customUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    CGRect frame = CGRectMake(15, 64, width-15*2, 64);
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.backgroundColor = [UIColor whiteColor];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = RFLanguage(@"语言");
    [self.view addSubview:lab];

    frame = CGRectMake((int)((width-130)/2), 128+15, 130, 47);
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = [UIColor purpleColor];
    btn.layer.cornerRadius = 5.0f;
    btn.clipsToBounds = YES;
    [btn setTitle:RFLanguage(@"选择语言") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    self.label = lab;
    self.button = btn;
}
- (void)btnClick:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;

    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCtr addAction:[UIAlertAction actionWithTitle:RFLanguage(@"跟随系统") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [RFLanguageHelper SetAppLanguageViaCode:-1 Completion:^{
            [weakSelf UpdateUI];
        }];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"中文简体" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger langCode1 = [RFLanguageHelper LanguageCodeViaKey:@"zh-Hans"];
        [RFLanguageHelper SetAppLanguageViaCode:langCode1 Completion:^{
            [weakSelf UpdateUI];
        }];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"中文繁體" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger langCode3 = [RFLanguageHelper LanguageCodeViaKey:@"zh-Hant"];
        [RFLanguageHelper SetAppLanguageViaCode:langCode3 Completion:^{
            [weakSelf UpdateUI];
        }];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger langCode2 = [RFLanguageHelper LanguageCodeViaKey:@"en"];
        [RFLanguageHelper SetAppLanguageViaCode:langCode2 Completion:^{
            [weakSelf UpdateUI];
        }];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:RFLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertCtr animated:YES completion:nil];
}
- (void)UpdateUI {
    self.title = RFLanguage(@"标题");
    self.label.text = RFLanguage(@"语言");
    [self.button setTitle:RFLanguage(@"选择语言") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
