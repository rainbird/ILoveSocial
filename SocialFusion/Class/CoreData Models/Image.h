//
//  Image.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-27.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject {
@private
}
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * url;

@end
