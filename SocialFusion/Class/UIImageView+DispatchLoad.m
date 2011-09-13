//
//  UIImageView+DispatchLoad.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"

@implementation UIImageView (DispatchLoad)
- (void)setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:NULL];
}
- (void)setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //NSLog(@"Starting: %@", urlString);
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        //NSLog(@"Finishing: %@", urlString);
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = avatarImage;
            });
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            NSLog(@"-- impossible download: %@", urlString);
        }
    });   
}
@end
