//
//  Element.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/4/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "Element.h"

@implementation Element

@synthesize topView=_topView;
@synthesize frontView=_frontView;
@synthesize fileName=_fileName;

#pragma  mark - NSCoding Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.topView=[aDecoder decodeObjectForKey:@"Element.topView"];
        self.frontView=[aDecoder decodeObjectForKey:@"Element.frontView"];
        self.fileName=[aDecoder decodeObjectForKey:@"Element.fileName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.topView forKey:@"Element.topView"];
    [aCoder encodeObject:self.frontView forKey:@"Element.frontView"];
    [aCoder encodeObject:self.fileName forKey:@"Element.fileName"];
}

@end
