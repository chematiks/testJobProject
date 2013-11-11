//
//  CLServiceViewController.m
//  testJobProject
//
//  Created by Admin on 06.11.13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLServiceViewController.h"
#import "CLBashData.h"
#import "DDXML.h"
#import "CLServiceCell.h"

#define statusBarHeight 20
#define tabBarHeigth 49
#define screen [[UIScreen mainScreen]bounds].size

@interface CLServiceViewController ()

@end

@implementation CLServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIActivityIndicatorView * trob=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.trobber=trob;
        [trob release];
        [self.trobber setHidesWhenStopped:YES];
        CGRect rect=self.trobber.frame;
        rect.origin.x=(screen.width-rect.size.width)/2;
        rect.origin.y=(screen.height-rect.size.height)/2;
        self.trobber.frame=rect;
        UITableView * table=[[UITableView alloc] initWithFrame:
                        CGRectMake(0, statusBarHeight, screen.width, screen.height-statusBarHeight-tabBarHeigth)];
        self.tableView=table;
        [table release];
        self.tableView.dataSource=self;
        self.tableView.delegate=self;
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.trobber];
       
        [self.trobber startAnimating];

        // Custom initialization
    }
    return self;
}

//load and parse data on URL
-(void) loadDataXml
{
    self.arrayNote =[NSMutableArray array];
    NSString * stringURL=@"http://bash.zennexgroup.com/service/ru/get.php?type=last";
    NSURL * url=[[NSURL alloc] initWithString:stringURL];
    NSData * dataXML=[[NSData alloc] initWithContentsOfURL:url];
    [url release];
    NSError * error;
    DDXMLDocument * doc1=[[DDXMLDocument alloc] initWithData:dataXML options:0 error:&error];
    if (error)
    {
        NSLog(@"ERROR!!! %@",[error localizedDescription]);
    }
    [error release];
    NSArray * elem1=[doc1 children];
    NSArray * elem2=[[elem1 objectAtIndex:0]children];
    NSArray * elem3=[[elem2 objectAtIndex:1]children];
    for (DDXMLElement * currentObjectRead in elem3)
    {
        CLBashData * currentObjectWrite=[[CLBashData alloc]init];
        
        currentObjectWrite.idNote=[self getNoteIn:currentObjectRead withElementName:@"id"];
        currentObjectWrite.dateNote=[self getNoteIn:currentObjectRead withElementName:@"date"];
        currentObjectWrite.textNote=[self getNoteIn:currentObjectRead withElementName:@"text"];
        
        [self.arrayNote addObject:currentObjectWrite];
        [currentObjectWrite release];
    }
    
    [doc1 release];
    [dataXML release];
}

-(NSString *) getNoteIn:(DDXMLElement *)element withElementName:(NSString *)elementName
{
    NSArray * arrayWithNote=[element elementsForName:elementName];
    NSString * nodeString=[[[NSString alloc]init] autorelease];
    for (DDXMLNode * node in arrayWithNote)
    {
        nodeString=[nodeString stringByAppendingString:[node stringValue]];
    }
    return nodeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.trobber startAnimating];
    
    [self performSelectorInBackground:@selector(backgroundThread) withObject:nil];
	// Do any additional setup after loading the view.
}

//load data in backround
-(void) backgroundThread
{
    [self loadDataXml];
    
    [self performSelectorOnMainThread:@selector(showText) withObject:nil waitUntilDone:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculationHeightCell:indexPath]+2*2+10;
}

-(int) calculationHeightCell:(NSIndexPath *) indexPath
{
    UITextView * textViewInCell=[[UITextView alloc] initWithFrame:CGRectMake(10, 8, 300, 100)];
    CLBashData * bash=[self.arrayNote objectAtIndex:indexPath.row];
    textViewInCell.text=bash.textNote;
    
    CGFloat fixedWidth=textViewInCell.frame.size.width;
    CGSize newSize=[textViewInCell sizeThatFits:CGSizeMake(fixedWidth, 100)];
    CGRect newframe=textViewInCell.frame;
    newframe.size=CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textViewInCell.frame=newframe;
    float result=textViewInCell.frame.size.height+20;
    [textViewInCell release];
    return result;
}

-(void) makeBackgroundCell:(CLServiceCell *) cell indexPath:(NSIndexPath *)indexPath
{
    UIImage *imageBackground;
    UIImage * resizebleBackgroundImage;
    if (indexPath.row%2==1){
        imageBackground=[UIImage imageNamed:@"grayMessage.png"];
        resizebleBackgroundImage=[imageBackground  resizableImageWithCapInsets:UIEdgeInsetsMake(35, 57, 35, 46)];
    }else{
        imageBackground=[UIImage imageNamed:@"blueMessage.png"];
        resizebleBackgroundImage=[imageBackground  resizableImageWithCapInsets:UIEdgeInsetsMake(35, 46, 35, 57)];
    }
    UIImageView * backgroundImageView=[[UIImageView alloc] initWithImage:resizebleBackgroundImage];
    CGRect rect=CGRectMake(0, 2+10, cell.frame.size.width, [self calculationHeightCell:indexPath]);
    backgroundImageView.frame=rect;

    [cell addSubview:backgroundImageView];
    [cell sendSubviewToBack:backgroundImageView];
    [backgroundImageView release];
}

//show data and trobber off
-(void) showText
{
    [self.trobber stopAnimating];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayNote count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CLServiceCell * cell=[[CLServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    CLBashData * bash=[self.arrayNote objectAtIndex:indexPath.row];

    cell.numberLabel.text=[NSString stringWithFormat:@"#%@",bash.idNote];
    cell.dateLabel.text=bash.dateNote;
    
    UITextView * textViewInCell=[[UITextView alloc] initWithFrame:CGRectMake(10, 8+10, 300, 100)];
    textViewInCell.text=bash.textNote;

    [cell addSubview:textViewInCell];
    [textViewInCell release];
    cell.textView=textViewInCell;
  
    CGFloat fixedWidth=textViewInCell.frame.size.width;
    CGSize newSize=[textViewInCell sizeThatFits:CGSizeMake(fixedWidth, 100)];
    CGRect newframe=textViewInCell.frame;
    newframe.size=CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textViewInCell.frame=newframe;
    
    [self makeBackgroundCell:cell indexPath:indexPath];

    textViewInCell.backgroundColor=[UIColor clearColor];
    textViewInCell.scrollEnabled=NO;
    return [cell autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
