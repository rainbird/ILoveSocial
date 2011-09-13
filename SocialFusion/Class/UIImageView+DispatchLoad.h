//
//  UIImageView+DispatchLoad.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (DispatchLoad)
- (void)setImageFromUrl:(NSString*)urlString;
- (void)setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion;

@end
