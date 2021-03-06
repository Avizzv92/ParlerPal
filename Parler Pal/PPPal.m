
//
//  PPPal.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 7/6/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPPal.h"

@implementation PPPal
@synthesize username, country, profile, age, gender, dbID, languages, created, recommendationScore;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        self.dbID = [[dictionary objectForKey:@"id"]intValue];
        self.username = [dictionary objectForKey:@"username"];
        self.country = [dictionary objectForKey:@"country"];
        self.profile = [dictionary objectForKey:@"profile"];
        self.age = [[dictionary objectForKey:@"age"]intValue];
        self.gender = [[dictionary objectForKey:@"gender"]intValue];
        self.languages = [dictionary objectForKey:@"languages"];
        self.recommendationScore = [dictionary objectForKey:@"recommendationScore"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [df setTimeZone:gmt];
        NSDate *theDate = [df dateFromString:[dictionary objectForKey:@"created"]];
        
        self.created = theDate;
    }
    
    return self;
}

@end
