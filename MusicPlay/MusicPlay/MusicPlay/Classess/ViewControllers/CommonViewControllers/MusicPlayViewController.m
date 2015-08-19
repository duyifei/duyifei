//
//  MusicPlayViewController.m
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicManager.h"
#import "MusicPlayHelper.h"
#import "LyricManager.h"



@interface MusicPlayViewController ()<UITableViewDataSource,UITableViewDelegate,MusicPlayingDelegate>
{
    NSInteger _currentIndex; ////记录当前歌曲模型下标
    
}

@property (strong, nonatomic) IBOutlet UITableView *LyricTableView;

@property (strong, nonatomic) IBOutlet UIImageView *singerImageView;

@property (strong, nonatomic) IBOutlet UISlider *musicProgressSlider;

- (IBAction)timeSliderAction:(UISlider *)sender;

- (IBAction)UpSing:(UIButton *)sender;

- (IBAction)PlayOrPause:(UIButton *)sender;

- (IBAction)DownSing:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *currentTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *durationTimeLable;

@end

@implementation MusicPlayViewController
#pragma mark - 单例创建
+(instancetype)shareInstance
{
    static MusicPlayViewController *musicPlay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlay = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"musicPlay"];;
    });
    return musicPlay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置圆角度
    [self setImageView];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnLastPage:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
        // Do any additional setup after loading the view.
    _currentIndex = -1;
    
    [MusicPlayHelper defaultHelper].delegate = self;
    
    
    
}

-(void)returnLastPage:(UIBarButtonItem *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (_currentIndex == self.index) {
        return;
    }else
    {
        _currentIndex = self.index;
        [self updateUI];
        
    }
    
}




#pragma mark - 更新界面
-(void)updateUI
{
    //设置音乐播放器
    [[MusicPlayHelper defaultHelper]setAVPlayerWithUrl:self.model.mp3Url];
    
    self.navigationItem.title = self.model.name;

    //设置图片
    [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl] placeholderImage:nil];
    CGFloat duration = [self.model.duration floatValue]/1000;
    self.musicProgressSlider.maximumValue = duration;
    //获取歌词
    [[LyricManager shareInstance]lyricWithIndex:_currentIndex];
    
    [self.LyricTableView reloadData];
}

#pragma mark - 获取模型
-(MusicModel *)model
{
    _model = [[MusicManager shareInstance]getMusicModelWithIndex:_currentIndex];
    
    return _model;
    
}

#pragma mark - 设置 ImageView
-(void)setImageView
{
    //设置圆角
    [self.singerImageView layoutIfNeeded];
    self.singerImageView.layer.cornerRadius = CGRectGetWidth(self.singerImageView.frame)/2;
    self.singerImageView.layer.masksToBounds = YES;
       // self.singerImageView.clipsToBounds = YES;
    
    //设置起始角度为0
    self.singerImageView.transform = CGAffineTransformMakeRotation(0);
    

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 上一曲

- (IBAction)UpSing:(UIButton *)sender
{
    //先暂停播放
    [[MusicPlayHelper defaultHelper]pauseMusic];
    //获取上一首歌曲模型播放地址 并设置播放器自动播放
    _currentIndex--;
    if (_currentIndex < 0) {
        _currentIndex = [[MusicManager shareInstance]musicCount] - 1 ;
    }
    [self updateUI];
    
}
#pragma mark - 暂停或播放
- (IBAction)PlayOrPause:(UIButton *)sender
{
    BOOL isplaying = [[MusicPlayHelper defaultHelper]playOrPauseMusic];
    if (isplaying) {
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else
    {
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        
    }
    
}
#pragma mark - 下一曲
- (IBAction)DownSing:(UIButton *)sender
{
    /**
     *先暂停播放
     *下标加1
     *获取音乐播放地址
     *切换歌曲播放
     *更新界面信息
     **/
    [[MusicPlayHelper defaultHelper]pauseMusic];
    _currentIndex ++;
    if (_currentIndex > [[MusicManager shareInstance]musicCount]-1) {
        _currentIndex = 0 ;
    }
    
    [self updateUI];
    
}
#pragma mark - 时间滑竿拖动事件  从指定时间播放
- (IBAction)timeSliderAction:(UISlider *)sender
{
    CGFloat duration = [[self.model duration] floatValue]/1000;
    if (sender.value >= duration) {
        [[MusicPlayHelper defaultHelper]pauseMusic];
        return;
    }
    [[MusicPlayHelper defaultHelper]seekToTimePlay:sender.value];
}

#pragma mark - MusicPlayHelper 代理方法
#pragma mark 播放过程中执行
-(void)playingWithProgress:(CGFloat)progress
{
    
    //1.图片旋转
    self.singerImageView.transform = CGAffineTransformRotate(self.singerImageView.transform, M_1_PI/180);
    
    
    //2.进度条
    self.musicProgressSlider.value = progress;
    
    //当期播放时间
    self.currentTimeLable.text =[self changeFormatWithTime:progress];
    
    //剩余时间
    CGFloat duration = [[self.model duration] floatValue]/1000;
    self.durationTimeLable.text = [self changeFormatWithTime:duration-progress];
    
    
    //获取下标
   NSInteger index = [[LyricManager shareInstance]indexOfCurrentTime:progress];
    
    
    //组拼indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self. LyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


#pragma mark 播放结束

-(void)playDidToEnd
{
    _currentIndex++;
    //如果播放到最后一首歌  切换到第一首播放
    if (_currentIndex > [[MusicManager shareInstance]musicCount]-1) {
        _currentIndex = 0;
    }
    //刷新界面相关信息
    [self updateUI];
}


#pragma mark - 转换时间格式

-(NSString *)changeFormatWithTime:(CGFloat)time
{
    //计算分钟
    int minute = time/60;
    //计算秒
    int seconds = (int)time%60;
    
    NSString *timeFormat = [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
    return timeFormat;
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  return   [[LyricManager shareInstance]getCount];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id_cell = @"cell";
     UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:id_cell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id_cell];
    }
    
    //根据下标获取歌词
    NSString *lyric = [[LyricManager shareInstance]lyricAtIndex:indexPath.row];
    cell.textLabel.text = lyric;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [[UIView alloc]init];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:(arc4random()%256/256.0) green:(arc4random()%256/256.0) blue:(arc4random()%256/256.0) alpha:(arc4random()%256/256.0)];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据下标返回时间
    
    CGFloat time = [[LyricManager shareInstance]timeAtIndex:indexPath.row];
    [[MusicPlayHelper defaultHelper]seekToTimePlay:time];
    
    
}

@end
