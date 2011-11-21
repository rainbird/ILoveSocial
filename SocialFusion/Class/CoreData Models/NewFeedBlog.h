//
//  NewFeedBlog.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedBlog : NewFeedRootData

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * mydescription;

@end
