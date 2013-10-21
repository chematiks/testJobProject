//
//  Worker.h
//  testJobProject
//
//  Created by Администратор on 10/14/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "resourse.h"


@interface Worker : resourse

@property (nonatomic, retain) NSDate * dinnerTimeFinish;
@property (nonatomic, retain) NSDate * dinnerTimeStart;
@property (nonatomic, retain) NSNumber * seatNumber;

@end
