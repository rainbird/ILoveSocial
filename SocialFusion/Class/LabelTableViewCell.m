//
//  LabelTableViewCell.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelTableViewCell.h"

@implementation LabelTableViewCell
@synthesize labelName = _labelName;
@synthesize highlightLabelImage = _highlightLabelImage;

- (void)awakeFromNib
{
    NSLog(@"LabelTableViewCell awakeFromNib");
    self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
}

- (void)dealloc {
    [_labelName release];
    [_highlightLabelImage release];
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted == NO && self.selected == YES)
        return;
    self.labelName.highlighted = highlighted;
    self.imageView.highlighted = highlighted;
}   

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.labelName.highlighted = selected;
    self.imageView.highlighted = selected;
}

@end
