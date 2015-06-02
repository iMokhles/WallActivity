//  Created by iMokhles on 05/29/15.
//  Copyright (c) 2014-2015 iMokhles. All rights reserved.
//

#import "WallActivity.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.WallActivity.plist"

static BOOL isResizeEnabled;
#define isResizeEnabledKey @"enableResize"

static BOOL isResizeEnabledBOOL()
{
    NSDictionary *tweakSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *isResizeEnabledNU = tweakSettings[isResizeEnabledKey];
    isResizeEnabled = isResizeEnabledNU ? [isResizeEnabledNU boolValue] : 1;
    return isResizeEnabled;
}

static NSBundle* getPhotosBundle() {
    return [NSBundle bundleWithPath:@"/System/Library/Frameworks/PhotosUI.framework"];
}

extern NSString *PLLocalizedFrameworkString(NSString *key, NSString *comment);


@implementation WallActivity

- (NSString *)activityType
{
    return @"com.imokhles.WallActivity";
}

- (NSString *)activityTitle
{
    return PLLocalizedFrameworkString(@"USE_AS_WALLPAPER", @"");
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageWithContentsOfFile:@"/Library/Application Support/WallActivity/PUActivityUseAsWallPaper_iPad@2x.png"];
    }
    else
    {
        return [UIImage imageWithContentsOfFile:@"/Library/Application Support/WallActivity/PUActivityUseAsWallPaper@2x.png"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (UIActivityItemProvider *item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            return YES;
        } else if ([item isKindOfClass:[NSURL class]]) {
            NSURL *getUrl = (NSURL *)item;
            NSString *utiTypeRen = [self UTIForURL:getUrl];
            if ([utiTypeRen isEqualToString:@"public.image"] || [utiTypeRen isEqualToString:@"public.png"] || [utiTypeRen isEqualToString:@"public.jpg"] || [utiTypeRen isEqualToString:@"public.jpeg"]) {
                return YES;
            } else {
                return NO;
            }
        } else if ([item isKindOfClass:[NSURL class]] && [(NSURL *)item isFileURL]) {
            NSURL *getUrl = (NSURL *)item;
            NSString *utiTypeRen = [self UTIForURL:getUrl];
            if ([utiTypeRen isEqualToString:@"public.image"] || [utiTypeRen isEqualToString:@"public.png"] || [utiTypeRen isEqualToString:@"public.jpg"] || [utiTypeRen isEqualToString:@"public.jpeg"]) {
                    return YES;
                // });
                return YES;
            } else {
                return NO;
            }
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            sharedImage = (UIImage *)item;
        } else if ([item isKindOfClass:[NSURL class]] && [(NSURL *)item isFileURL]) {
            NSURL *getUrl = (NSURL *)item;
            NSString *utiTypeRen = [self UTIForURL:getUrl];
            if ([utiTypeRen isEqualToString:@"public.image"] || [utiTypeRen isEqualToString:@"public.png"] || [utiTypeRen isEqualToString:@"public.jpg"] || [utiTypeRen isEqualToString:@"public.jpeg"] || [utiTypeRen isEqualToString:@"public.content"] || [utiTypeRen isEqualToString:@"public.data"]) {
                    NSData *getData = [NSData dataWithContentsOfURL:getUrl];
                    UIImage *getImage = [UIImage imageWithData:getData];
                    if (getImage == nil) {
                        sharedImage = getImage;
                    }
                    sharedImage = getImage;
            }
        } else if ([item isKindOfClass:[NSURL class]]) {
            NSURL *getUrl = (NSURL *)item;
            NSString *utiTypeRen = [self UTIForURL:getUrl];
            if ([utiTypeRen isEqualToString:@"public.image"] || [utiTypeRen isEqualToString:@"public.png"] || [utiTypeRen isEqualToString:@"public.jpg"] || [utiTypeRen isEqualToString:@"public.jpeg"] || [utiTypeRen isEqualToString:@"public.content"] || [utiTypeRen isEqualToString:@"public.data"]) {
                    NSData *getData = [NSData dataWithContentsOfURL:getUrl];
                    UIImage *getImage = [UIImage imageWithData:getData];
                    if (getImage == nil) {
                        sharedImage = getImage;
                    }
                    sharedImage = getImage;
            }
        }

        
        PLStaticWallpaperImageViewController *wallpaperViewController;
        CGSize newSize = [UIScreen mainScreen].bounds.size;

        if (isResizeEnabledBOOL() == YES) {
            UIGraphicsBeginImageContext(newSize);
            [sharedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
            UIGraphicsEndImageContext();
            wallpaperViewController = [[PLStaticWallpaperImageViewController alloc] initWithUIImage:newImage];
        } else {
            wallpaperViewController = [[PLStaticWallpaperImageViewController alloc] initWithUIImage:sharedImage];
        }
        
        [wallpaperViewController setAllowsEditing:YES];
        [wallpaperViewController setSaveWallpaperData:YES];
        [wallpaperViewController setDelegate:self];

        wallpaperActivityViewController = [[PUWallpaperNavigationController alloc] initWithRootViewController:wallpaperViewController];
    }
}

#pragma mark - Helper
- (NSString *)UTIForURL:(NSURL *)url
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
    return (NSString *)CFBridgingRelease(UTI) ;
}

- (UIViewController *)activityViewController {

    return wallpaperActivityViewController;
}

- (void)wallpaperImageViewControllerDidCancel:(PLStaticWallpaperImageViewController *)arg1 {
    [self activityDidFinish:NO];
    [arg1 setDelegate:nil];
}
- (void)wallpaperImageViewControllerDidFinishSaving:(PLStaticWallpaperImageViewController *)arg1 {
    [self activityDidFinish:YES];
    [arg1 setDelegate:nil];
}
- (void)wallpaperImageViewControllerDidCropWallpaper:(PLStaticWallpaperImageViewController *)arg1 {
    return;
}
@end
