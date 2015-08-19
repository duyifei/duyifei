//
//  MusicListTableViewController.m
//  MusicPlay
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListTableViewCell.h"
#import "MusicManager.h"
#import "MusicPlayViewController.h"
#import "MusicPlayHelper.h"
#import "MusicModel.h"

@interface MusicListTableViewController ()
@property (nonatomic,strong)NSArray *musicArray;
@end

@implementation MusicListTableViewController

//懒加载
-(NSArray *)musicArray
{
    if (!_musicArray) {
        _musicArray = [NSArray array];
    }
    return _musicArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    [[MusicManager shareInstance]requestAllDataDidFinish:^(NSMutableArray *dataArray) {
        self.musicArray = dataArray;
        [self.tableView reloadData];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
      //获取每行对应的音乐模型
    MusicModel *model = [[MusicManager shareInstance]getMusicModelWithIndex:indexPath.row];
    cell.textLabel.highlighted = YES;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.musicModel = model;
    
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayViewController *musicPlayVC = [MusicPlayViewController shareInstance];
    UINavigationController *rootNC = [[UINavigationController alloc]initWithRootViewController:musicPlayVC];
 
    musicPlayVC.modalTransitionStyle = 1;
    musicPlayVC.index = indexPath.row;
    [self.navigationController presentViewController:rootNC animated:YES completion:nil];
    
}

/*00000.............................
 
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UITableViewCell *cell = sender;
//    NSIndexPath *indexPath = [self.tableView  indexPathForCell:cell];
//    
//}


@end
