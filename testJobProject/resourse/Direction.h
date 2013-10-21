//
//  Direction.h
//  testJobProject
//
//  Created by Администратор on 10/14/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "resourse.h"


@interface Direction : resourse

@property (nonatomic, retain) NSDate * businessHourFinish;
@property (nonatomic, retain) NSDate * businessHourStart;

@end
