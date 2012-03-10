//
//  LabelElement.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/9/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ElementView.h"

@interface LabelElement : ElementView <NSCoding,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *labelText;

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text;

@end
