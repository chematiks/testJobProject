//
//  ListViewController.m
//  testJobProject
//
//  Created by Администратор on 10/13/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "ListViewController.h"
#import "CLDataBaseDelegate.h"
#import "CLListTableViewCell.h"
#import "CLDetailListViewController.h"
#import "constants.h"
#import "Worker.h"
#import "Direction.h"
#import "Bookkeeping.h"

@interface ListViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight=rowHeigth;
    
    //init time formatter for action with time
    timeFormat=[[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    //add button to navigation bar
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    
    UIBarButtonItem * addNewButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButtonPress)];
    self.navigationItem.rightBarButtonItem=addNewButton;
    [CLDataBaseDelegate sharedDB];

    [self reloadFetchesResultsController];
    
    //if data==nil then load test data
    if ([[self.fetchedResultsController fetchedObjects] count]==0)
    {
        [self setDefaultDataInListDB];
        [self reloadFetchesResultsController];
    }
}

//new element add
-(void) addNewButtonPress
{
    [[CLDataBaseDelegate sharedDB] voidCurrentObject];
    
    CLDetailListViewController * detailViewController=[[CLDetailListViewController alloc] init];
    [detailViewController initDataInDetailView:nil];

    [[self navigationController] pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

//load test data
-(void) setDefaultDataInListDB
{
    [[CLDataBaseDelegate sharedDB] loadDefaultData];
    [self.tableView reloadData];
}

//init fetch results controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    // Create the sort descriptors array.
    NSSortDescriptor *surnameDescriptor = [[NSSortDescriptor alloc] initWithKey:kCategory ascending:YES];
    NSArray *sortDescriptors = @[surnameDescriptor];
    [surnameDescriptor release];
  
    // Create and initialize the fetch results controller.
    _fetchedResultsController=[[CLDataBaseDelegate sharedDB]
                               newFetchEntitiesWithClassName:eStaff
                               sortDescriptors:sortDescriptors
                               sectionNameKeyPath:kCategory
                               predicate:nil];
    _fetchedResultsController.delegate = self;
  
    return _fetchedResultsController;
}
#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (void)configureCell:(CLListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.fetchedResultsController objectAtIndexPath:indexPath] class]==[Bookkeeping class])
    {
        Bookkeeping * object=[self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.hourLabel.text=[NSString stringWithFormat:@"Обед с %@ по %@",
                             [timeFormat stringFromDate:object.dinnerTimeStart],
                             [timeFormat stringFromDate:object.dinnerTimeFinish]];
        cell.numberWorkPlaceLabel.text=[NSString stringWithFormat:@"Рабочее место № %@",
                                        [object.seatNumber stringValue]];
        cell.typeBookkeepingLabel.text=[NSString stringWithFormat:@"Тип бухгалтера %@",object.typeBookkeeping];
    }
    else
        if ([[self.fetchedResultsController objectAtIndexPath:indexPath] class]==[Direction class])
        {
            Direction * object=[self.fetchedResultsController objectAtIndexPath:indexPath];
            cell.hourLabel.text=[NSString stringWithFormat:@"Прием с %@ по %@",
                                 [timeFormat stringFromDate:object.businessHourStart],
                                 [timeFormat stringFromDate:object.businessHourFinish]];
        }
        else
            if ([[self.fetchedResultsController objectAtIndexPath:indexPath] class]==[Worker class])
            {
                Worker * object=[self.fetchedResultsController objectAtIndexPath:indexPath];
                cell.hourLabel.text=[NSString stringWithFormat:@"Обед с %@ по %@",
                                     [timeFormat stringFromDate:object.dinnerTimeStart],
                                     [timeFormat stringFromDate:object.dinnerTimeFinish]];
                cell.numberWorkPlaceLabel.text=[NSString stringWithFormat:@"Рабочее место № %@",
                                                [object.seatNumber stringValue]];
            }
    [self setBasicField:cell atIndexPath:indexPath];
}

// customize basic element cell
-(void) setBasicField:(CLListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    resourse * object=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.surnameNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",object.surname,object.name,object.patronymic];
    cell.salaryLabel.text=[NSString stringWithFormat:@"З/п = %@",[object.salary stringValue]];
}

// create cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CLListTableViewCell * cell=[[CLListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return [cell autorelease];
}

//heigth section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

//customize section
-(UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView=[[UIView alloc] init];
    headerView.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    headerView.frame=CGRectMake(0, 0, 320, 50);
    
    UIImageView * imageViewHeader=[[UIImageView alloc] init];
    imageViewHeader.frame=CGRectMake(1, 1, 48, 48);
    
    UILabel * headerTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(62, 0, 200, 50)];
    headerTitleLabel.font=[UIFont systemFontOfSize:24];
    headerTitleLabel.textColor=[UIColor blackColor];
    NSString * imageName;
    NSString * curSection=[[[self.fetchedResultsController sections] objectAtIndex:section] name];
    if ([curSection isEqualToString:eDirection])
    {
        imageName=@"direction.png";
        headerTitleLabel.text=@"Direction";
    }
    else
        if ([curSection isEqualToString:eWorker])
        {
            imageName=@"worker.png";
            headerTitleLabel.text=@"Worker";
        }
        else
        {
            imageName=@"bookkeeping.png";
            imageViewHeader.frame=CGRectMake(0, 0, 50, 50);
            headerTitleLabel.text=@"Bookkeeping";
        }
    UIImage * imageHeader=[UIImage imageNamed:imageName];
    imageViewHeader.image=imageHeader;
    [headerView addSubview:imageViewHeader];
    [headerView addSubview:headerTitleLabel];
    [imageViewHeader release];
    [headerTitleLabel release];
    return [headerView autorelease];
    return nil;
}

//deselect row
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self reloadFetchesResultsController];
    
}

//if press on row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLDetailListViewController * detailViewController=[[CLDetailListViewController alloc] init];
    [[CLDataBaseDelegate sharedDB] setCurrentObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
    [detailViewController initDataInDetailView:[_fetchedResultsController objectAtIndexPath:indexPath]];
    [[self navigationController] pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

//init editing style
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing == YES)
    {
        // Delete the managed object
        [[CLDataBaseDelegate sharedDB] setCurrentObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [[CLDataBaseDelegate sharedDB] deleteEntity:[[CLDataBaseDelegate sharedDB] getCurrentObject]];
        [[CLDataBaseDelegate sharedDB] saveDataInManagedContext];
        [self reloadFetchesResultsController];
    }

}

//reload fetches results controller and reload tableview
-(void) reloadFetchesResultsController
{
    NSError *error=nil;
    [self.fetchedResultsController performFetch:&error];
    if (error)
        NSLog(@"Unresolved error %@",error.description);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
