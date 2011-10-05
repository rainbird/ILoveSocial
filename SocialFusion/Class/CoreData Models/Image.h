//
//  Image.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageData;

@interface Image : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) ImageData *imageData;

@end
