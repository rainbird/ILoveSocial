//
//  ImageData.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageData : NSManagedObject {
@private
}
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSManagedObject *owner;

@end
