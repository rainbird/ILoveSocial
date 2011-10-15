//
//  NewFeedStatusCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusCell.h"
#import <QuartzCore/QuartzCore.h>

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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_buttonViewShowed==NO)
    {

    UITouch* touch=[touches anyObject];
    _beginPoint=[touch locationInView:self];
    }    

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_buttonViewShowed==NO)
    {
    UITouch* touch=[touches anyObject];
    CGPoint tempPoint=[touch locationInView:self];

    if (tempPoint.y-_beginPoint.y<100)
    {
        if (tempPoint.x-_beginPoint.x>100)
        {
            
            NSLog(@"Moved");
            
            _buttonView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
          
            
            
             CATransition *animation = [CATransition animation];
             animation.delegate = self;
             animation.duration = 0.5f;
             animation.timingFunction = UIViewAnimationCurveEaseInOut;
             animation.fillMode = kCAFillModeForwards;
             animation.removedOnCompletion = NO;
            [animation setType:@"kCATransitionFade"];
         //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 

            
            [self addSubview:_buttonView];
            _buttonViewShowed=YES;
        }
    }
    }
}
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
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setType:@"kCATransitionFade"];
    //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
    
    
    [_buttonView removeFromSuperview];
    _buttonViewShowed=NO;
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
    
    self.time.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=tempString ;
    [tempString release];

    

    [self.userName sizeToFit];
    
 
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
