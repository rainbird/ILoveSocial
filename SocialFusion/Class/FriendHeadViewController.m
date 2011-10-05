//
//  FriendHeadViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendHeadViewController.h"
#import "FriendHeadTableViewCell.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"

#define kCustomRowCount 3

@implementation FriendHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"FriendHeadViewController view did load");
    self.egoHeaderView.textColor = [UIColor darkGrayColor];
    _noAnimationFlag = YES;
}

- (void)dealloc {
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _gridCount = [super tableView:tableView numberOfRowsInSection:section];
    NSInteger result = _gridCount / 3;
    if(_gridCount % 3)
        result++;
    return result;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendHeadTableViewCell *relationshipCell = (FriendHeadTableViewCell *)cell;
    for(int i = 0; i < 3; i++) {
        NSInteger tempRow = indexPath.row * 3 + i;
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:indexPath.section];
        FriendHeadGridViewController *gridViewController = [relationshipCell.headGridArray objectAtIndex:i];
        //NSLog(@"gridCount:%d, tempRow:%d", _gridCount, tempRow);
        //这里要判断用户数量够不够
        if (tempRow > _gridCount - 1) {
            gridViewController.defaultHeadImageView.hidden = YES;
            gridViewController.userName.hidden = YES;
        }
        else {
            User *usr = [self.fetchedResultsController objectAtIndexPath:tempIndexPath];
            gridViewController.defaultHeadImageView.hidden = NO;
            gridViewController.userName.hidden = NO;
        
            gridViewController.headImageView.image = nil;
            gridViewController.userName.text = usr.name;
            
            NSData *imageData = nil;
            if([Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext]) {
                imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].imageData.data;
            }
            if(imageData == nil) {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                    if(indexPath.row < kCustomRowCount) {
                        [gridViewController.headImageView loadImageFromURL:usr.tinyURL completion:^{
                            [self showHeadImageAnimation:gridViewController.headImageView];
                        } cacheInContext:self.managedObjectContext];
                    }
                }
            }
            else {
                gridViewController.headImageView.image = [UIImage imageWithData:imageData];
            }
        }
    }
}

- (NSString *)customCellClassName
{
    return @"FriendHeadTabelViewCell";
}



- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath
{
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    for(int i = 0; i < 3; i++) {
        //这里要判断用户数量够不够
        NSInteger tempRow = indexPath.row * 3 + i;
        //NSLog(@"tempRow:%d", tempRow);
        if (tempRow > _gridCount - 1)
            break;
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:indexPath.section];
        User *usr = [self.fetchedResultsController objectAtIndexPath:tempIndexPath];
        Image *image = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            FriendHeadTableViewCell *relationshipCell = (FriendHeadTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            FriendHeadGridViewController *gridViewController = [relationshipCell.headGridArray objectAtIndex:i];
            gridViewController.defaultHeadImageView.hidden = NO;
            gridViewController.userName.hidden = NO;
            [gridViewController.headImageView loadImageFromURL:usr.tinyURL completion:^{
                [self showHeadImageAnimation:gridViewController.headImageView];
            } cacheInContext:self.managedObjectContext];
        }
    }
}

@end
