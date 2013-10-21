//
//  CLDataBaseDelegate.h
//  testJobProject
//
//  Created by Администратор on 10/13/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CLDataBaseDelegate : NSObject
{
    NSIndexPath * currentObject;
    NSManagedObject * curObject;
}


+(CLDataBaseDelegate *) sharedDB;

-(void) saveDataInManagedContext;

-(void) setCurrentObject:(NSManagedObject *) obj;

-(void) voidCurrentObject;

-(NSManagedObject *) getCurrentObject;

-(NSFetchedResultsController *) newFetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *) sortDescriptors
                                        sectionNameKeyPath:(NSString *) sectionNameKeyPath
                                                 predicate:(NSPredicate *) predicate;

-(id) createEntytiWithClassName:(NSString *) className
           attributesDictionary:(NSDictionary *) attributesDictionary;

-(void) deleteEntity:(NSManagedObject *) entity;

-(void) loadDefaultData;

@end
