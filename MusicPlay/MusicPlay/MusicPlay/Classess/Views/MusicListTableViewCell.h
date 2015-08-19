//
//  MusicListTableViewCell.h
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *singerImageView;

@property (strong, nonatomic) IBOutlet UILabel *musicNameLable;
@property (strong, nonatomic) IBOutlet UILabel *singerNameLable;

@property (strong,nonatomic) MusicModel *musicModel;

@end
