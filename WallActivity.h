//  Created by iMokhles on 05/29/15.
//  Copyright (c) 2014-2015 iMokhles. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol PLWallpaperImageViewControllerDelegate <NSObject>
- (void)wallpaperImageViewControllerDidCancel:(id)arg1;
- (void)wallpaperImageViewControllerDidFinishSaving:(id)arg1;
- (void)wallpaperImageViewControllerDidCropWallpaper:(id)arg1;
@end


@interface PUWallpaperNavigationController : UINavigationController

- (unsigned int)supportedInterfaceOrientations;

@end

@interface PLUIImageViewController : UIViewController
- (void)setAllowsEditing:(BOOL)arg1;
@end

@interface PLUIEditImageViewController : PLUIImageViewController 
- (void)setDelegate:(id)arg1;
@end

@interface PLWallpaperImageViewController : PLUIEditImageViewController
- (void)setSaveWallpaperData:(BOOL)arg1;
@end


@interface PLStaticWallpaperImageViewController : PLWallpaperImageViewController

@property BOOL colorSamplingEnabled;

- (BOOL)colorSamplingEnabled;
- (id)initWithUIImage:(id)arg1;
- (void)setWallpaperForLocations:(int)arg1;
- (id)wallpaperImage;

@end

@interface WallActivity : UIActivity <PLWallpaperImageViewControllerDelegate> {
    UIImage *sharedImage;
    NSString *imagePath;
    PUWallpaperNavigationController *wallpaperActivityViewController;
}

@end
