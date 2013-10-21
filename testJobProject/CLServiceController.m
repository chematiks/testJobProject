//
//  CLServiceController.m
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLServiceController.h"
#import "CLBashData.h"
#import "DDXML.h"

@interface CLServiceController ()

@end

@implementation CLServiceController

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

//show data and trobber off
-(void) showText
{
   NSString * text=self.textView.text;
     for (CLBashData * printNote in self.arrayNote) {
        if (printNote.dateNote)
            text=[text stringByAppendingString:printNote.dateNote];
         
         if (printNote.idNote) {
             text=[text stringByAppendingString:@"                          # "];
             text=[text stringByAppendingString:printNote.idNote];
         }
            text=[text stringByAppendingString:@"\n"];
         
        if (printNote.textNote)
            text=[text stringByAppendingString:printNote.textNote];
            text=[text stringByAppendingString:@"\n\n"];
            text=[text stringByAppendingString:@"===================================\n"];
    }
    
    [self.trobber stopAnimating];
    
    self.textView.text=text;
}

//load data in backround
-(void) backgroundThread
{
    [self loadDataXml];
    
    [self performSelectorOnMainThread:@selector(showText) withObject:nil waitUntilDone:YES];
}

//include trobber and start load data
- (void)viewDidLoad
{
    [super viewDidLoad];
    float screenHeigth=[[UIScreen mainScreen]bounds].size.height;
    if (screenHeigth>480){
        CGRect rect=self.textView.frame;
        rect.size.height=538;
        self.textView.frame=rect;
    }
    
    self.textView.text=[NSString stringWithFormat:@"      "];
    
    [self.trobber startAnimating];
    
    [self performSelectorInBackground:@selector(backgroundThread) withObject:nil];
}

-(void) dealloc
{
    [_textView release];
    [_trobber release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
