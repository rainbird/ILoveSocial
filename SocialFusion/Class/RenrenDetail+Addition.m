//
//  RenrenDetail+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "RenrenDetail+Addition.h"

@implementation RenrenDetail (Addition)

+ (RenrenDetail *)insertDetailInformation:(NSDictionary *)dict userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    RenrenDetail *result = [RenrenDetail detailWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenDetail" inManagedObjectContext:context];
    }
    
    result.ownerID = userID;
    
    NSString *sex = [dict objectForKey:@"sex"];
    if(sex) {
        bool isMan = [sex boolValue];
        if(isMan)
            result.gender = [NSString stringWithString:@"男"];
        else
            result.gender = [NSString stringWithString:@"女"];
    }
    result.birthday = [dict objectForKey:@"birthday"];
    result.headURL = [dict objectForKey:@"headurl"];
    result.mainURL = [dict objectForKey:@"mainurl"];
    
    NSDictionary *hometown = [dict objectForKey:@"hometown_location"];
    NSString *province = [hometown objectForKey:@"province"];
    NSString *city = [hometown objectForKey:@"city"];
    NSString *hometownLocation = [NSString stringWithFormat:@"%@ %@", province, city];
    result.hometownLocation = hometownLocation;
    
    NSDictionary *university = [[dict objectForKey:@"university_history"] lastObject];
    if(university) {
        NSString *department = [university objectForKey:@"department"];
        NSString *name = [university objectForKey:@"name"];
        NSString *year = [university objectForKey:@"year"];
        NSString *universityInfo = [NSString stringWithFormat:@"%@, %@, %@", name, department, year];
        result.universityHistory = universityInfo;
    }
    return result;
}

+ (RenrenDetail *)detailWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenDetail" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ownerID == %@", userID]];
    
    RenrenDetail *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

@end
