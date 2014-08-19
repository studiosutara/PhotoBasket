//
//  basketImage.h
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface basketImage : NSObject
@property (nonatomic, copy) NSString* mURL;
@property (nonatomic) uint mHeight;
@property (nonatomic) uint mWidth;
@property (nonatomic, strong) NSMutableArray* mThumbnails;

+(basketImage*) imageWith:(NSString*)url height:(uint)height width:(uint)width;
@end
