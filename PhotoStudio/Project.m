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
@synthesize title=_title;
@synthesize author=_author;
@synthesize creationDate=_creationDate;
@synthesize details=_details;

//It will set UPID, creationDate and init the elements array
- (id)init
{
    if (self=[super init]) {
        
        //Init elements array (VERY IMPORTANT)
        self.elements=[NSMutableArray arrayWithCapacity:1];
        
        //Generate random string of 10 that will be the UPID to store this project
        int randomStringLength=10;
        NSString *chars = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        NSMutableString *randomString = [NSMutableString stringWithCapacity:randomStringLength];
        srand(time(NULL));
        for (int i=0; i<randomStringLength; i++) {
            [randomString appendFormat:@"%c",[chars characterAtIndex:rand()%[chars length]]];
        }
        
        //Set UPID
        self.UPID=randomString;  
        
        //Get current date and time
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        
        //Set crationDate
        self.creationDate=[NSString stringWithFormat:@"%@  %@",[dateFormatter stringFromDate:[NSDate date]],[timeFormatter stringFromDate:[NSDate date]]];        
    }
    return self;
}

- (id)initWithTitle:(NSString *)title author:(NSString *)author
{
    if (self=[self init]) {
        self.title=title;
        self.author=author;
    }
    return self;
}


- (id)initForDefaultProject
{
    if (self=[self initWithTitle:@"Default Project" author:@"Ikokoro Dreams"]) {
        self.resultPicture=[UIImage imageNamed:@"default image.jpg"];
        self.details=@"This is the default project created by the app";
    }
    return self;
}


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

#pragma mark - NSCoding Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.UPID=[aDecoder decodeObjectForKey:@"Project.UPID"];
        self.elements=[aDecoder decodeObjectForKey:@"Project.elements"]; //It will be a non-mutable array when created from NSCoding
        
        NSData* pictureData=[aDecoder decodeObjectForKey:@"Project.resultPicture"];
        self.resultPicture=[UIImage imageWithData:pictureData];
        
        self.title=[aDecoder decodeObjectForKey:@"Project.title"];
        self.author=[aDecoder decodeObjectForKey:@"Project.author"];
        self.creationDate=[aDecoder decodeObjectForKey:@"Project.creationDate"];
        self.details=[aDecoder decodeObjectForKey:@"Project.details"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UPID forKey:@"Project.UPID"];
    [aCoder encodeObject:self.elements forKey:@"Project.elements"];
    
    NSData* pictureData=UIImageJPEGRepresentation(self.resultPicture, 1);
    [aCoder encodeObject:pictureData forKey:@"Project.resultPicture"];
    
    [aCoder encodeObject:self.title forKey:@"Project.title"];
    [aCoder encodeObject:self.author forKey:@"Project.author"];
    [aCoder encodeObject:self.creationDate forKey:@"Project.creationDate"];
    [aCoder encodeObject:self.details forKey:@"Project.details"];
}

@end
