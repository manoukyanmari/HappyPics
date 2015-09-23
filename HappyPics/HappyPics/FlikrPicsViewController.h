//
//  FlikrPicsViewController.h
//  HappyPics
//
//  Created by Mariam on 8/27/15.
//  Copyright (c) 2015 Happy Pics Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlikrPicsViewController : UICollectionViewController


@property (weak,nonatomic) IBOutlet UIBarButtonItem *shareButton;

- (IBAction)shareButtonTouched:(id)sender;


@end
