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
        _cellIndexStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_backLabelName release];
    [_tableView release];
    [_labelStack release];
    [_cellIndexStack release];
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

- (void)setCellSelectedAtIndex:(NSInteger)index {
    // if there is a label on the selected label right hand
    for(int i = index - index % 4; i < _labelName.count && i < 4 - index % 4 + index; i++) {
        LabelTableViewCell *cell = (LabelTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(i <= index) {
            if (i % 4 != 0) {
                cell.leftLabelImage.hidden = NO;
            }
            cell.highlightLeftLabelImage.hidden = YES;
            if(i == index) {
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
    [self setCellSelectedAtIndex:indexPath.row];
    if(_labelStack.count > 1) {
        if(indexPath.row == 0) {
            [self.delegate didSelectBackLabel];
        }
        else {
            [self.delegate didSelectLabelAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] withLabelName:[_labelName objectAtIndex:indexPath.row]];
            _currentCellIndex = indexPath.row;
        }
    }
    else {
        [self.delegate didSelectLabelAtIndexPath:indexPath withLabelName:[_labelName objectAtIndex:indexPath.row]];
        _currentCellIndex = indexPath.row;
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
    if(indexPath.row >= _currentCellIndex - _currentCellIndex % 4
       && indexPath.row < 4 - _currentCellIndex % 4 + _currentCellIndex) {
        if(indexPath.row <= _currentCellIndex) {
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
    [_cellIndexStack addObject:[NSNumber numberWithInt:_currentCellIndex]];
    _currentCellIndex = 1;
    [_labelStack addObject:labels];
    _labelName = labels;
    self.backLabelName = [_labelName objectAtIndex:0];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentCellIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self setCellSelectedAtIndex:_currentCellIndex];
}

- (void)popLabels {
    if(_labelStack.count > 1) {
        _currentCellIndex = ((NSNumber *)[_cellIndexStack lastObject]).intValue;
        [_cellIndexStack removeLastObject];
        [_labelStack removeLastObject];
        _labelName = _labelStack.lastObject;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentCellIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setCellSelectedAtIndex:_currentCellIndex];
        self.backLabelName = [_labelName objectAtIndex:0];
    }
    else {
        self.backLabelName = nil;
    }
}

@end
