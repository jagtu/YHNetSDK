//
//  ViewController.m
//  YHNetSDKDemo
//
//  Created by zxl on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "ViewController.h"
#import <YHNetSDK/YHNetSDK.h>
#import "YHTestDP.h"

@interface ViewController ()
@property(nonatomic,strong)UILabel *respLabel;

@property(nonatomic,strong)YHTestDP *dp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

//    NSString *url = @"https://apps2.1zhe.com/ios/index_bak.php?m=other&op=collection&ac=init&app_version=2.4.9&v=2.4.7";
//    [YHNetTest postRequestWithUrl:url withParameters:nil withSuccessed:^(id obj) {
//
//        NSLog(@"234");
//    } withFailed:^(NSError *error) {
//        NSLog(@"234");
//    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 100, 100)];
    [btn2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    [btn3 addTarget:self action:@selector(cancelAllRequest) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn3];

    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(10, 510, [UIScreen mainScreen].bounds.size.width-20, 30);
    [testButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    testButton.layer.borderColor = [UIColor grayColor].CGColor;
    testButton.layer.borderWidth=1.0;
    testButton.layer.masksToBounds = YES;
    testButton.layer.cornerRadius =5.5;
    [testButton setTitle:@"测试" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    
    self.respLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 500)];
    self.respLabel.numberOfLines = 0;
    self.respLabel.text = @"响应:";
    self.respLabel.textAlignment= NSTextAlignmentLeft;
//    [self.view addSubview:self.respLabel];
}

-(void)testAction:(id)sender
{
    
    YHNetTimeoutInterval = 90.0;
    NSString *url = @"https://apps2.1zhe.com/ios/index_bak.php?m=other&op=collection&ac=init&app_version=2.4.9&v=2.4.7";
    self.respLabel.text = @"请求中..";
    [YHNetUnility postRequestWithUrl:url withParameters:nil withSuccessed:^(id obj) {
        
        NSLog(@"withSuccessed:%@",obj);
        self.respLabel.text = [NSString stringWithFormat:@"响应:\n%@",obj];
        
    } withFailed:^(NSError *error) {
        
        self.respLabel.text = [NSString stringWithFormat:@"error:\n%@",error.localizedDescription];
        NSLog(@"error:%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy loading

-(YHTestDP *)dp
{
    if (!_dp) {
        _dp = [[YHTestDP alloc] init];
    }
    return _dp;
}

#pragma mark - acton

-(void)start
{
    NSLog(@"start");
    [self.dp start];
}

-(void)cancel
{
    NSLog(@"cancel");
//    [self.dp cancellDP];
}

-(void)cancelAllRequest
{
    NSLog(@"cancelAll");
//    [self.dp cancellAllDP];
}
@end
