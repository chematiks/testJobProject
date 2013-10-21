//
//  CLGallaryViewController.h
//  testJobProject
//
//  Created by Администратор on 10/7/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGallaryViewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
@private
    NSMutableArray *galleryImages_;
    NSInteger currentIndex_;
    NSInteger previousPage_;
    NSInteger maxElem_;
}
@property (nonatomic, retain)  UIImageView *prevImgView; //reusable Imageview  - always contains the previous image
@property (nonatomic, retain)  UIImageView *centerImgView; //reusable Imageview  - always contains the currently shown image
@property (nonatomic, retain)  UIImageView *nextImgView; //reusable Imageview  - always contains the next image image

@property(nonatomic, retain)NSMutableArray *galleryImages; //Array holding the image file paths
@property(nonatomic, retain)UIScrollView *imageHostScrollView; //UIScrollview to hold the images

@property (retain, nonatomic) IBOutlet UIButton *prevImage;
@property (retain, nonatomic) IBOutlet UIButton *nxtImage;

@property (nonatomic, assign) NSInteger currentIndex;

//navigation buttons methood...
- (IBAction)nextImage:(id)sender;
- (IBAction)prevImage:(id)sender;

#pragma mark - image loading-
//Simple method to load the UIImage, which can be extensible -
-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;

@end
