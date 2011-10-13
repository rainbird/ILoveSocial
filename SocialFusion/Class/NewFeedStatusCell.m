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
@synthesize time = _Time;


- (void)awakeFromNib
{
    self.defaultHeadImageView.layer.masksToBounds = YES;
    self.defaultHeadImageView.layer.cornerRadius = 5.0f;  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0f; 
   // [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    NSLog(@"Friend List Cell Dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_status release];
   
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
@end
