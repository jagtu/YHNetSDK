//
//  YHBaseLoadMoreDP.m
//  YHNetSDK
//
//  Created by zxl on 2018/2/2.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseLoadMoreDP.h"

@interface YHBaseLoadMoreDP()

/**
 该属性仅用于区分调用refresh方法或者loadmore方法时候，设置DP状态
 */
@property(nonatomic,assign)BOOL isRefresh;

@end

@implementation YHBaseLoadMoreDP

-(id)initWithHandle:(id<YHNetProtocol>)netHandle withStopRefresh: (dispatch_block_t) stopRefreshWhenIsLoadMoreingBlock
   withStopLoadMore:(dispatch_block_t)stopLoadMoreWhenIsRefreshBlock
{
    if (self) {
        self = [super initWithHandle:netHandle];
        
        self.stopRefreshWhenIsLoadMoreingBlock = stopRefreshWhenIsLoadMoreingBlock;
        self.stopLoadMoreWhenIsRefreshBlock = stopLoadMoreWhenIsRefreshBlock;
    }
    return self;
}


/**
 刷新DP
 如果dp处理加载更多状态，应停止刷新操作。
 */
-(void)refresh
{
    if (self.dpStatus == YHDPStatusRefreshing) {
        return;
        
    }else if (self.dpStatus == YHDPStatusLoadmoreing) {
        if (self.stopRefreshWhenIsLoadMoreingBlock) {
            self.stopRefreshWhenIsLoadMoreingBlock();
        }
    }else
    {
        @synchronized (self) {
            self.isRefresh = YES;
        }
        
        [self setFirstPageNo];
        [self start];
    }
}

/**
 加载更多DP
 如果DP处理刷新，或者全部加载状态时候，应停止加载更操作
 */
-(void)loadMore
{
    if (self.dpStatus == YHDPStatusRefreshing || self.dpStatus == YHDPStatusLoadAll) {
        if (self.stopLoadMoreWhenIsRefreshBlock) {
            self.stopLoadMoreWhenIsRefreshBlock();
        }
    }else if (self.dpStatus == YHDPStatusLoadmoreing) {
        return;
    }else
    {
        @synchronized (self) {
            self.isRefresh = NO;
        }
        
        [self setNextPageNo];
        [self start];
    }
}

/**
 设置加载指定页码
 
 @param pageNo No.
 */
-(void)setPageNo:(NSInteger)pageNo
{
    
}

/**
 设置下一页页码
 */

-(void)setNextPageNo
{
    
}


/**
 设置请求首页号码
 */
-(void)setFirstPageNo
{
    
}

/**
 设置页码size
 
 @param pageSize size
 */
-(void)setPageSize:(NSInteger)pageSize;
{
    
}

/**
 是否还有下一页
 子类加载更多必须重写该方法
 @return Yes
 */
-(BOOL)hasNextPage;
{
    return NO;
}

-(void)setDPStatusBeforeRequest
{
    [super setDPStatusBeforeRequest];
    
    if (self.isRefresh) {
        self.dpStatus = YHDPStatusRefreshing;
    }else
    {
        self.dpStatus = YHDPStatusLoadmoreing;
    }
}

-(void)setDPStatusWhenSuccessed
{
    [super setDPStatusWhenSuccessed];
//    self.dpStatus = YHDPStatusNormal;
    
    //在此判断是否为为已经全部加载: hasNextPage方法必须在子类重写
    self.dpStatus = [self hasNextPage]? YHDPStatusNormal : YHDPStatusLoadAll;
}

-(void)setDPStatusWhenFailed
{
    [super setDPStatusWhenFailed];
    
    self.dpStatus = YHDPStatusNormal;
}
@end
