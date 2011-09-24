//
//  LabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelViewController.h"
#import "LabelTableViewCell.h"


@implementation LabelViewController
@synthesize tableView = _tableView;

- (id)init {
    self = [super init];
    if(self) {
        _labelName = [[NSMutableArray alloc] init];
        [_labelName addObject:[NSString stringWithString:@"微博"]];
        [_labelName addObject:[NSString stringWithString:@"关注"]];
        [_labelName addObject:[NSString stringWithString:@"粉丝"]];
        [_labelName addObject:[NSString stringWithString:@"收藏"]];
        [_labelName addObject:[NSString stringWithString:@"个人信息"]];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"label view controller dealloc");
    [_tableView release];
    [_labelName release];
    [super dealloc];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)loadView 
{
    [super loadView];
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;
    CGRect oldFrame = self.tableView.frame;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	self.tableView.frame = oldFrame;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView.delegate = nil;
    self.tableView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_labelName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"labelCell";
    
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.labelName.text = [_labelName objectAtIndex:indexPath.row];
    return cell;
}

@end
