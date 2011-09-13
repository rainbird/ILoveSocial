//
//  FriendProfileViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "FreindProfileTabelViewCell.h"
#import "UIImageView+DispatchLoad.h"
#import "RenrenUser.h"
#import "WeiboUser.h"
#import "RenrenStatus.h"
#import "WeiboStatus.h"
#import "RenrenClient.h"
#import "WeiboClient.h"

@implementation FriendProfileViewController
@synthesize friendsList = _friendsList,
            tablev = _tablev,
            friendStatus = _friendStatus;
@synthesize managedObjectContext;

+ (FriendProfileViewController *)controllerWithContext:(NSManagedObjectContext *)managedObjectContext {
    FriendProfileViewController *aController = [[FriendProfileViewController alloc] init];
    aController.managedObjectContext = managedObjectContext;
    /*NSArray *renrenUsers = [RenrenUser allUsersInManagedObjectContext:aController.managedObjectContext];
    NSLog(@"renren count:%d", [renrenUsers count]);
    NSArray *weiboUsers = [WeiboUser allUsersInManagedObjectContext:aController.managedObjectContext];
    NSLog(@"weibo count:%d", [weiboUsers count]);
    NSArray *allUsers = [renrenUsers arrayByAddingObjectsFromArray:weiboUsers];
    NSLog(@"all count:%d", [allUsers count]);
    
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    aController.friendsList = [allUsers sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByID]];
    NSLog(@"all count sorted:%d", [aController.friendsList count]);*/
    return aController;
}

- (id)init {
    self = [super init];
    if(self) {
        NSLog(@"init friend profile view controller");
        self.friendStatus = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = view;

    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    self.tablev = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    [self.tablev setDelegate:self];
    [self.tablev setDataSource:self];
    self.tablev.scrollEnabled = YES;
    self.tablev.backgroundColor = [UIColor clearColor];
    self.tablev.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tablev];
    
    // load friend list
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *friends = client.responseJSONObject;
            for(NSDictionary *dict in friends) {
                //NSLog(@"friends profile:%@", dict);
                [RenrenUser insertFriend:dict inManagedObjectContext:self.managedObjectContext];
            }
            self.friendsList = [RenrenUser allFriendsInManagedObjectContext:self.managedObjectContext];
            [self.tablev reloadData];
        }
    }];
    [renren getFriendsProfile];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.managedObjectContext = nil;
    self.friendsList = nil;
    self.tablev = nil;
    self.friendStatus = nil;
    [super dealloc];
}

- (void)loadFriendsDataCompleted {
    NSLog(@"load all friends data completed");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Friend Profile Cell";
    FreindProfileTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =
        [[[FreindProfileTabelViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] 
         autorelease];
    }
    RenrenUser* renrenFriend = [self.friendsList objectAtIndex:indexPath.row];
    cell.textLabel.text = renrenFriend.name;
    cell.imageView.image = nil;
    
    if(renrenFriend.tinyURLData != nil) {
        cell.imageView.image = [UIImage imageWithData:renrenFriend.tinyURLData]; 
    }
    else {
        [cell.imageView setImageFromUrl:renrenFriend.tinyURL completion:^(void) {
            //判断url所属的好友是否显示在当前cell中 不显示则不赋值
            BOOL find = NO;
            NSIndexPath *findIndex = nil;
            NSArray *visibleCellIndexes = [self.tablev indexPathsForVisibleRows];
            for(NSIndexPath *index in visibleCellIndexes) {
                RenrenUser* friend = [self.friendsList objectAtIndex:index.row];
                NSLog(@"visible row:%d,tinyURL:%@,visiblefriend url:%@",index.row,renrenFriend.tinyURL,friend.tinyURL);
                if([friend.tinyURL isEqualToString:renrenFriend.tinyURL]) {
                    find = YES;
                    findIndex = index;
                    break;
                }
            }
            if(find == NO)
                return;
            UITableViewCell *findCell = [self.tablev cellForRowAtIndexPath:findIndex];
            [findCell setNeedsLayout];
            //缓存图片 避免每一次加载浪费流量
            NSData *imageData = UIImageJPEGRepresentation(findCell.imageView.image, 1.0);
            RenrenUser *findUser = [self.friendsList objectAtIndex:findIndex.row];
            findUser.tinyURLData = imageData;
        }];
    }
    
    /*RenrenStatus *renrenStatus = [[[renrenFriend statuses] allObjects] lastObject];
    if(renrenStatus)
        cell.detailTextLabel.text = renrenStatus.text;
    else {
        cell.detailTextLabel.text = nil;
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSDictionary *dict = client.responseJSONObject;
                //缓存状态 避免每一次加载浪费流量
                [RenrenStatus insertStatus:dict inManagedObjectContext:self.managedObjectContext];
                NSString *statusBelongTo = [[dict objectForKey:@"uid"] stringValue];
                //判断状态所属的好友是否显示在当前cell中 不显示则不赋值
                BOOL find = NO;
                NSIndexPath *findIndex = nil;
                NSArray *visibleCellIndexes = [self.tablev indexPathsForVisibleRows];
                for(NSIndexPath *index in visibleCellIndexes) {
                    RenrenUser* friend = [self.friendsList objectAtIndex:index.row];
                    //NSLog(@"visible row:%d,status id:%@,visiblefriend id:%@",index.row,statusBelongTo,friend.userID);
                    if([friend.userID isEqualToString:statusBelongTo]) {
                        find = YES;
                        findIndex = index;
                        break;
                    }
                }
                if(find == NO)
                    return;
                //NSLog(@"status:%@",dict);
                UITableViewCell *findCell = [self.tablev cellForRowAtIndexPath:findIndex];
                findCell.detailTextLabel.text = [dict objectForKey:@"message"];
                [findCell setNeedsLayout];
            }
        }];
        [renren getLatestStatus:renrenFriend.userID];
    }*/
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)setFriendsList:(NSArray *)friendsList {
    if(_friendsList != friendsList) {
        [_friendsList release];
        _friendsList = [friendsList retain];
        // 此处可添加按中文排序的代码
    }
}

@end
