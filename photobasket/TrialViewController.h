//
//  TrialViewController.h
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrialViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView* mCollectionView;
@property (nonatomic, strong) NSMutableArray* mPhotoURLs;

-(void) start;
-(void) getPhotos;
@end
