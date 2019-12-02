//
//  ViewController.m
//  CameraAndGalleryExample
//
//  Created by Alexey Levanov on 11.04.2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ViewController.h"
#import "LCTOverlayView.h"
#import "ISSCollectionView.h"
#import "ISSCellCollectionViewCell.h"



static const CGFloat LCTButtonHeight = 50.0;
static const CGFloat LCTButtonOffset = 10.0;
static const CGFloat LCTStatusBarOffset = 20.0;
static const CGFloat LCTButtonHorrizontalOffset = 20.f;


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LCTOverlayView *overlayView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) ISSCollectionView *collectionView;

@end


@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self createUI];
    
    
    self.collectionView = [[ISSCollectionView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height/9*7, self.imageView.frame.size.width, self.imageView.frame.size.height/9*2) collectionViewLayout:[UICollectionViewLayout new]];
    [self.collectionView registerClass: [ISSCellCollectionViewCell class] forCellWithReuseIdentifier: @"ISSCell" ];
    self.collectionView.delegate = self.collectionView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.pagingEnabled = YES;
//    flowLayout.sectionInset =  UIEdgeInsetsMake(10, 10, 2, 2);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self.collectionView;
    self.collectionView.backgroundColor = UIColor.grayColor;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 20);
    self.collectionView.contentSize = CGSizeMake(self.collectionView.frame.size.width/3, self.collectionView.frame.size.height);
    
    CGFloat height = self.view.frame.size.height - LCTStatusBarOffset - (LCTButtonHeight + 2*LCTButtonOffset);
    CGRect imageFrame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, height/9*7);
    self.imageView.frame = imageFrame;
    self.collectionView.image = self.selectedImage;
    self.collectionView.baseViewController = self;
    [self.view addSubview: self.collectionView];
//    [self.view addSubview: self.collectionView];
}



#pragma mark - UI

- (void)createUI
{
	CGFloat buttonAreaHeight =  LCTButtonHeight + 2*LCTButtonOffset;
	
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, LCTStatusBarOffset, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - LCTStatusBarOffset - buttonAreaHeight)];
	self.imageView.layer.borderColor = UIColor.blackColor.CGColor;
	self.imageView.layer.borderWidth = 2.0;
	[self.view addSubview:self.imageView];
	
	UIButton *galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	galleryButton.frame = CGRectMake(LCTButtonHorrizontalOffset, CGRectGetMaxY(self.imageView.frame) + LCTButtonOffset, CGRectGetWidth(self.view.frame)/2 - 1.5*LCTButtonOffset, LCTButtonHeight);
	[galleryButton setTitle:@"Галерея" forState:UIControlStateNormal];
	[galleryButton addTarget:self action:@selector(galleryButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
	[galleryButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
	[self.view addSubview:galleryButton];
	
	UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cameraButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 + 0.5*LCTButtonOffset, CGRectGetMaxY(self.imageView.frame) + LCTButtonOffset, CGRectGetWidth(self.view.frame)/2 - 1.5*LCTButtonOffset, LCTButtonHeight);
	[cameraButton setTitle:@"Камера" forState:UIControlStateNormal];
	[cameraButton addTarget:self action:@selector(cameraButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
	[cameraButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
	[self.view addSubview:cameraButton];
	
	self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 50)];
	[self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	
//    [self.view addSubview:self.slider];
	
}


#pragma mark - Button's/ Slider Actions

- (void)sliderValueChanged:(UISlider *)slider
{
	NSNumber *intensity = [NSNumber numberWithFloat:slider.value*10];
	self.imageView.image = [self imageAfterFiltering:self.selectedImage withIntensity:intensity];
}

- (void)galleryButtonWasPressed
{
	NSLog(@"galleryButtonWasPressed");
	[self presentImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];

    
}

- (void)cameraButtonWasPressed
{
	[self presentImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
}

- (UIImagePickerController *)createImagePickerWithSourceType: (UIImagePickerControllerSourceType) sourceType
{
	UIImagePickerController *imagePickerController = [UIImagePickerController new];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = sourceType;
    
//	imagePickerController.allowsEditing = YES;
//	if(sourceType == UIImagePickerControllerSourceTypeCamera)
//	{
//		imagePickerController.cameraOverlayView = self.overlayView;
//	}
	return imagePickerController;
}

- (void)presentImagePickerWithType: (UIImagePickerControllerSourceType) sourceType
{
	if ([UIImagePickerController isSourceTypeAvailable:sourceType])
	{
		UIImagePickerController *imagePickerController = [self createImagePickerWithSourceType:sourceType];
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"Got unavaliable source type");
	}
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
	UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	self.selectedImage = selectedImage;
    
//    UIImage *filteredImage = [self imageAfterFiltering:selectedImage];
	self.imageView.image = selectedImage;
    self.collectionView.image = selectedImage;
    [self.collectionView reloadData];
	[picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Lazy init

- (LCTOverlayView *)overlayView
{
	if (!_overlayView)
	{
		_overlayView = [LCTOverlayView createHoleOverlayView];
	}
	
	return _overlayView;
}


#pragma mark - CIFilter

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


#pragma mark - Helpers

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


#pragma mark - PickerController
- (void)presentPickerController
{
	UIImagePickerController *imagePickerController = [UIImagePickerController new];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - filtersView

-(void) removeSelfImage: (UIImage*) image
{
    self.imageView.image = image;
}
@end
