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
#import "YHOCUploadDP.h"
#import "YHihpDP.h"
#import <AFNetworking/AFNetworking.h>
#import <YHModel/YHModel.h>

@interface ViewController ()<YHNetProtocol>
@property(nonatomic,strong)UILabel *respLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)YHihpDP *ihpdp;
@property(nonatomic,strong)YHTestDP *dp;
@property(nonatomic,strong)YHOCUploadDP *uploadDP;

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
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 30, 30)];
    self.imageView.image = [UIImage imageNamed:@"test_img"];
    [self.view addSubview:self.imageView];
    
    UIButton *uploadbtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 50, 100, 30)];
    [uploadbtn setTitle:@"点击上传" forState:UIControlStateNormal];
    [uploadbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [uploadbtn addTarget:self action:@selector(uploadImgTestAction) forControlEvents:UIControlEventTouchUpInside];
    uploadbtn.layer.borderColor = [UIColor grayColor].CGColor;
    uploadbtn.layer.borderWidth=1.0;
    [self.view addSubview:uploadbtn];
    
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
    
    UIButton *testButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton2.frame = CGRectMake(10, 570, [UIScreen mainScreen].bounds.size.width-20, 30);
    [testButton2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    testButton2.layer.borderColor = [UIColor grayColor].CGColor;
    testButton2.layer.borderWidth=1.0;
    testButton2.layer.masksToBounds = YES;
    testButton2.layer.cornerRadius =5.5;
    [testButton2 setTitle:@"测试IHP" forState:UIControlStateNormal];
    [testButton2 addTarget:self action:@selector(testIhpRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton2];
    
    
    self.respLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 500)];
    self.respLabel.numberOfLines = 0;
    self.respLabel.text = @"响应:";
    self.respLabel.textAlignment= NSTextAlignmentLeft;
    [self.view addSubview:self.respLabel];
}

-(void)testAction:(id)sender
{
    
    YHNetTimeoutInterval = 90.0;
    NSString *url = @"https://apps2.1zhe.com/ios/index_bak.php?m=other&op=collection&ac=init&app_version=2.4.9&v=2.4.7";
    self.respLabel.text = @"请求中..";
//    [YHNetUnility postRequestWithUrl:url withParameters:nil withSuccessed:^(id obj) {
//
//        NSLog(@"withSuccessed:%@",obj);
//        self.respLabel.text = [NSString stringWithFormat:@"响应:\n%@",obj];
//
//    } withFailed:^(NSError *error) {
//
//        self.respLabel.text = [NSString stringWithFormat:@"error:\n%@",error.localizedDescription];
//        NSLog(@"error:%@",error);
//    }];
    [YHNetUnility postRequestWithUrl:url withRequestHeaders:nil withParameters:nil withRequestSerializerType:YHRequestSerializerJson withResponeSerializerType:YHResponeSerializerJson withProgress:^(NSProgress *downloadProgress) {
        
    } withSuccessed:^(id obj) {
        
    } withFailed:^(NSError *error) {
        
    }];
    
    [self.dp start];
}

-(void)uploadImgTestAction
{
    UIImage * consultImgs = self.imageView.image;

    [self.uploadDP clearFiles];
    [self.uploadDP appendImage:consultImgs withName:@"files"];
    [self.uploadDP start];
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
        _dp.netHandle = self;
    }
    return _dp;
}

-(YHihpDP *)ihpdp
{
    if (!_ihpdp) {
        _ihpdp = [[YHihpDP alloc] init];
        _ihpdp.netHandle = self;
    }
    return _ihpdp;
}

-(YHOCUploadDP *)uploadDP
{
    if (!_uploadDP) {
        _uploadDP = [[YHOCUploadDP alloc] init];
        _uploadDP.netHandle = self;
        _uploadDP.tag = 1002;
        _uploadDP.isIMUpload = YES;
    }
    return _uploadDP;
}


#pragma mark - acton

-(void)testIhpRequest
{
    NSLog(@"start IhpRequest");
    self.respLabel.text = @"请求中..";
//    [self.ihpdp start];
    [[[YHihpDP alloc] initWithHandle:self] start];
}

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

-(void)testAfn4{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    if ([manager respondsToSelector:@selector(POST:parameters:headers:progress:success:failure:)]) {
        [manager POST:nil parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        
    };
}


-(void)netByDP:(id)dataProvider doWhenSuccess:(NSDictionary *)obj
{
    NSLog(@"doWhenSuccess:%@",[obj yh_modelToJSONString]);
    self.respLabel.text = [obj yh_modelToJSONString];
}

-(void)netByDP:(id)dataProvider doWhenFailed:(id)obj
{
    NSLog(@"doWhenFailed:%@",[obj yh_modelToJSONString]);
}

-(void)netByDP:(id)dataProvider uploadProgress:(float) uploadProgress
{
    NSLog(@"uploadProgress:%f",uploadProgress);
}

@end
