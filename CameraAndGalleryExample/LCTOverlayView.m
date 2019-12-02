//
//  LCTOverlayView.m
//  CameraAndGalleryExample
//
//  Created by Alexey Levanov on 11.04.2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTOverlayView.h"

@implementation LCTOverlayView

+ (LCTOverlayView *)createHoleOverlayView
{
	LCTOverlayView *overlayView = [[LCTOverlayView alloc] init];
	overlayView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
	overlayView.backgroundColor = UIColor.clearColor;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"blackHole"]];
	imageView.center = CGPointMake(CGRectGetWidth(overlayView.bounds)/2, CGRectGetHeight(overlayView.bounds)/2);
	[overlayView addSubview:imageView];
	
	return overlayView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
