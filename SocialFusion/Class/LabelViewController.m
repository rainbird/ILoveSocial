//
//  LabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelViewController.h"
#import "LabelTableViewCell.h"

#define kLeftLabelWidth 75
#define kRightLabelWidth 6
#define kLabelHeight 44
#define kHeaderAndFooterWidth 7

@implementation LabelViewController
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize labelName = _labelName;

- (id)init {
    self = [super init];
    if(self) {
        _labelName = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView.delegate = nil;
    self.tableView = nil;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger result;
    if(row % 4 == 3) {
        result = kLeftLabelWidth + kRightLabelWidth + kHeaderAndFooterWidth * 2;
    }
    else {
        result = kLeftLabelWidth;
    }
    return result;
}

- (void)setCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    // if there is a label on the selected label right hand
    for(int i = indexPath.row - indexPath.row % 4; i < _labelName.count && i < 4 - indexPath.row % 4 + indexPath.row; i++) {
        LabelTableViewCell *cell = (LabelTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        if(i <= indexPath.row)
            cell.highlightLeftLabelImage.hidden = YES;
        else
            cell.highlightLeftLabelImage.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        // 最左边的label
        cell.leftLabelImage.hidden = YES;
        cell.rightLabelImage.hidden = YES;
        cell.highlightLeftLabelImage.hidden = YES;
    }
    else if(indexPath.row % 4 == 3) {
        // 最右边的label
        cell.leftLabelImage.hidden = NO;
        cell.rightLabelImage.hidden = NO;
        cell.highlightLeftLabelImage.hidden = NO;
    }
    else {
        // 中间的label
        cell.leftLabelImage.hidden = NO;
        cell.rightLabelImage.hidden = YES;
        cell.highlightLeftLabelImage.hidden = NO;
    }
    
    if(indexPath.row == _labelName.count - 1) {
        // 最最右边的label
        NSLog(@"here!!!!");
        cell.rightLabelImage.hidden = NO;
    }
    
    // 接下来判断当前滑动到的page有被选中的label的情况
    if(indexPath.row >= _currentCellIndexPath.row - _currentCellIndexPath.row % 4
       && indexPath.row < 4 - _currentCellIndexPath.row % 4 + _currentCellIndexPath.row) {
        if(indexPath.row <= _currentCellIndexPath.row) {
            cell.highlightLeftLabelImage.hidden = YES;
        }
        else {
            cell.highlightLeftLabelImage.hidden = NO;
        }
    }
    
    if(indexPath.row < _labelName.count)
        cell.labelName.text = [_labelName objectAtIndex:indexPath.row];
    else 
        cell.hidden = YES;
    return cell;
}

@end
