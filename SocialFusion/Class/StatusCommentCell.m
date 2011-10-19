//
//  StatusCommentCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "StatusCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h";
@implementation StatusCommentCell
@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;
@synthesize status = _status;
@synthesize time = _time;


+(float)heightForCell:(StatusCommentData*)feedData
{
    
 
            NSString* tempString=[feedData getText];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                      constrainedToSize:size];
            
            if (labelSize.height<50)
            {
                return 70;
            }
            
            return labelSize.height+20;
          
}



- (void)awakeFromNib
{
    self.defaultHeadImageView.layer.masksToBounds = YES;
    self.defaultHeadImageView.layer.cornerRadius = 5.0f;  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0f; 
    // [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_status release];
    [_time release];
    
    
    
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
     
    }
    return self;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    //NSLog(@"highlight:%d", highlighted);
    if(highlighted == NO && self.selected == YES)
        return;
    self.userName.highlighted = highlighted;
    
}   



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"selected:%d", selected);
    self.userName.highlighted = selected;
    
}

-(void)configureCell:(StatusCommentData*)feedData
{
    

    //头像
    [self.headImageView setImage:nil];
    
    
    //状态
    self.status.text=[feedData getText];
    
    CGSize size = CGSizeMake(212, 1000);
    CGSize labelSize = [self.status.text sizeWithFont:self.status.font 
                                    constrainedToSize:size];
    self.status.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y,
                                   self.status.frame.size.width, labelSize.height);
    self.status.lineBreakMode = UILineBreakModeWordWrap;
    self.status.numberOfLines = 0;
    
    
    if (self.frame.size.height<50)
    {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+20);
    }
    
    
    //名字
    [self.userName setTitle:[feedData getOwner_Name] forState:UIControlStateNormal];
    
    
    
    [self.userName sizeToFit];
    
    
    //时间
    NSDate* FeedDate=[feedData getUpdateTime];
    
    //NSLog(@"%@",FeedDate);
    
    
    NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    
    //NSLog(@"%@",tempString);
    
    
    
    self.time.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=tempString ;
    [tempString release];
    
    
    
      
}


-(void)setUserHeadImage:(UIImage*)image
{
    /*
     CATransition *animation = [CATransition animation];
     animation.delegate = self;
     animation.duration = 0.3f;
     animation.timingFunction = UIViewAnimationCurveEaseInOut;
     animation.fillMode = kCAFillModeForwards;
     animation.removedOnCompletion = NO;
     [animation setType:@"kCATransitionFade"];
     //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
     [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
     */
    [_headImageView setImage:image];
    
}



@end
