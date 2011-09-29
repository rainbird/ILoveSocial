//
//  UIImageView+DispatchLoad.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"
#import "Image+Addition.h"

@implementation UIImageView (DispatchLoad)

- (void)setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:nil];
}

- (void)setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion {
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{
        
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = avatarImage;
                if (completion) {
                    completion();
                }	
            });
        }
        else {
            NSLog(@"download failed: %@", urlString);
        }
    });   
    dispatch_release(downloadQueue);
}

- (void)loadImageFromURL:(NSString *)urlString 
              completion:(void (^)())completion 
          cacheInContext:(NSManagedObjectContext *)context
{
	
	self.backgroundColor = [UIColor clearColor];
    
    Image *imageObject = [Image imageWithURL:urlString inManagedObjectContext:context];
    if (imageObject) {
        NSData *imageData = imageObject.data;
        UIImage *img = [UIImage imageWithData:imageData];
        self.image = img;
        if (completion) {
            completion();
        }
        return;
    }
	
    NSURL *url = [NSURL URLWithString:urlString];    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{ 
        //NSLog(@"download image:%@", urlString);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if(!imageData) {
            NSLog(@"download image failed:%@", urlString);
            return;
        }
        UIImage *img = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([Image imageWithURL:urlString inManagedObjectContext:context] == nil) {
                [Image insertImage:imageData withURL:urlString inManagedObjectContext:context];
                //NSLog(@"cache image url:%@", urlString);
                self.image = img;
                if (completion) {
                    completion();
                }			
            }
        });
    });
    dispatch_release(downloadQueue);
}

@end
