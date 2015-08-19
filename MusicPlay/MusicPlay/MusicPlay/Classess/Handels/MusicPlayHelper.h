//
//  MusicPlayHelper.h
//  MusicPlay
//
//  Created by lanou3g on 15/8/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MusicPlayingDelegate <NSObject>
/**
 *歌曲播放过程中执行此方法
 *@param progress 播放时间(歌曲进度)
 **/

-(void)playingWithProgress:(CGFloat)progress;

/**
 *歌曲播放结束执行
 **/

-(void)playDidToEnd;

@end


@interface MusicPlayHelper : NSObject
@property (nonatomic,assign)id<MusicPlayingDelegate>delegate;

#pragma mark - 单例
+(instancetype)defaultHelper;
/*
 **根据url设置音乐播放器
 **@param url 音乐播放地址
 */
-(void)setAVPlayerWithUrl:(NSString *)url;
/**
 *播放
 **/
-(void)playMusic;

/**
 *暂停
 **/
-(void)pauseMusic;

/**
 *播放/暂停
 *返回当前状态  YES 正在播放 NO 暂停
 */
-(BOOL)playOrPauseMusic;
/**
 *从指定时间开始播放
 *@param time 指定时间
 **/
-(void)seekToTimePlay:(CGFloat)time;


@end
