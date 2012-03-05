//
//  ElementsTableViewController.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/4/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"



@interface ElementsTableViewController : UITableViewController

@property (nonatomic, strong) NSString* group;
@property (nonatomic, strong) NSArray* elements;
@property (nonatomic, weak) id mainViewController;

@end
