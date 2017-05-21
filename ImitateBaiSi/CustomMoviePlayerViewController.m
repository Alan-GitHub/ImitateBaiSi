//
//  HYHPlayVideoController.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

//#import "HYHPlayVideoController.h"
//
//@implementation HYHPlayVideoController
//
//
//@end
#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

@synthesize mediaURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadingAni = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 150, 37, 37)];
    loadingAni.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:loadingAni];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(130, 190, 80, 40)];
    label.text = @"加载中...";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    [loadingAni startAnimating];
    [self.view addSubview:label];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    // Register that the load state changed (movie is ready)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}


- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
//    NSLog(@"[mp movieMediaTypes]=%ld", [mp movieMediaTypes]);
//    NSLog(@"MPMovieMediaTypeMaskAudio=%ld", MPMovieMediaTypeMaskAudio);
//    NSLog(@"MPMovieMediaTypeMaskVideo=%ld",MPMovieMediaTypeMaskVideo);
    [loadingAni stopAnimating];
    [label removeFromSuperview];
    
    // Unless state is unknown, start playback
    if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        //设置横屏
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        
        /*
        // Rotate the view for landscape playback
        [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
        [[self view] setCenter:CGPointMake(160, 240)];
        //选中当前view
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
        // Set frame of movieplayer
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        */
        
        // Rotate the view for landscape playback
        [[self view] setBounds:[UIScreen mainScreen].bounds];
        
        // Set frame of movieplayer
        [[mp view] setFrame:[UIScreen mainScreen].bounds];
        
        
        // Add movie player as subview
        [[self view] addSubview:[mp view]];
        
//        if(MPMovieMediaTypeMaskAudio == [mp movieMediaTypes])
//        {
//            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(10, 64, 70, 40);
//            btn.backgroundColor = [UIColor redColor];
//            [btn setTitle:@"back" forState:UIControlStateNormal];
//            
//            [btn addTarget:self action:@selector(back) forControlEvents:UIControlStateNormal | UIControlStateSelected];
//            
//            [self.view addSubview:btn];
//        }
        
        
        // Play the movie
        [mp play];
    }
}

//- (void) back
//{
//    NSLog(@"backbackbackback");
//}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //还原状态栏为默认状态
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    
    [self dismissModalViewControllerAnimated:NO];
}


- (void) readyPlayer
{
    mp = [[MPMoviePlayerController alloc] initWithContentURL:mediaURL];
    
    if ([mp respondsToSelector:@selector(loadState)])
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen]; //MPMovieControlStyleFullscreen //MPMovieControlStyleEmbedded
        //满屏
        [mp setFullscreen:YES];
        // 有助于减少延迟
        [mp prepareToPlay];
    } 
    else 
    { 
        // Play the movie For 3.1.x devices 
        [mp play]; 
    }
}

@end