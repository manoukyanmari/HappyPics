//
//  OpenFlickrPicViewController.h
//  HappyPics
//
//  Created by Mariam on 8/29/15.
//  Copyright (c) 2015 Happy Pics Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenFlickrPicViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *flickrImgView;
@property (weak, nonatomic) NSString *flickrImgName;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


- (IBAction)close:(id)sender;


@end
