//
//  LCTOverlayView.h
//  CameraAndGalleryExample
//
//  Created by Alexey Levanov on 11.04.2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCTOverlayView : UIView

/**
 Создает overlayView со стремной черной дырой

 @return LCTOverlayView
 */
+ (LCTOverlayView *)createHoleOverlayView;

@end

NS_ASSUME_NONNULL_END
