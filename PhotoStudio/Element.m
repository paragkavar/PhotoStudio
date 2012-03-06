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
    if (self=[super init]) 
    {
        //The problem here is that we cannot subclass a UIImageView because I don't know how to override drawRect. Then the solution adopted is to subclass a UIView (ElementView class) and add a @property of type UIImageView. By doing that we have to manually add this UIImageView as a subview of the ElementView class (subclass of UIView).
        
        self.topView=[aDecoder decodeObjectForKey:@"Element.topView"];
        self.frontView=[aDecoder decodeObjectForKey:@"Element.frontView"];
        self.fileName=[aDecoder decodeObjectForKey:@"Element.fileName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //topView
    [aCoder encodeObject:self.topView forKey:@"Element.topView"];
    
    //FrontView
    [aCoder encodeObject:self.frontView forKey:@"Element.frontView"];
    
    //fileName
    [aCoder encodeObject:self.fileName forKey:@"Element.fileName"];
}

@end
