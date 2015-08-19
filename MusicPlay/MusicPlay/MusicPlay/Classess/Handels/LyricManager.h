//
//  LyricManager.h
//  MusicPlay
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LyricManager : NSObject
+(instancetype)shareInstance;
//返回数组元素数量
-(NSInteger)getCount;
//歌词格式化
-(void)lyricWithIndex:(NSInteger)index;

//根据时间返回 index
-(NSInteger)indexOfCurrentTime:(CGFloat)time;
//根据下标返回播放时间
-(CGFloat)timeAtIndex:(NSInteger)index;
//cell上显示的歌词
-(NSString *)lyricAtIndex:(NSInteger)index;
@end
