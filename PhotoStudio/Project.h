//
//  Project.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/6/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCoding>

@property (nonatomic, strong) NSString *UPID;
@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) UIImage *resultPicture;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) NSString *details;


- (id)initWithTitle:(NSString *)title author:(NSString *)author;
- (id)initForDefaultProject;
- (void)save;
+ (Project *)loadProjectWithUPID:(NSString *)uPID;

@end
