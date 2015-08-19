//
//  MusicManager.h
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
@interface MusicManager : NSObject
#pragma mark - 单例
+(instancetype)shareInstance;

/*
 **根据url请求数据
 **@param url 接口
 **@param result 请求完成后会执行此block
 **@param dataArray 返回请求到的数据
 */

-(void)requestAllDataDidFinish:(void(^)(NSMutableArray *dataArray))result;

/*
 **根据下标返回模型
 **@param index 下标
 */

-(MusicModel *)getMusicModelWithIndex:(NSInteger)index;

/*
 **返回数组个数
 **
 */
-(NSInteger )musicCount;
@end
