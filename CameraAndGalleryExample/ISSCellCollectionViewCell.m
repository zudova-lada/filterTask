//
//  ISSCellCollectionViewCell.m
//  CameraAndGalleryExample
//
//  Created by Лада on 29/11/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ISSCellCollectionViewCell.h"


@interface ISSCellCollectionViewCell ()
{
    BOOL loading;
}

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ISSCellCollectionViewCell
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (BOOL )isItLoad
{
    return loading;    
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor greenColor];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self addConstraints:@[leading, trailing, top, bottom]];
    
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.accessibilityContainerType = UIAccessibilityContainerTypeNone;
    self.imageView.image = nil;
    
}

@end
