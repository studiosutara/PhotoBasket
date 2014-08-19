//
//  ImagesCell.m
//  photobasket
//
//  Created by Shilpa Modi on 10/26/13.
//  Copyright (c) 2013 StudioSutara. All rights reserved.
//

#import "ImagesCell.h"

@implementation ImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect windowSize = [[UIScreen mainScreen] bounds];
        CGRect rect = CGRectMake(0,
                                 0,
                                 (windowSize.size.width/2),
                                 (windowSize.size.height/2) - 20);
        
        self.mRightImage = [[UIImageView alloc] initWithFrame:rect];

        rect = CGRectMake((windowSize.size.width/2),
                          0,
                          (windowSize.size.width/2),
                          (windowSize.size.height/2) - 20);
        
        self.mLeftImage = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:self.mRightImage];
        [self addSubview:self.mLeftImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
