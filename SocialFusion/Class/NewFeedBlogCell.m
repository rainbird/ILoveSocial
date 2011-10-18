//
//  NewFeedBlogCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedBlogCell.h"


@implementation NewFeedBlogCell
@synthesize blog=_blog;

- (void)dealloc
{

    [_blog release];
        [super dealloc];
}

-(void)configureCell:(NewFeedData*)feedData
{
    
    
    [super configureCell:feedData];
    
 
    
    
    
    self.blog.text=[feedData getBlog];
    
    
    CGSize size1 = CGSizeMake(212, 1000);
    
    
    CGSize labelSize1 = [self.blog.text sizeWithFont:self.blog.font 
                                    constrainedToSize:size1];
    
    self.blog.frame = CGRectMake(self.blog.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                   212, labelSize1.height);
    
    self.blog.lineBreakMode = UILineBreakModeWordWrap;
    self.blog.numberOfLines = 0;
    
   
    NSDate* FeedDate=[feedData getDate];
    
    //NSLog(@"%@",FeedDate);
    
    NSString* tempString=[NewFeedStatusCell getTimeBefore:FeedDate];
    
    
    //NSLog(@"%@",tempString);
    
    self.time.frame = CGRectMake(self.status.frame.origin.x, self.blog.frame.origin.y+self.blog.frame.size.height,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=tempString ;
    [tempString release];
    
    NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
    _commentCount.text=countSting;
    [countSting release];
    [_commentCount sizeToFit];
    [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
    
    

    
}




@end
