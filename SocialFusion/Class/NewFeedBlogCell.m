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
    
    
    [self.headImageView setImage:nil];
    
    self.status.text=[feedData getName];
    
    [self.userName setTitle:[feedData getFeedName] forState:UIControlStateNormal];
    
    // [cell.status sizeToFit];
    
    
    
    
    
    CGSize size = CGSizeMake(212, 1000);
    
    
    CGSize labelSize = [self.status.text sizeWithFont:self.status.font 
                                    constrainedToSize:size];
    
    self.status.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y,
                                   self.status.frame.size.width, labelSize.height);
    
    self.status.lineBreakMode = UILineBreakModeWordWrap;
    self.status.numberOfLines = 0;
    
    
    
    self.blog.text=[feedData getBlog];
    
    
    CGSize size1 = CGSizeMake(212, 1000);
    
    
    CGSize labelSize1 = [self.blog.text sizeWithFont:self.blog.font 
                                    constrainedToSize:size1];
    
    self.blog.frame = CGRectMake(self.blog.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                   212, labelSize1.height);
    
    self.blog.lineBreakMode = UILineBreakModeWordWrap;
    self.blog.numberOfLines = 0;
    
   
    
    if (self.frame.size.height<50)
    {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+20);
    }
    
    
    NSDate* FeedDate=[feedData getDate];
    
    //NSLog(@"%@",FeedDate);
    int time=-[FeedDate timeIntervalSinceNow];
    
    NSString* tempString;
    if (time<0)
    {
        tempString=[[NSString alloc] initWithFormat:@"0秒前"];
    }
    else if (time<60)
    {
        tempString=[[NSString alloc] initWithFormat:@"%d秒前",time];
    }
    else if (time<3600)
    {
        tempString=[[NSString alloc]  initWithFormat:@"%d分钟前",time/60];
    }
    else if (time<(3600*24))
    {
        tempString= [[NSString alloc]  initWithFormat:@"%d小时前",time/3600];
    }
    else
    {
        tempString= [[NSString alloc]  initWithFormat:@"%d小时前",time/(3600*24)];
    }
    
    //NSLog(@"%@",tempString);
    
    self.time.frame = CGRectMake(self.status.frame.origin.x, self.blog.frame.origin.y+self.blog.frame.size.height,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=tempString ;
    [tempString release];

    

    [self.userName sizeToFit];
}




@end
