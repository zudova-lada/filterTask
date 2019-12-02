//
//  ISSCollectionView.m
//  CameraAndGalleryExample
//
//  Created by Лада on 29/11/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ISSCollectionView.h"
#import "ISSCellCollectionViewCell.h"



static const int count = 5;




@interface ImageStatus : NSObject

@property (strong, nonatomic) UIImage* filtredImage;
@property (nonatomic) bool isLoading;

- (UIImage*)getImage;
- (bool)getStatus;
- (void)setImage:(UIImage*)image;
- (void)setStatus:(bool)status;
- (instancetype)init;
@end

@implementation ImageStatus
-(instancetype)init{
    self = [super init];
    self.isLoading = NO;
    self.filtredImage = [UIImage new];
    self.filtredImage = [UIImage imageNamed: @"loading"];
    return self;
}

- (void)setImage:(UIImage*)image
{
    self.filtredImage = image;
}
- (void)setStatus:(bool)status
{
    self.isLoading = status;
}

- (UIImage*)getImage
{
    return self.filtredImage;
}

- (bool)getStatus
{
    return self.isLoading;
}
@end

@interface ISSCollectionView()
{
    NSMutableArray<ImageStatus*> *imagesArray;
}


@end


@implementation ISSCollectionView

#pragma mark - DataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    imagesArray = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        ImageStatus *newImage = [ImageStatus new];
        [imagesArray addObject: newImage];
    }
    
    if (!self.image) {
        return 0;
    }
    
    return count;
}

- (ISSCellCollectionViewCell *)collectionView:(ISSCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ISSCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"ISSCell" forIndexPath:indexPath];

    if ([imagesArray[indexPath.row] getStatus]) {
        [cell setImage: [imagesArray[indexPath.row] getImage]];
    } else {
        [imagesArray[indexPath.row] setStatus:true];
        [cell setImage: [imagesArray[indexPath.row] getImage]];
        dispatch_queue_t queue = dispatch_queue_create("com.image.queue", NULL);
        dispatch_async(queue, ^{
            double doubleIntensivity =  indexPath.row;
            NSNumber *intensity = [NSNumber numberWithDouble:doubleIntensivity];
            UIImage *image = [UIImage new];
            image = [self imageAfterFiltering: self.image withIntensity: intensity];
            //            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->imagesArray[indexPath.row] setImage:image];
                [cell setImage: image];
            });
            
        });
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat length = MIN(collectionView.frame.size.width/3.2, collectionView.frame.size.height);
    CGSize size = CGSizeMake(length - 2, length - 2);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.baseViewController removeSelfImage: [imagesArray[indexPath.row] getImage]];
    
}

#pragma mark  - Filter

- (UIImage *)imageAfterFiltering:(UIImage *)imageToFilter withIntensity: (NSNumber *) intensity
{
    UIImage *imageToDisplay = [self normalizedImageWithImage:imageToFilter];
    
    CIContext *context = [[CIContext alloc] initWithOptions:nil];
    CIImage *ciImage = [[CIImage alloc] initWithImage:imageToDisplay];
    
    CIFilter *ciEdges = [CIFilter filterWithName:@"CISepiaTone"];
    [ciEdges setValue:ciImage forKey:kCIInputImageKey];
    [ciEdges setValue:intensity forKey:@"inputIntensity"];
    CIImage *result = [ciEdges valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    CFRelease(cgImage);
    
    return filteredImage;
}

- (UIImage *)normalizedImageWithImage:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
