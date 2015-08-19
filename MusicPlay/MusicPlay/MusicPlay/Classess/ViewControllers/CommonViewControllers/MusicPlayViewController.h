//
//  MusicPlayViewController.h
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
#import "UIImageView+WebCache.h"

@interface MusicPlayViewController : UIViewController

@property (nonatomic, assign)NSInteger index;
@property (nonatomic,strong)MusicModel *model;
#pragma mark 单例
+(instancetype)shareInstance;

@end
