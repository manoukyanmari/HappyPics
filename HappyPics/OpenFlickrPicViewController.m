//
//  OpenFlickrPicViewController.m
//  HappyPics
//
//  Created by Mariam on 8/29/15.
//  Copyright (c) 2015 Happy Pics Company. All rights reserved.
//

#import "OpenFlickrPicViewController.h"

@interface OpenFlickrPicViewController ()


- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;


@end

@implementation OpenFlickrPicViewController

@synthesize scrollView = _scrollView;
@synthesize flickrImgView = _flickrImgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)centerScrollViewContents{

    CGSize boundsSize = self.scrollView.bounds.size;
    
    CGRect contentsFrame = self.flickrImgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.flickrImgView.frame = contentsFrame;

}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    // 1
    CGPoint pointInView = [recognizer locationInView:self.flickrImgView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];

}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.flickrImgView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
    
    if (_scrollView.zoomScale!=1.0) {
        // Zooming, enable scrolling
        _scrollView.scrollEnabled = TRUE;
    } else {
        // Not zoomed, disable scrolling so gestures get used instead
        _scrollView.scrollEnabled = FALSE;
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_scrollView addSubview:_flickrImgView];
    
    _scrollView.contentSize = _contentView.frame.size; //sets ScrollView content size
    
    [_flickrImgView setUserInteractionEnabled:YES];
    [_flickrImgView setMultipleTouchEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    
    self.flickrImgView.image = [UIImage imageNamed:self.flickrImgName];
    UIImage *image = self.flickrImgView.image;
    self.flickrImgView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size= image.size};
    [self.scrollView addSubview:self.flickrImgView];
    
    [_scrollView setContentSize:self.flickrImgView.frame.size];
    
    [_scrollView setScrollEnabled:YES];
    [_scrollView setClipsToBounds:YES];
    [_scrollView setBackgroundColor:[UIColor yellowColor]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10.0f];
    [UIView commitAnimations];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [_scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
   //  // this is your image view size
    
     // we're currently at 100% size
   // self.scrollView.minimumZoomScale=0.5;
   // self.scrollView.maximumZoomScale=6.0;
   // self.scrollView.contentSize=CGSizeMake(1280, 960);
    //self.scrollView.delegate=self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height/self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth,scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];

}



- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
