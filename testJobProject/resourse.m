//
//  resourse.m
//  testJobProject
//
//  Created by Администратор on 10/14/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "resourse.h"
#import "CLDataBaseDelegate.h"
#import "constants.h"


@implementation resourse

@dynamic category;
@dynamic name;
@dynamic patronymic;
@dynamic salary;
@dynamic surname;
/*
- (id)copyWithZone:(NSZone *)zone;
{
    resourse *copy = [[CLDataBaseDelegate sharedDB]
                               newFetchEntitiesWithClassName:eStaff
                               sortDescriptors:nil
                               sectionNameKeyPath:kCategory
                               predicate:nil];
    copy.surname = self.surname;
    copy.name = self.name;
    copy.patronymic = self.patronymic;
    copy.salary = self.salary;
    copy.category = self.category;
    return copy;
}

*/
@end
