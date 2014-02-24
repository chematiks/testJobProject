//
//  resourse.h
//  testJobProject
//
//  Created by Администратор on 10/14/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface resourse : NSManagedObject// <NSCopying>

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * patronymic;
@property (nonatomic, retain) NSNumber * salary;
@property (nonatomic, retain) NSString * surname;

@end
