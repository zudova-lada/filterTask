//
//  ISSCollectionView.h
//  CameraAndGalleryExample
//
//  Created by Лада on 29/11/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ISSCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) ViewController *baseViewController;

@end

NS_ASSUME_NONNULL_END
