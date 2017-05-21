//
//  HYHPlayVideoController.m
//  ImitateBaiSi
//
//  Created by Alan.Turing on 17/5/4.
//  Copyright © 2017年 HYH. All rights reserved.
//

#import "HYHPlayVideoController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HYHTopic.h"

@implementation HYHPlayVideoController


- (void)viewDidLoad
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlay) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];


}


- (void) goBack
{


}

- (void) startPlay
{
    MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString: _topic.videouri]];
    
    
    [mp play];
}

@end
