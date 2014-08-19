//
//  TrialViewController.m
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import "TrialViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "basketImage.h"
#import "imageCollectionCell.h"
#import <CoreMotion/CoreMotion.h>

typedef enum
{
    scrollforward =0,
    scrollbackward,
    notscrolling
}scrolldirection;

@interface TrialViewController ()
{
    double currentTilt;
    double currentMaxAccelX;
    double currentMaxAccelY;
    double currentMaxAccelZ;
    double currentMaxRotX;
    double currentMaxRotY;
    double currentMaxRotZ;
}
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, assign) CGPoint scrollingPoint, endPoint;
@property (nonatomic, strong) NSTimer *scrollingTimer;
@property (nonatomic) scrolldirection mScrollDirection;

@end

@implementation TrialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollSlowly {
    // Set the point where the scrolling stops.
    self.endPoint = CGPointMake(0, 4000);
    // Assuming that you are starting at {0, 0} and scrolling along the x-axis.
    self.scrollingPoint = CGPointMake(0, 0);
    // Change the timer interval for speed regulation.
    self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(scrollSlowlyToPoint) userInfo:nil repeats:YES];
}

-(void) start
{
    [self.mCollectionView reloadData];
    self.mScrollDirection = notscrolling;
    [self scrollSlowly];
}

- (void)scrollSlowlyToPoint {
    self.mCollectionView.contentOffset = self.scrollingPoint;
    // Here you have to respond to user interactions or else the scrolling will not stop until it reaches the endPoint.
//    if (CGPointEqualToPoint(self.scrollingPoint, self.endPoint)) {
//        [self.scrollingTimer invalidate];
//    }
    // Going one pixel to the right.
    
//    NSLog(@"Scrolldirection = %d", self.mScrollDirection);
    if(self.mScrollDirection == scrollforward)
    {
        if(CGPointEqualToPoint(self.scrollingPoint, self.endPoint))
            return;
        
        self.scrollingPoint = CGPointMake(self.scrollingPoint.x, self.scrollingPoint.y+4);
    }
    else if(self.mScrollDirection == scrollbackward)
    {
        if(CGPointEqualToPoint(self.scrollingPoint, CGPointMake(0, 0)))
            return;
        
        self.scrollingPoint = CGPointMake(self.scrollingPoint.x, self.scrollingPoint.y-4);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.mCollectionView.bounds = self.view.bounds;
    [self.mCollectionView registerClass:[imageCollectionCell class] forCellWithReuseIdentifier:@"Cell"];

    //self.mCollectionView.backgroundView = [[UIImageView alloc]
      //                                     initWithImage:[UIImage imageNamed:@"light-grey-background.png"]];
    
//    self.mCollectionView.backgroundColor = [UIColor blackColor];
    self.mCollectionView.dataSource = self;
    self.mCollectionView.delegate = self;
    
    self.mPhotoURLs = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.

    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    NSOperationQueue* motionQueue = [[NSOperationQueue alloc] init];
    CGFloat updateInterval = 1/2.0;
    CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    [self.motionManager setDeviceMotionUpdateInterval:updateInterval];
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame
                                                           toQueue:motionQueue
                                                       withHandler:
     ^(CMDeviceMotion* motion, NSError* error){
         
         CGFloat x = motion.gravity.x;
         CGFloat y = motion.gravity.y;
         CGFloat z = motion.gravity.z;
         
         CGFloat r = sqrtf(motion.gravity.x*x + y*y + z*z);
         CGFloat tiltForwardBackward = floor(acosf(z/r) * 180.0f / M_PI - 90.0f);

        // NSLog(@"Current: %f, new: %f", currentTilt, tiltForwardBackward);
         if(floor(currentTilt)>floor(tiltForwardBackward))
         {
           //  NSLog(@"titling forwrd");
             self.mScrollDirection = scrollforward;
         }
         else if(floor(currentTilt) < floor(tiltForwardBackward))
         {
             self.mScrollDirection = scrollbackward;
             //NSLog(@"titling backword");
         }
         else
             self.mScrollDirection = notscrolling;
         
         currentTilt = tiltForwardBackward;
     }];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.mPhotoURLs.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv
                                  dequeueReusableCellWithReuseIdentifier:@"Cell"
                                  forIndexPath:indexPath];

//    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell " forIndexPath:indexPath];
    basketImage* bbigimage = self.mPhotoURLs[indexPath.row];
    basketImage* bimage = bbigimage.mThumbnails[1];
    [cell.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bimage.mWidth+15, bimage.mHeight+15)];
    background.backgroundColor = [UIColor colorWithRed:142/255
                                                 green:142/255
                                                  blue:147/255
                                                 alpha:0.7];
    [cell addSubview:background];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bimage.mWidth, bimage.mHeight)];
    [image setImageWithURL:[NSURL URLWithString:bimage.mURL]];
    [cell addSubview:image];
    
    image.center = background.center;

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 2
    basketImage* bbigimage = self.mPhotoURLs[indexPath.row];
    basketImage* image = bbigimage.mThumbnails[1];
    CGSize retval = CGSizeMake(image.mWidth+15,image.mHeight+15);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
