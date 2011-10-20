//
//  LabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelViewController.h"
#import "LabelTableViewCell.h"

#define kLeftLabelWidth 72
#define kRightLabelWidth 32
#define kLabelHeight 44
#define kHeaderAndFooterWidth 7

@implementation LabelViewController
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if(self) {
        _labelName = [[NSMutableArray alloc] init];
        [_labelName addObject:[NSString stringWithString:@"信息"]];
        [_labelName addObject:[NSString stringWithString:@"微博"]];
        [_labelName addObject:[NSString stringWithString:@"关注"]];
        [_labelName addObject:[NSString stringWithString:@"粉丝"]];
        [_labelName addObject:[NSString stringWithString:@"收藏"]];
        [_labelName addObject:[NSString stringWithString:@"若运"]];
        [_labelName addObject:[NSString stringWithString:@"君儒"]];
    }
    return self;
}

- (void)dealloc
{
    //NSLog(@"label view controller dealloc");
    [_tableView release];
    [_labelName release];
    _delegate = nil;
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.clipsToBounds = NO;
    self.tableView.scrollEnabled = YES;
    CGRect oldFrame = self.tableView.frame;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	self.tableView.frame = oldFrame;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;    
    //UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 7)] autorelease];
    //UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 7)] autorelease];
    //[self.tableView setTableHeaderView:headerView];
    //[self.tableView setTableFooterView:footerView];
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
    NSInteger row = indexPath.row;
    NSInteger result;
    if(row % 4 == 3) {
        result = kLeftLabelWidth + kRightLabelWidth;
    }
    else {
        result = kLeftLabelWidth;
    }
    return result;
}

- (void)setCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    // if there is a label on the selected label right hand
    for(int i = indexPath.row - indexPath.row % 4; i < _labelName.count && i < 4 - indexPath.row % 4 + indexPath.row; i++) {
        NSLog(@"cell i:%d", i);
        LabelTableViewCell *cell = (LabelTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        if(i <= indexPath.row)
            cell.highlightLeftLabelImage.hidden = YES;
        else
            cell.highlightLeftLabelImage.hidden = NO;
    }
}
- (void)setCellUnselectedAtIndexPath:(NSIndexPath *)indexPath {
    // if there is a label on the selected label right hand
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self setCellUnselectedAtIndexPath:_currentCellIndexPath];
    [self setCellSelectedAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(didSelectLabelAtIndexPath:)]) {
        [self.delegate didSelectLabelAtIndexPath:indexPath];
    }
    _currentCellIndexPath = indexPath;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _labelName.count;
    if(count % 4 != 0) {
        count += 4 - count % 4;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"labelCell";
    
    LabelTableViewCell *cell = (LabelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    
    if(indexPath.row % 4 == 0) {
        cell.leftLabelImage.hidden = YES;
        cell.rightLabelImage.hidden = YES;
    }
    else if(indexPath.row % 4 == 3) {
        cell.leftLabelImage.hidden = NO;
        cell.rightLabelImage.hidden = NO;
    }
    else {
        cell.leftLabelImage.hidden = NO;
        cell.rightLabelImage.hidden = YES;
    }
    
    if(indexPath.row == _labelName.count - 1) {
        cell.rightLabelImage.hidden = NO;
    }
    
    if(indexPath.row < _labelName.count)
        cell.labelName.text = [_labelName objectAtIndex:indexPath.row];
    else 
        cell.hidden = YES;
    return cell;
}

@end
