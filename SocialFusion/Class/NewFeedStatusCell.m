//
//  NewFeedStatusCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h"
#import "NewFeedBlog.h"
@implementation NewFeedStatusCell

@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;
@synthesize status = _status;
@synthesize time = _time;
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


+(float)heightForCell:(NewFeedData*)feedData
{
    
    
    if ([feedData class]==[NewFeedData class] )
    {
        if ([feedData getPostName]==nil)
        {
            NSString* tempString=[feedData getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                      constrainedToSize:size];
            
            if (labelSize.height<50)
            {
                return 70;
            }
            
            return labelSize.height+20;
        }
        else
        {
            NSString* tempString=[feedData getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                      constrainedToSize:size];
            
            
            NSString* tempString1=[feedData getPostMessage];
            CGSize size1 = CGSizeMake(200, 1000);
            CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Courier New" size:12]
                                        constrainedToSize:size1];
            return labelSize.height+labelSize1.height+50;
        }
    }
    else if ([feedData class]==[NewFeedBlog class] )
    {
        NSString* tempString=[feedData getName];
        CGSize size = CGSizeMake(212, 1000);
        CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                  constrainedToSize:size];
        
        
        NSString* tempString1=[feedData getBlog];
        CGSize size1 = CGSizeMake(212, 1000);
        CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Courier New" size:12]
                                    constrainedToSize:size1];
        return labelSize.height+labelSize1.height+30;
        
        
    }
    return 0;
    
    
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _buttonViewShowed=NO;
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

/* 这里的问题需要解决
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (_buttonViewShowed==NO)
    {

    UITouch* touch=[touches anyObject];
    _beginPoint=[touch locationInView:self];
        
     //   [super touchesBegan:touches withEvent:event];
    }    

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
   // [self setSelected:YES];
    
    if (_buttonViewShowed==NO)
    {
    UITouch* touch=[touches anyObject];
    CGPoint tempPoint=[touch locationInView:self];

    if (tempPoint.y-_beginPoint.y<100)
    {
        if (tempPoint.x-_beginPoint.x>30)
        {
            
            NSLog(@"Moved");
            
            [self setSelected:NO];
            _buttonView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
          
            
            
             CATransition *animation = [CATransition animation];
             animation.delegate = self;
             animation.duration = 0.2f;
             animation.timingFunction = UIViewAnimationCurveEaseInOut;
             animation.fillMode = kCAFillModeForwards;
             animation.removedOnCompletion = NO;
            [animation setType:@"kCATransitionFade"];
         //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
            [self.layer addAnimation:animation forKey:@"animationID"]; 

            
            [self addSubview:_buttonView];
            _buttonViewShowed=YES;
        }
    }
    
    }
     
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"selected:%d", selected);
    self.userName.highlighted = selected;

}

-(IBAction) cancelButton:(id)sender
{
    
    _buttonView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setType:@"kCATransitionFade"];
    //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
    [self.layer addAnimation:animation forKey:@"animationID"]; 
    
    
    [_buttonView removeFromSuperview];
    _buttonViewShowed=NO;
}
-(NewFeedRootData*) getFeedData
{
    return _feedData;
}
-(void)configureCell:(NewFeedData*)feedData
{
    
    _feedData=feedData;
    //  修改人人／weibo小标签
    
    if ([feedData getStyle]==0)
    {
        [_styleView setImage:[UIImage imageNamed:@"Renren12.png"]];
    }
    else
    {
        [_styleView setImage:[UIImage imageNamed:@"Weibo12.png"]];
    }
    //头像
        [self.headImageView setImage:nil];
   
    
    //状态
    self.status.text=[feedData getName];
    
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
    [self.userName setTitle:[feedData getFeedName] forState:UIControlStateNormal];
    
   
    
      [self.userName sizeToFit];
    

        //时间
    NSDate* FeedDate=[feedData getDate];
    
    //NSLog(@"%@",FeedDate);

    
    NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    
    //NSLog(@"%@",tempString);
    
    

    self.time.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
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
