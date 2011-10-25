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
@synthesize backLabelName = _backLabelName;

- (id)init {
    self = [super init];
    if(self) {
        _labelStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_backLabelName release];
    [_tableView release];
    [_labelStack release];
    _delegate = nil;
    [super dealloc];
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"backLabelName"]){
        NSLog(@"old:%@", [change objectForKey:@"old"]);
        NSLog(@"new:%@", [change objectForKey:@"new"]);
        NSString *old = [change objectForKey:@"old"];
        NSString *new = [change objectForKey:@"new"];
        if(old == nil && new) {
            [_labelName insertObject:new atIndex:0];
        }
        else if(old && new == nil) {
            [_labelName removeObjectAtIndex:0];
        }
        else {
            [_labelName removeObjectAtIndex:0];
            [_labelName insertObject:new atIndex:0];
        }
        [self.tableView reloadData];
    }
}*/

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect oldFrame = self.tableView.frame;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	self.tableView.frame = oldFrame;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;  
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
        if(i <= indexPath.row) {
            if (i % 4 != 0) {
                cell.leftLabelImage.hidden = NO;
            }
            cell.highlightLeftLabelImage.hidden = YES;
            if(i == indexPath.row) {
                cell.selected = YES;
            }
        }
        else {
            cell.highlightLeftLabelImage.hidden = NO;
            cell.leftLabelImage.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCellSelectedAtIndexPath:indexPath];
    if(_labelStack.count > 1) {
        if(indexPath.row == 0) {
            [self.delegate didSelectBackLabel];
        }
        else {
            [self.delegate didSelectLabelAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] withLabelName:[_labelName objectAtIndex:indexPath.row]];
            _currentCellIndexPath = indexPath;
        }
    }
    else {
        [self.delegate didSelectLabelAtIndexPath:indexPath withLabelName:[_labelName objectAtIndex:indexPath.row]];
        _currentCellIndexPath = indexPath;
    }
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
    
    // 接下来判断当前滑动到的page有被选中的label的情况
    if(indexPath.row >= _currentCellIndexPath.row - _currentCellIndexPath.row % 4
       && indexPath.row < 4 - _currentCellIndexPath.row % 4 + _currentCellIndexPath.row) {
        if(indexPath.row <= _currentCellIndexPath.row) {
            cell.highlightLeftLabelImage.hidden = YES;
            cell.leftLabelImage.hidden = NO;
        }
        else {
            cell.highlightLeftLabelImage.hidden = NO;
            cell.leftLabelImage.hidden = YES;
        }
    }
    
    if(indexPath.row % 4 == 0) {
        // 最左边的label
        cell.leftLabelImage.hidden = YES;
        cell.rightLabelImage.hidden = YES;
        cell.highlightLeftLabelImage.hidden = YES;
    }
    else if(indexPath.row % 4 == 3) {
        // 最右边的label
        cell.leftLabelImage.hidden = YES;
        cell.rightLabelImage.hidden = NO;
        cell.highlightLeftLabelImage.hidden = NO;
    }
    else {
        // 中间的label
        cell.leftLabelImage.hidden = YES;
        cell.rightLabelImage.hidden = YES;
        cell.highlightLeftLabelImage.hidden = NO;
    }
    
    if(indexPath.row == _labelName.count - 1) {
        // 最最右边的label
        cell.rightLabelImage.hidden = NO;
    }
    
    if(indexPath.row < _labelName.count)
        cell.labelName.text = [_labelName objectAtIndex:indexPath.row];
    else 
        cell.hidden = YES;
    return cell;
}

- (void)pushLabels:(NSMutableArray *)labels {
    _previousCellIndexPath = _currentCellIndexPath;
    _currentCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_labelStack addObject:labels];
    _labelName = labels;
    self.backLabelName = [_labelName objectAtIndex:0];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:_currentCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self setCellSelectedAtIndexPath:_currentCellIndexPath];
}

- (void)popLabels {
    if(_labelStack.count > 1) {
        _currentCellIndexPath = _previousCellIndexPath;
        [_labelStack removeLastObject];
        _labelName = _labelStack.lastObject;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:_currentCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setCellSelectedAtIndexPath:_currentCellIndexPath];
        self.backLabelName = [_labelName objectAtIndex:0];
    }
    else {
        self.backLabelName = nil;
    }
}

@end
