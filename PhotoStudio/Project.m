//
//  Project.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/6/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize UPID=_UPID;
@synthesize elements=_elements;
@synthesize resultPicture=_resultPicture;
//@synthesize elementsNames=_elementsNames;


+ (Project *)loadProjectWithUPID:(NSString *)uPID
{
    //Create a project
    Project *project=[[Project alloc] init];
    
    // Load from User Defaults
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSData* elementData=[userDefaults objectForKey:[NSString stringWithFormat:@"%@",uPID]];
    
    if (elementData) 
    {
        // Unarchive array
        project=[NSKeyedUnarchiver unarchiveObjectWithData:elementData];
    }
    else {
        NSAssert(NO, @"Error loading from NSUserDefaults", nil);
    }
    return project;    
}

+ (Project *)loadProjectMainInfoWithUPID:(NSString *)uPID
{
    //Load full project
    Project *projectMainInfo=[self loadProjectWithUPID:uPID];
    
    //Maintain only title and resultPicture properties
    projectMainInfo.elements=nil;
    
    return projectMainInfo;
}

- (void)save
{
    // Archive element
    NSData *elementData = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    // Save to User Defaults
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:elementData forKey:[NSString stringWithFormat:@"%@",self.UPID]];
    
    // Syncronize User Defaults
    [userDefaults synchronize]; 
}

#pragma mark - NSCoding Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.UPID=[aDecoder decodeObjectForKey:@"Project.UPID"];
        self.elements=[aDecoder decodeObjectForKey:@"Project.elements"]; //It will be a non-mutable array when created from NSCoding
        
        NSData* pictureData=[aDecoder decodeObjectForKey:@"Project.resultPicture"];
        self.resultPicture=[UIImage imageWithData:pictureData];
        //self.elementsNames=[aDecoder decodeObjectForKey:@"Project.elementsNames"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UPID forKey:@"Project.UPID"];
    [aCoder encodeObject:self.elements forKey:@"Project.elements"];
    
    NSData* pictureData=UIImageJPEGRepresentation(self.resultPicture, 1);
    [aCoder encodeObject:pictureData forKey:@"Project.resultPicture"];      
    //[aCoder encodeObject:self.elementsNames forKey:@"Project.elementsNames"];
}

@end
