//
//  NewFeedStatusWithRepostcell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusWithRepostcell.h"
#import "CommonFunction.h"

@implementation NewFeedStatusWithRepostcell


@synthesize repostUserName = _repostUserName;
@synthesize repostAreaButton = _repostAreaButton;
@synthesize repostAreaButtonCursor = _repostAreaButtonCursor;
@synthesize repostStatus = _repostStatus;


- (void)dealloc
{
    
    [_repostUserName release];
    [_repostAreaButton release];
    [_repostStatus release];
    

    [_repostAreaButtonCursor release];
    
    [super dealloc];
}

-(void)configureCell:(NewFeedData*)feedData
{

    [super configureCell:feedData];

     [_picView setImage:nil];
    
    

    
    //NSLog(@"%@",tempString);
    
    [self.repostUserName setTitle:[feedData getPostName]  forState:UIControlStateNormal];
    
    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,self.repostAreaButton.frame.size.height); 
    
    
    
    
    self.repostStatus.text=[feedData getPostMessage];
    
    
    
   CGSize size = CGSizeMake(200, 1000);
    
    
    CGSize labelSize1 = [self.repostStatus.text sizeWithFont:self.repostStatus.font 
                                           constrainedToSize:size];
    
    self.repostStatus.frame = CGRectMake(self.repostAreaButton.frame.origin.x+5, self.repostAreaButton.frame.origin.y+5,
                                         self.repostStatus.frame.size.width, labelSize1.height);
    
    self.repostStatus.lineBreakMode = UILineBreakModeWordWrap;
    self.repostStatus.numberOfLines = 0;
    
    
    self.repostAreaButton.contentMode=UIViewContentModeScaleToFill;
    self.repostUserName.frame=  CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y-1,
                                           self.repostUserName.frame.size.width, self.repostUserName.frame.size.height);
    

    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,labelSize1.height+10); 
    
    
    
    self.repostAreaButtonCursor.frame = CGRectMake(self.repostAreaButton.frame.origin.x+20, self.repostAreaButton.frame.origin.y-7,
                                                   self.repostAreaButtonCursor.frame.size.width, self.repostAreaButtonCursor.frame.size.height); 
    

 //   self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+labelSize1.height+50);
    
    
    [self.repostUserName sizeToFit];

    
    
    //时间
    NSDate* FeedDate=[feedData getDate];
    
    
    NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    
    //NSLog(@"%@",tempString);
    
    
    
    
    self.time.frame = CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y+self.repostStatus.frame.size.height+10,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    
    self.time.text=tempString ;
    [tempString release];
    
    
    
    //回复数量
    NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
    _commentCount.text=countSting;
    [countSting release];
    [_commentCount sizeToFit];
    [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
    

    
    
}





@end
