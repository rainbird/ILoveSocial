//
//  NewFeedDetailViewCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "NewFeedDetailViewCell.h"

@implementation NewFeedDetailViewCell


-(void)initWithFeedData:(NewFeedData*)_feedData  context:(NSManagedObjectContext*)context
{
    detailController.feedData=_feedData;
    detailController.managedObjectContext=context;
    
    
  //  [self.contentView addSubview:detailController.view];
}



- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");

    
    [super dealloc];
}


@end
