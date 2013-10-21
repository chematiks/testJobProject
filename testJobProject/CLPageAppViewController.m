//
//  CLPageAppViewController.m
//  testJobProject
//
//  Created by Администратор on 9/24/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLPageAppViewController.h"
#import "CLGalleryController.h"

@interface CLPageAppViewController ()

@end

@implementation CLPageAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chapterText=[[NSMutableArray alloc]init];
    self.imageArray=[[NSMutableArray alloc]init];
    for (int i=0; i<15; i++) {
        [self.imageArray addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        [self.chapterText addObject:[NSString stringWithFormat:@"stranica %d",i]];
    }
    
    NSDictionary * option=[NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController=[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    [self.pageViewController setDataSource:self];
    self.indexCurrent=0;
    CLGalleryController * initialClGC=[self viewControllerAtIndex:self.indexCurrent];
    
    NSArray * viewControllers=[NSArray arrayWithObjects:initialClGC, nil];
    [initialClGC release];
    [[self pageViewController]setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.pageViewController.view setFrame:self.view.bounds];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGRect pageViewRect=self.view.bounds;
    pageViewRect=CGRectInset(pageViewRect, 0, 20);
    self.pageViewController.view.frame=pageViewRect;
    
    self.view.gestureRecognizers=self.pageViewController.gestureRecognizers;
}

-(CLGalleryController *) viewControllerAtIndex:( NSUInteger) index
{
    if (index > self.chapterText.count -1){
        return nil;
    }
    self.indexCurrent=index;
    CLGalleryController * clGC=[[CLGalleryController alloc]init];
    [clGC setDataObject:[self.chapterText objectAtIndex:index]];
    [clGC setImageObject:[UIImage imageNamed:[self.imageArray objectAtIndex:index]]];
    return [clGC autorelease];
}

-(NSUInteger) indexOfViewController: (CLGalleryController *) viewController
{
    NSUInteger indexView=[self.chapterText indexOfObject:viewController.dataObject];
    return indexView;
}

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index=[self indexOfViewController:(CLGalleryController *)viewController];
    if (index==0 || index==NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
        
}

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index=[self indexOfViewController:(CLGalleryController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index ++;
    return [self viewControllerAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)prevButtonPress:(id)sender {
    if (self.indexCurrent>0)
    {
        self.indexCurrent--;
        CLGalleryController * initialClGC=[self viewControllerAtIndex:self.indexCurrent];
        NSArray * viewControllers=[NSArray arrayWithObjects:initialClGC, nil];
        [[self pageViewController]setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
}

- (IBAction)nextButtonPress:(id)sender {
    if (self.indexCurrent < self.imageArray.count-1)
    {
        self.indexCurrent++;
        CLGalleryController * initialClGC=[self viewControllerAtIndex:self.indexCurrent];
        NSArray * viewControllers=[NSArray arrayWithObjects:initialClGC, nil];
        [[self pageViewController]setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (void)dealloc {
   
    [super dealloc];
}
@end
