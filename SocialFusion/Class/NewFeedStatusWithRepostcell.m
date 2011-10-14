//
//  NewFeedStatusWithRepostcell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusWithRepostcell.h"


@implementation NewFeedStatusWithRepostcell


@synthesize repostUserName = _repostUserName;
@synthesize repostAreaButton = _repostAreaButton;
@synthesize repostAreaButtonCursor = _repostAreaButtonCursor;

@synthesize repostStatus = _repostStatus;


- (void)dealloc
{
    [super dealloc];
    [_repostUserName release];
    [_repostAreaButton release];
    [_repostStatus release];
}

-(void)configureCell:(NewFeedData*)feedData
{

    self.status.text=[feedData getName];
    
    [self.userName setTitle:[feedData getFeedName] forState:UIControlStateNormal];
    
    
    CGSize size = CGSizeMake(212, 1000);
    
    
    CGSize labelSize = [self.status.text sizeWithFont:self.status.font 
                                    constrainedToSize:size];
    
    self.status.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y,
                                   self.status.frame.size.width, labelSize.height);
    
    self.status.lineBreakMode = UILineBreakModeWordWrap;
    self.status.numberOfLines = 0;
    
    if (self.frame.size.height<70)
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
    
    [self.repostUserName setTitle:[feedData getPostName]  forState:UIControlStateNormal];
    
    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,self.repostAreaButton.frame.size.height); 
    
    
    
    
    self.repostStatus.text=[feedData getPostMessage];
    
    
    
    size = CGSizeMake(200, 1000);
    
    
    CGSize labelSize1 = [self.repostStatus.text sizeWithFont:self.repostStatus.font 
                                           constrainedToSize:size];
    
    self.repostStatus.frame = CGRectMake(self.repostAreaButton.frame.origin.x+5, self.repostAreaButton.frame.origin.y+5,
                                         self.repostStatus.frame.size.width, labelSize1.height);
    
    self.repostStatus.lineBreakMode = UILineBreakModeWordWrap;
    self.repostStatus.numberOfLines = 0;
    
    
    self.repostAreaButton.contentMode=UIViewContentModeScaleToFill;
    self.repostUserName.frame=  CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y-1,
                                           self.repostUserName.frame.size.width, self.repostUserName.frame.size.height);
    
    
    self.time.frame = CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y+self.repostStatus.frame.size.height+10,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=[tempString retain] ;
    [tempString release];
    
    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,labelSize1.height+10); 
    
    
    
    self.repostAreaButtonCursor.frame = CGRectMake(self.repostAreaButton.frame.origin.x+20, self.repostAreaButton.frame.origin.y-7,
                                                   self.repostAreaButtonCursor.frame.size.width, self.repostAreaButtonCursor.frame.size.height); 
    

    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+labelSize1.height+50);
    

    
}





@end
