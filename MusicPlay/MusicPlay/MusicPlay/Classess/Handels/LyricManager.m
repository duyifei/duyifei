//
//  LyricManager.m
//  MusicPlay
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "LyricManager.h"
#import "MusicManager.h"
#import "LyricModel.h"

@interface LyricManager ()
@property (nonatomic,strong)NSMutableArray *allDataArray;

@end

@implementation LyricManager
+(instancetype)shareInstance
{
    static LyricManager *lyric = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyric = [[LyricManager alloc]init];
        lyric.allDataArray = [NSMutableArray array];
        
    });
    return lyric;
}
//返回数组元素数量
-(NSInteger)getCount
{
    return    self.allDataArray.count;
    
}
//格式化歌词
-(void )lyricWithIndex:(NSInteger)index
{
  
    [self.allDataArray removeAllObjects];
    MusicModel *model = [[MusicManager shareInstance]getMusicModelWithIndex:index];
    
    //接收歌词
    NSString *str = model.lyric;
    
    //根据换行符切分歌词"\n"
    
   NSArray *array1 = [str componentsSeparatedByString:@"\n"];
    
    //[01:0222]如果能重来
    for (int i =0 ;i <array1.count-1;i++) {
        NSArray *array2 = [array1[i]componentsSeparatedByString:@"]"];
        
        //歌词时间[02:33.56
        NSString *time = [array2 firstObject];
       
        //根据':'切分时间
        
        NSArray *time2 = [time componentsSeparatedByString:@":"];
        //[02分  23.56秒]
        
        if ([[time2 firstObject] length]<1) {
            break;
        }
        
        NSString *mintues = [[time2 firstObject]substringFromIndex:1];
        
        //计算总时长
        CGFloat total = [mintues floatValue]*60 + [time2.lastObject floatValue];
        
        //歌词
        NSString *lyricStr = array2.lastObject;
        
        //model 接收
        LyricModel *lyricModel = [[LyricModel alloc]init];
        lyricModel.time = total;
        lyricModel.lyric = lyricStr;
        [self.allDataArray addObject:lyricModel];
        
    }
    
    
}
//cell上显示的歌词
-(NSString *)lyricAtIndex:(NSInteger)index
{
    LyricModel *lyricModel = self.allDataArray[index];
    NSString *lyric = lyricModel.lyric;

    return lyric;
}
                                                  
#pragma mark - 根据时间返回下标
-(NSInteger)indexOfCurrentTime:(CGFloat)time
{
    NSInteger index = 0;
    for (int i = 0; i<self.allDataArray.count; i++) {
        
    
    
    LyricModel *lyricModel = self.allDataArray[i];
    
    if (lyricModel.time > time) {
        
        index = i - 1 >0 ? i - 1 : 0;
        break;
      }
    }
    return index;
    
}
#pragma mark - 根据下标返回播放时间
-(CGFloat)timeAtIndex:(NSInteger)index
{
    //index LyricModel 时间 歌词
    LyricModel *model = self.allDataArray[index];
    CGFloat time = model.time;
    return time;
    
    
}
@end
