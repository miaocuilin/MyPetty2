//
//  MainViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MainViewController.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "SquareViewController.h"
#import "PublishViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
#import "ToolTipsViewController.h"

#import "WaterViewController.h"
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
@interface MainViewController () <AFPhotoEditorControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.menuBtn.selected = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    segmentClickIndex = 1;
    [self createScrollView];
    [self createFakeNavigation];
    [self createViewControllers];
    [self createSegment];

    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
    
    [self createAlphaBtn];
}
/***********************/
-(void)createAlphaBtn
{
    self.alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
    self.alphaBtn.backgroundColor = [UIColor blackColor];
    self.alphaBtn.alpha = 0;
    self.alphaBtn.hidden = YES;
    [self.view addSubview:self.alphaBtn];
}
-(void)hideSideMenu
{
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    [menu hideMenuAnimated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.alphaBtn.hidden = YES;
        self.menuBtn.selected = NO;
    }];
}


-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    self.menuBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
    self.menuBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:self.menuBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 32, 200, 20) Font:17 Text:@"宠物星球"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * camara = [MyControl createButtonWithFrame:CGRectMake(320-82/2-15, 64-54/2-7, 82/2, 54/2) ImageName:@"相机图标.png" Target:self Action:@selector(cameraClick) Title:nil];
    camara.showsTouchWhenHighlighted = YES;
    [navView addSubview:camara];
}
-(void)menuBtnClick:(UIButton *)button
{
    /***********/
//    [ControllerManager setIsSuccess:1];
    
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if ([ControllerManager getIsSuccess]) {
        if (button.selected) {
            //截屏
            UIImage * image = [MyControl imageWithView:[UIApplication sharedApplication].keyWindow];
            UIImage * image2 = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
            [MyControl saveScreenshotsWithImage:image2];
            //        [UIView animateWithDuration:0.1 animations:^{
            //            [MyControl saveScreenshotsWithView:[UIApplication sharedApplication].keyWindow];
            //        }];
            
            [menu showMenuAnimated:YES];
            self.alphaBtn.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.alphaBtn.alpha = 0.5;
            }];
        }else{
            [menu hideMenuAnimated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.alphaBtn.alpha = 0;
            } completion:^(BOOL finished) {
                self.alphaBtn.hidden = YES;
            }];
        }
    }else{
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
//        [vc autorelease];
    }
}
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.delegate = self;
    sv.contentSize = CGSizeMake(320*3, self.view.frame.size.height);
    sv.contentOffset = CGPointMake(320, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
}
-(void)createViewControllers
{
//    RandomViewController * rvc = [[RandomViewController alloc] init];
//    [self addChildViewController:rvc];
//    [rvc.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
//    [sv addSubview:rvc.view];
    
    WaterViewController *water = [[WaterViewController alloc] init];
//    [self addChildViewController:water];
    [water.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    [sv addSubview:water.view];

    
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
}
-(void)createSegment
{
    NSArray * scArray = @[@"萌宠推荐", @"宇宙广场", @"星球关注"];
    sc = [[UISegmentedControl alloc] initWithItems:scArray];
    sc.backgroundColor = [UIColor whiteColor];
    sc.alpha = 0.7;
    sc.layer.cornerRadius = 4;
    sc.layer.masksToBounds = YES;
    sc.frame = CGRectMake(10, 69, 300, 30);
    [sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    //默认选中第二个，宇宙广场
    sc.selectedSegmentIndex = 1;
    sc.tintColor = BGCOLOR;
    [self.view addSubview:sc];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    if (sc.selectedSegmentIndex == 2 && ![ControllerManager getIsSuccess]) {
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        
        sc.selectedSegmentIndex = segmentClickIndex;
        return;
    }

    int a = sc.selectedSegmentIndex;
    segmentClickIndex = a;
    if (a == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(0, 0);
        }];
    }else if(a == 1){
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(320, 0);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(320*2, 0);
        }];
    }
    sc.selectedSegmentIndex = segmentClickIndex;
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int a = sv.contentOffset.x;
    sc.selectedSegmentIndex = a/320;
    
    if (a == 0) {
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            SquareViewController * svc = [[SquareViewController alloc] init];
            [self addChildViewController:svc];
            [svc.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [sv addSubview:svc.view];
            [self.view bringSubviewToFront:sc];
        }
    }else if(a == 320*2){
        if (![ControllerManager getIsSuccess]) {
            sv.contentOffset = CGPointMake(320, 0);
            //提示注册
            ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc createLoginAlertView];
            return;
        }
        if (isCreated[2] == NO) {
            isCreated[2] = YES;
            FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
            [self addChildViewController:fvc];
            [fvc.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [sv addSubview:fvc.view];
            [self.view bringSubviewToFront:sc];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            SquareViewController * svc = [[SquareViewController alloc] init];
            [self addChildViewController:svc];
            [svc.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [sv addSubview:svc.view];
            [self.view bringSubviewToFront:sc];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
        }
    }else if(scrollView.contentOffset.x == 320*2){
        if (![ControllerManager getIsSuccess]) {
            sv.contentOffset = CGPointMake(320, 0);
            //提示注册
            ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc createLoginAlertView];
            return;
        }
        if (isCreated[2] == NO) {
            isCreated[2] = YES;
            FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
            [self addChildViewController:fvc];
            [fvc.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [sv addSubview:fvc.view];
            [self.view bringSubviewToFront:sc];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
        }
    }
}

//===============================================//
-(void)cameraClick
{
    if ([ControllerManager getIsSuccess]) {
        if (sheet == nil) {
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
            }
            else {
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            
            sheet.tag = 255;
            
        }else{
            
        }
        [sheet showInView:self.view];
    }else{
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
//        [vc autorelease];
    }
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        if ([self hasValidAPIKey]) {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    void(^completion)(void)  = ^(void){
        if (isCamara) {
            [self lauchEditorWithImage:image];
        }else{
            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (asset){
                    [self launchEditorWithAsset:asset];
                }
            } failureBlock:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }};
    
    [self dismissViewControllerAnimated:NO completion:completion];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    if ([kAFAviaryAPIKey isEqualToString:@"<YOUR-API-KEY>"] || [kAFAviarySecret isEqualToString:@"<YOUR-SECRET>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"You forgot to add your API key and secret!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark -图片编辑
#pragma mark =================================
#pragma mark - Photo Editor Launch Methods

//********************自己方法******************
-(void)lauchEditorWithImage:(UIImage *)image
{
    UIImage * editingResImage = image;
    UIImage * highResImage = image;
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

//*********************************************
- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block MainViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            //            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.oriImage = image;
    //    [[self imagePreviewView] setImage:image];
    //    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    
    //跳转到UploadViewController
    //    UploadViewController * vc = [[UploadViewController alloc] init];
    //    vc.oriImage = image;
    //    [self presentViewController:vc animated:YES completion:nil];
    
    //    NSLog(@"上传图片");
    //    [self postData:image];
    
    //    UINavigationController * nc = [ControllerManager shareManagerMyPet];
    //    MyPetViewController * vc = nc.viewControllers[0];
    //    vc.myBlock();
    
    [self dismissViewControllerAnimated:YES completion:^{
        //        UploadViewController * vc = [[UploadViewController alloc] init];
        PublishViewController * vc = [[PublishViewController alloc] init];
        vc.oriImage = image;
        //        vc.af = editor;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    int a = [[USER objectForKey:@"buttonIndex"] intValue];
    [self dismissViewControllerAnimated:YES completion:^{
        [self actionSheet:sheet clickedButtonAtIndex:a];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
