//
//  PPLanguageTableViewCell.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/18/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLanguageTableViewCell.h"

@implementation PPLanguageTableViewCell
@synthesize language, status, level;

#pragma mark -
#pragma mark setup methods

-(void)layoutSubviews
{
    PFUser *currentUser = [PFUser currentUser];
    NSDictionary *languageStatuses = currentUser[@"languageStatuses"];
    NSDictionary *languageLevels = currentUser[@"languageLevels"];
    
    if([languageStatuses objectForKey:language.text])
    {
        status.selectedSegmentIndex = [[languageStatuses objectForKey:language.text]intValue];
        
        if([[languageLevels objectForKey:language.text]intValue] != -1)
        {
            self.level.enabled = YES;
        }
        
        else if(self.status.selectedSegmentIndex == 0 || self.status.selectedSegmentIndex == 1)
        {
            self.level.enabled = YES;
        }
        else
        {
            self.level.enabled = NO;
        }
        
        level.selectedSegmentIndex = [[languageLevels objectForKey:language.text]intValue];
    }
}

#pragma mark -
#pragma mark action methods

-(IBAction)statusChange:(id)sender
{
    if(self.status.selectedSegmentIndex == 0 || self.status.selectedSegmentIndex == 1)
    {
        self.level.enabled = YES;
    }
    
    else
    {
        self.level.enabled = NO;
        self.level.selectedSegmentIndex = -1;
    }
    
    [self saveUserLanguageInformation];
}

-(IBAction)levelChange:(id)sender
{
    [self saveUserLanguageInformation];
}

#pragma mark -
#pragma mark save user information methods

-(void)saveUserLanguageInformation
{
    PFUser *currentUser = [PFUser currentUser];
    NSDictionary *languageStatuses = currentUser[@"languageStatuses"];
    NSDictionary *languageLevels = currentUser[@"languageLevels"];
    
    currentUser[@"languageStatuses"] = languageStatuses;
    currentUser[@"languageLevels"] = languageLevels;
    
    [languageStatuses setValue:[NSNumber numberWithInt:(int)status.selectedSegmentIndex] forKey:language.text];
    [languageLevels setValue:[NSNumber numberWithInt:(int)level.selectedSegmentIndex] forKey:language.text];
    
    [currentUser setObject:languageStatuses forKey:@"languageStatuses"];
    [currentUser setObject:languageLevels forKey:@"languageLevels"];
    [currentUser saveInBackground];
}

@end
