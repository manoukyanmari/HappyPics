//
//  FlikrPicsViewController.m
//  HappyPics
//
//  Created by Mariam on 8/27/15.
//  Copyright (c) 2015 Happy Pics Company. All rights reserved.
//

#import "FlikrPicsViewController.h"
#import "MMFlickrPicViewCell.h"
#import "MMFlickrPicsHeaderView.h"
#import "OpenFlickrPicViewController.h"
#import <Social/Social.h>

@interface FlikrPicsViewController () {
    NSArray *flickrImages;
    BOOL shareEnabled;
    NSMutableArray *selectedFlickrPics;
    NSString *title;
}

@end

@implementation FlikrPicsViewController

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
    // Do any additional setup after loading the view.
    
    // Initialize recipe image array
    
    // Initialize recipe image array
    NSArray *dogs = [NSArray arrayWithObjects:@"322880-dogs-cute-dog.jpg", @"800952083.jpeg", @"1380310395-shchenki-ch1--77.jpg", @"1380310400-shchenki-ch1--29.jpg",@"cute-dog-4.jpg",@"cute-dog-dogs-35602469-964-768.jpg",@"cute-dogs4.jpg", @"images.jpeg", @"images-2.jpeg", nil];
    NSArray *cats = [NSArray arrayWithObjects:@"images-3.jpeg", @"images-4.jpeg", @"images-5.jpeg", @"Cute-Cats-cats-33440930-1280-800.jpg", @"cat_1-jpg.jpg",@"cathug.jpg",@"2577499-cat.jpg",@"51190-Cute-Cat-Hug.jpg", nil];
    NSArray *nature = [NSArray arrayWithObjects:@"sea-house-amazing-nature-wallpaper.jpg",@"LIGHTNING-TREE-B.jpg",@"kcmIbSk.jpg",@"14972353663_f40427599c_o.jpg",@"amazing_nature_28-1280x1024.jpg", nil];
    flickrImages = [NSArray arrayWithObjects:dogs, cats, nature, nil];
    
     [(UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
   
    
    // UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
   // collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    selectedFlickrPics = [NSMutableArray array];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[flickrImages objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [flickrImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *flickrImageView = (UIImageView *)[cell viewWithTag:100];
    flickrImageView.image = [UIImage imageNamed:[flickrImages[indexPath.section] objectAtIndex:indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.jpg"]];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MMFlickrPicsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (indexPath.section == 0)
        {
            title = [[NSString alloc]initWithFormat:@"Dog"];
        }
        else if(indexPath.section == 1)
        {
            title = [[NSString alloc]initWithFormat:@"Cat"];
        }
        else if (indexPath.section == 2)
        {
            title = [[NSString alloc]initWithFormat:@"Nature"];
        }
        
        
        headerView.title.text = title;
        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFlickrPhoto"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        OpenFlickrPicViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.flickrImgName = [flickrImages[indexPath.section] objectAtIndex:indexPath.row];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (IBAction)shareButtonTouched:(id)sender{
    if (shareEnabled) {
        
        // Post selected photos to Facebook
        if ([selectedFlickrPics count] > 0) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller setInitialText:@"Check out my recipes!"];
                for (NSString *flickrImageView in selectedFlickrPics) {
                    [controller addImage:[UIImage imageNamed:flickrImageView]];
                }
                
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }
        
        // Deselect all selected items
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        // Remove all items from selectedRecipes array
        [selectedFlickrPics removeAllObjects];
        
        // Change the sharing mode to NO
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        self.shareButton.title = @"Choose";
        [self.shareButton setStyle:UIBarButtonItemStylePlain];
        
    } else {
        
        // Change shareEnabled to YES and change the button text to DONE
        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        self.shareButton.title = @"Share";
        [self.shareButton setStyle:UIBarButtonItemStyleDone];
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (shareEnabled) {
        // Determine the selected items by using the indexPath
        NSString *selectedPic = [flickrImages[indexPath.section] objectAtIndex:indexPath.row];
        // Add the selected item into the array
        [selectedFlickrPics addObject:selectedPic];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(shareEnabled){
        //Determine Deselected Item
        NSString *deSelectedPic = [flickrImages[indexPath.section] objectAtIndex:indexPath.row];
        [selectedFlickrPics removeObject:deSelectedPic];
    
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if(shareEnabled) {
        return NO;
    } else {
        return YES;
    }

}




/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
*/

@end
