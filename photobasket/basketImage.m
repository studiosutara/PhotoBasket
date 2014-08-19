//
//  basketImage.m
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import "basketImage.h"

@implementation basketImage

+(basketImage*) imageWith:(NSString*)url height:(uint)height width:(uint)width
{
    basketImage* image = [[basketImage alloc] init];
    if(!url)
        return image;

    image.mURL = url;
    image.mHeight = height;
    image.mWidth = width;
    
    return image;
}
@end
