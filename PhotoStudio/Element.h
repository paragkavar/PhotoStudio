//
//  Element.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/4/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElementView.h"

@interface Element : NSObject <NSCoding>

@property (nonatomic, strong) ElementView *topView;
@property (nonatomic, strong) ElementView *frontView;

@property (nonatomic, strong) NSString *fileName;

@end
