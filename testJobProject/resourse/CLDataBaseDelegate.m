//
//  CLDataBaseDelegate.m
//  testJobProject
//
//  Created by Администратор on 10/13/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLDataBaseDelegate.h"
#import <CoreData/CoreData.h>
#import "constants.h"
#import "Worker.h"
#import "Direction.h"
#import "Bookkeeping.h"


@interface CLDataBaseDelegate()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void) setupManagedObjectContext;

@end

@implementation CLDataBaseDelegate

static CLDataBaseDelegate * dataBaseDelegate;

//singleton for work database
+(CLDataBaseDelegate *) sharedDB
{
    if (!dataBaseDelegate)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            dataBaseDelegate=[[CLDataBaseDelegate alloc] init];
        });
    }
    return dataBaseDelegate;
}

-(id) init
{
    self=[super init];
    currentObject=[[NSIndexPath alloc] init];
    if (self)
    {
        [self setupManagedObjectContext];
    }
    return self;
}

-(void) setupManagedObjectContext
{
    NSURL * persistensURL=[[self applicationsDocumentsDirectory] URLByAppendingPathComponent:@"listDB.sqlite"];
    NSURL * modelURL=[[NSBundle mainBundle] URLForResource:@"listDB" withExtension:@"momd"];
    NSManagedObjectModel * managedObjectMod=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.managedObjectModel=managedObjectMod;
    [managedObjectMod release];
    NSPersistentStoreCoordinator * persistentStoreCoord=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.persistentStoreCoordinator=persistentStoreCoord;
    [persistentStoreCoord release];
    NSError * error=nil;
    NSPersistentStore * persistentStore=[self.persistentStoreCoordinator
                                         addPersistentStoreWithType:NSSQLiteStoreType
                                         configuration:nil
                                         URL:persistensURL
                                         options:nil
                                         error:&error];
    if (persistentStore)
    {
        NSManagedObjectContext * managedObjectCont=[[NSManagedObjectContext alloc] init];
        self.managedObjectContext=managedObjectCont;
        [managedObjectCont release];
        self.managedObjectContext.persistentStoreCoordinator=self.persistentStoreCoordinator;
    }
    else
    {
        NSLog(@"ERROR: %@",error.description);
    }
    [error release];
}
    
-(NSURL *) applicationsDocumentsDirectory
{
   return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSFetchedResultsController *) newFetchEntitiesWithClassName:(NSString *)className sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)sectionNameKeyPath predicate:(NSPredicate *)predicate
{
    NSFetchedResultsController * fetchResultController;
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription * entity=[NSEntityDescription entityForName:className inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity=entity;
    fetchRequest.sortDescriptors=sortDescriptors;
    fetchRequest.predicate=predicate;
    fetchResultController=[[NSFetchedResultsController alloc]
                           initWithFetchRequest:fetchRequest
                           managedObjectContext:self.managedObjectContext
                             sectionNameKeyPath:sectionNameKeyPath
                                      cacheName:nil];
    [fetchRequest release];
    NSError * error=nil;
    BOOL success=[fetchResultController performFetch:&error];
    
    if(!success)
    {
        NSLog(@"fetchManagedObjectsWithClassName ERROR: %@",error.description);
        abort();
    }
    
    return fetchResultController;
}

-(id) createEntytiWithClassName:(NSString *)className attributesDictionary:(NSDictionary *)attributesDictionary
{
    NSManagedObject * entity=[NSEntityDescription
                              insertNewObjectForEntityForName:className
                                       inManagedObjectContext:self.managedObjectContext];
    [attributesDictionary enumerateKeysAndObjectsUsingBlock:
     ^(NSString * key,id obj,BOOL * stop){[entity setValue:obj forKey:key];}];
    
    return entity;
}

-(void) deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

-(void) loadDefaultData
{
    NSDateFormatter * timeFormat=[[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    Worker *newWorker1 = (Worker *)[NSEntityDescription insertNewObjectForEntityForName:eWorker inManagedObjectContext:self.managedObjectContext];
    newWorker1.category=eWorker;
    newWorker1.surname=@"Иванов";
    newWorker1.name=@"Иван";
    newWorker1.patronymic=@"Иванович";
    newWorker1.salary=[NSNumber numberWithInt:20000];
    newWorker1.seatNumber=[NSNumber numberWithInt:5];
    newWorker1.dinnerTimeStart=[timeFormat dateFromString:@"12:00"];
    newWorker1.dinnerTimeFinish=[timeFormat dateFromString:@"13:00"];
   
    Worker *newWorker2 = (Worker *)[NSEntityDescription insertNewObjectForEntityForName:eWorker inManagedObjectContext:self.managedObjectContext];
    newWorker2.category=eWorker;
    newWorker2.surname=@"Петров";
    newWorker2.name=@"Петр";
    newWorker2.patronymic=@"Петрович";
    newWorker2.salary=[NSNumber numberWithInt:22000];
    newWorker2.seatNumber=[NSNumber numberWithInt:4];
    newWorker2.dinnerTimeStart=[timeFormat dateFromString:@"12:15"];
    newWorker2.dinnerTimeFinish=[timeFormat dateFromString:@"13:15"];
    
    Direction *newDirection = (Direction *)[NSEntityDescription insertNewObjectForEntityForName:eDirection inManagedObjectContext:self.managedObjectContext];
    newDirection.category=eDirection;
    newDirection.surname=@"Сидоров";
    newDirection.name=@"Сидор";
    newDirection.patronymic=@"Сидорович";
    newDirection.salary=[NSNumber numberWithInt:30000];
    newDirection.businessHourFinish=[timeFormat dateFromString:@"18:00"];
    newDirection.businessHourStart=[timeFormat dateFromString:@"09:00"];
    
    Bookkeeping *newBookkeeper = (Bookkeeping *)[NSEntityDescription insertNewObjectForEntityForName:eBookkeepping inManagedObjectContext:self.managedObjectContext];
    newBookkeeper.category=eBookkeepping;
    newBookkeeper.surname=@"Корейко";
    newBookkeeper.name=@"Александр";
    newBookkeeper.patronymic=@"Петрович";
    newBookkeeper.salary=[NSNumber numberWithInt:18000];
    newBookkeeper.seatNumber=[NSNumber numberWithInt:2];
    newBookkeeper.dinnerTimeStart=[timeFormat dateFromString:@"12:15"];
    newBookkeeper.dinnerTimeFinish=[timeFormat dateFromString:@"12:45"];
    newBookkeeper.typeBookkeeping=@"тип №1";
    
    [timeFormat release];
}

-(void) saveDataInManagedContext
{
    NSError * error=nil;
    [self.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"ERROR save context %@",error.description);
    }
}

-(void) setCurrentObject:(id) obj
{
    curObject=obj;
}

-(NSManagedObject *) getCurrentObject
{
    return curObject;
}

-(void) voidCurrentObject
{
    curObject=nil;
}

@end
