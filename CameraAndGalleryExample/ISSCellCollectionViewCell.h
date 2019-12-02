//
//  ISSCellCollectionViewCell.h
//  CameraAndGalleryExample
//
//  Created by Лада on 29/11/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ISSCellCollectionViewCell : UICollectionViewCell

- (void)setImage:(UIImage *)image;
- (BOOL )isItLoad;

@end

NS_ASSUME_NONNULL_END
