//
//  MusicListTableViewCell.m
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation MusicListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setMusicModel:(MusicModel *)musicModel
{
    [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl] placeholderImage:nil];
        self.singerNameLable.text = musicModel.singer;
    self.musicNameLable.text = musicModel.name;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
