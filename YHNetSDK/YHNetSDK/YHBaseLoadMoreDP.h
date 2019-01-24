//
//  YHBaseLoadMoreDP.h
//  YHNetSDK
//  加载更多的DP
//  Created by zxl on 2018/2/2.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseDP.h"


/**
 DP状态
 */
typedef NS_ENUM(NSInteger, YHDPStatus) {
    YHDPStatusNormal= 0,//未请求接口，普通状态；
    YHDPStatusRefreshing = 1,//刷新中
    YHDPStatusLoadmoreing = 2,//加载更多中
    YHDPStatusLoadAll = 3 //已经全部加载
};

@interface YHBaseLoadMoreDP : YHBaseDP

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,assign)NSInteger nextPage;


/**
 显示当前DP状态
 */
@property(nonatomic,assign)YHDPStatus dpStatus;

/**
 当DP处于isloadmoreing状态时候，如果用户下拉刷新头部时候，停止头部刷新操作
 */
@property(nonatomic,copy)dispatch_block_t stopRefreshWhenIsLoadMoreingBlock;


/**
 当DP处理isRefreshing状态时候，如果用户上拉加载更多，停止加载更多操作
 */
@property(nonatomic,copy)dispatch_block_t stopLoadMoreWhenIsRefreshBlock;


/**
 load more dp初始化方法

 @param netHandle delegate
 @param stopRefreshWhenIsLoadMoreingBlock 当处于加载更多状态时候，如果下拉刷新，则停止刷新
 @param stopLoadMoreWhenIsRefreshBlock 当处于刷新状态时候，如果上拉加载更多，则停止上拉加载更多
 @return id
 */
-(id)initWithHandle:(id<YHNetProtocol>)netHandle withStopRefresh: (dispatch_block_t) stopRefreshWhenIsLoadMoreingBlock
   withStopLoadMore:(dispatch_block_t)stopLoadMoreWhenIsRefreshBlock;

/**
 刷新DP
 */
-(void)refresh;

/**
 加载更多DP
 */
-(void)loadMore;

/**
 设置加载当一页

 @param pageNo No.
 */
-(void)setPageNo:(NSInteger)pageNo;


/**
 设置刷新第1页数据
 */
-(void)setFirstPageNo;

/**
 设置下一页页码
 */

-(void)setNextPageNo;


/**
 设置页码size

 @param pageSize size
 */
-(void)setPageSize:(NSInteger)pageSize;


/**
 是否还有下一页
子类加载更多必须重写该方法
 @return Yes
 */
-(BOOL)hasNextPage;

/**
 是否正在刷新
 */
//@property(nonatomic,assign)BOOL isRefreshing;
//
///**
// 是否正在加载更多
// */
//@property(nonatomic,assign)BOOL isLoadMoreing;

@end
