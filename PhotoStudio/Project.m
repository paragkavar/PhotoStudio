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
//@synthesize elementsNames=_elementsNames;

#pragma mark - NSCoding Methods -

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.UPID=[aDecoder decodeObjectForKey:@"Project.UPID"];
        self.elements=[aDecoder decodeObjectForKey:@"Project.elements"];
        //self.elementsNames=[aDecoder decodeObjectForKey:@"Project.elementsNames"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UPID forKey:@"Project.UPID"];
    [aCoder encodeObject:self.elements forKey:@"Project.elements"];
    //[aCoder encodeObject:self.elementsNames forKey:@"Project.elementsNames"];
}

@end
