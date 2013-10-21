//
//  CLGallaryViewController.m
//  testJobProject
//
//  Created by Администратор on 10/7/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLGallaryViewController.h"

@interface CLGallaryViewController ()

@end

@implementation CLGallaryViewController

@synthesize galleryImages = galleryImages_;
@synthesize imageHostScrollView = imageHostScrollView_;
@synthesize currentIndex = currentIndex_;

@synthesize prevImage;
@synthesize nxtImage;

@synthesize prevImgView;
@synthesize centerImgView;
@synthesize nextImgView;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup the scrollview
    // the scrollview holds 3 uiimageviews in a row, to make nice swipe possible
    self.imageHostScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame)*3, CGRectGetHeight(self.imageHostScrollView.frame));
    
    self.imageHostScrollView.delegate = self;
    [self.view sendSubviewToBack:self.imageHostScrollView];
    
    CGRect rect = CGRectZero;
    
    rect.size = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame), CGRectGetHeight(self.imageHostScrollView.frame));
    
    // add prevView as first in line
    UIImageView *prevView = [[UIImageView alloc] initWithFrame:rect];
    self.prevImgView = prevView;
    [prevView release];
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    
    scrView.delegate = self;
    [scrView addSubview:self.prevImgView];
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    self.prevImgView.frame = scrView.bounds;
    
    // add currentView in the middle (center)
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *currentView = [[UIImageView alloc] initWithFrame:rect];
    self.centerImgView = currentView;
    [self.imageHostScrollView addSubview:self.centerImgView];
    [currentView release];
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    scrView.delegate = self;
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    [self.imageHostScrollView addSubview:scrView];
   
    [scrView addSubview:self.centerImgView];
    self.centerImgView.frame = scrView.bounds;
    [scrView release];
    
    // add nextView as third view
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *nextView = [[UIImageView alloc] initWithFrame:rect];
    self.nextImgView = nextView;
    [self.imageHostScrollView addSubview:self.nextImgView];
    [nextView release];
    
    self.imageHostScrollView.userInteractionEnabled=YES;
    self.imageHostScrollView.pagingEnabled = YES;
    self.imageHostScrollView.delegate = self;
    
    self.prevImgView.contentMode = UIViewContentModeRedraw;
    self.centerImgView.contentMode = UIViewContentModeRedraw;
    self.nextImgView.contentMode = UIViewContentModeRedraw;
    
    //some data for testing
    self.galleryImages = [[NSMutableArray alloc] init];
    
    for (int i=0; i<18; i++)
    {
        [self.galleryImages addObject:[NSString stringWithFormat:@"%d.jpg",i]];
    }
    maxElem_=[self totalImages]-1;
    self.currentIndex = 0;
    [self buttonHidden];
}

-(void) dealloc
{
    [super dealloc];
}

#pragma mark -navigation methods

- (IBAction)nextImage:(id)sender
{
    [self setRelativeIndex:1];
}

- (IBAction)prevImage:(id)sender
{
    [self setRelativeIndex:-1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    previousPage_ = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if(sender.contentOffset.x >= sender.frame.size.width && [self currentIndex]<maxElem_) {
        //swipe left, go to next image
        if ([self currentIndex]==0)
        {
            currentIndex_++;
        }
        else
            if ([self currentIndex]<maxElem_-1)
            {
                [self setRelativeIndex:1];
                [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
            }
            else
                if (self.currentIndex==maxElem_-1)
                {
                    currentIndex_=maxElem_;
                }
    }
    else
        if(sender.contentOffset.x < sender.frame.size.width)
        {
            //swipe right, go to previous image
            if ([self currentIndex]>1)
            {
                [self setRelativeIndex:-1];
                [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
            }
            else
                if(self.currentIndex==1)
                {
                    currentIndex_--;
                }
                else
                    if ([self currentIndex]==maxElem_)
                    {
                        currentIndex_--;
                    }
     
        }
        else
            if(sender.contentOffset.x >= sender.frame.size.width)
                currentIndex_--;
    [self buttonHidden];
}

-(void) buttonHidden
{
    if (currentIndex_==0)
    {
        self.prevImage.hidden=YES;
    }
    else
        if (currentIndex_==maxElem_)
        {
            self.nxtImage.hidden=YES;
        }
        else
        {
            self.prevImage.hidden=NO;
            self.nxtImage.hidden=NO;
        }
}

#pragma mark - image loading-

-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;{
    NSString *filePath = [self.galleryImages objectAtIndex:inImageIndex];
	UIImage *image = nil;
    //Otherwise load from the file path
    if (nil == image)
    {
		NSString *imagePath = filePath;
		image = [UIImage imageNamed:imagePath];
    }
    
	return image;
}

#pragma mark -

- (NSInteger)totalImages
{
    return [self.galleryImages count];
}

- (NSInteger)currentIndex
{
    return currentIndex_;
}

- (void)setCurrentIndex:(NSInteger)inIndex
{
    currentIndex_ = inIndex;
    
    if([galleryImages_ count] > 0)
    {
        self.prevImgView.image=[self imageAtIndex:[self relativeIndex:-1]];
        self.centerImgView.image=[self imageAtIndex:[self relativeIndex: 0]];
        self.nextImgView.image=[self imageAtIndex:[self relativeIndex: 1]];
    }
}

- (NSInteger)relativeIndex:(NSInteger)inIndex
{
    if ([self currentIndex]==0) inIndex++;
    if ([self currentIndex]==maxElem_) inIndex--;
    return  [self currentIndex]+inIndex;
}

- (void)setRelativeIndex:(NSInteger)inIndex
{
    if (currentIndex_>1 && currentIndex_<maxElem_-1)
    {
        [self setCurrentIndex:self.currentIndex + inIndex];
    }
    else
        if (currentIndex_<=1 &&inIndex==-1)
        {
            currentIndex_=0;
            [self.imageHostScrollView setContentOffset:CGPointMake(0, 0)  animated:NO];
        }
        else
            if (currentIndex_<=1 && inIndex==1)
            {
                [self setCurrentIndex:self.currentIndex+inIndex];
                [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
            }
            else
                if (currentIndex_>=maxElem_-1 && inIndex==1)
                {
                    currentIndex_=maxElem_;
                    [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame)*2, 0)  animated:NO];
                }
                else
                    if (currentIndex_==maxElem_ && inIndex==-1)
                    {
                        currentIndex_=currentIndex_+inIndex;
                        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
                    }
                    else
                        if (currentIndex_==maxElem_-1 && inIndex==-1)
                        {
                            [self setCurrentIndex:self.currentIndex + inIndex];
                        }
     [self buttonHidden];
}


@end
