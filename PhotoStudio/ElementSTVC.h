//
//  ElementSTVC.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/5/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"

@class ElementSTVC;

@protocol ElementSTVCDelegate

-(void)elementDidSelect:(Element*)element;

@end

@interface ElementSTVC : UITableViewController

@property (nonatomic, weak) id <ElementSTVCDelegate> delegate;
@property (nonatomic, strong) NSString *groupAndName;

@end
