//
//  PhotoViewerViewController.h
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewerViewController : UICollectionViewController <UICollectionViewDataSource, UIBarPositioningDelegate>
-(void) getPhotos;
@end
