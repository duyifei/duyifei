//
//  MusicPlayHelper.m
//  MusicPlay
//
//  Created by lanou3g on 15/8/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayHelper.h"

@interface MusicPlayHelper ()
{
    BOOL isPlaying;
}
@property (nonatomic,strong)NSTimer *timer;
@end

static AVPlayer *avPlayer = nil;
@implementation MusicPlayHelper

#pragma mark - 单例
+(instancetype)defaultHelper
{
    static MusicPlayHelper *musicHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicHelper = [[MusicPlayHelper alloc]init];
        //初始化音乐播放器
        avPlayer = [[AVPlayer alloc]init];
    });
    
    return musicHelper;

}

#pragma mark - 设置音乐播放器
-(void)setAVPlayerWithUrl:(NSString *)url
{
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    
    [avPlayer replaceCurrentItemWithPlayerItem:item];
    
    [self playMusic];
    
    
}

#pragma mark - 播放音乐
-(void)playMusic
{
    
    [avPlayer play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction) userInfo:nil repeats:YES];
    isPlaying = YES;
}

#pragma mark - 暂停播放
-(void)pauseMusic
{
    isPlaying = NO;
    [avPlayer pause];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 暂停或播放
-(BOOL)playOrPauseMusic
{
    if (isPlaying) {
        [self pauseMusic];
        return NO;
        
    }else{
        [self playMusic];
        return YES;
        
    }
    
}

#pragma mark - 从指定时间播放
-(void)seekToTimePlay:(CGFloat)time
{
    //先暂停
    [self pauseMusic];
    //将时间设置为指定时间
   [avPlayer seekToTime:CMTimeMakeWithSeconds(time, avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
       if (finished) {
           //开始播放
           [self playMusic];
       }
   }];
}


#pragma mark - 私有方法

#pragma mark - 播放过程中执行
-(void)playingAction
{
    //把当前播放时间(进度)给音乐播放界面
    CGFloat time = avPlayer.currentTime.value/avPlayer.currentTime.timescale;
    if (self.delegate && [self.delegate performSelector:@selector(playingWithProgress:)]) {
        
        [self.delegate playingWithProgress:time];
    }
    
}


#pragma mark - 播放结束执行
-(void)musicDidFinished
{
    if (self.delegate && [self.delegate performSelector:@selector(playingWithProgress:)]) {
        [self.delegate playDidToEnd];
    }
}

@end
