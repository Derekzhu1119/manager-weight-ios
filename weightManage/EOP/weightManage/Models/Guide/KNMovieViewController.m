//
//  KNMovieViewController.m
//  KNStartMovie
//
//  Created by 刘凡 on 2017/10/9.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface KNMovieViewController ()

@property(nonatomic,strong)UIImageView *bgImageView;

//播放器ViewController
@property(nonatomic, strong)AVPlayerViewController *AVPlayer;

@end

@implementation KNMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgImageView.image = [UIImage imageNamed:[self getLaunchImageName]];
    //初始化AVPlayer
    [self setMoviePlayer];
}

-(void)setMoviePlayer{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"start" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];

    
    //初始化AVPlayer
    self.AVPlayer = [[AVPlayerViewController alloc]init];
    //多分屏功能取消
    self.AVPlayer.allowsPictureInPicturePlayback = NO;
    //设置是否显示媒体播放组件
    self.AVPlayer.showsPlaybackControls = false;
    
    //初始化一个播放单位。给AVplayer 使用
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];

    //layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    [layer setFrame:[UIScreen mainScreen].bounds];
    //设置填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.AVPlayer.player = player;
    //添加到self.view上面去
    [self.view.layer addSublayer:layer];
    //开始播放
    [self.AVPlayer.player play];
    
    
    
    //这里设置的是重复播放。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFailed:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:item];


}


//播放完成的代理
- (void)playDidEnd:(NSNotification *)Notification{
    //播放完成后。设置播放进度为0 。 重新播放
//    [self.AVPlayer.player seekToTime:CMTimeMake(0, 1)];
//    //开始播放
//    [self.AVPlayer.player play];
    [self.bgImageView removeFromSuperview];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self enterMainAction:nav];
}

- (void)playFailed:(NSNotification *)Notification{
    
    
}



- (void)enterMainAction:(UINavigationController *)rootViewController {
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

- (NSString *)getLaunchImageName {
    NSString *launchImageName = nil;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    if ([infoDic objectForKey:@"UILaunchImages"]
        && [[infoDic objectForKey:@"UILaunchImages"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *launchImageDic in [infoDic objectForKey:@"UILaunchImages"]) {
            CGSize size = CGSizeFromString(launchImageDic[@"UILaunchImageSize"]);
            if (UIScreenHeight == size.height) {
                launchImageName = launchImageDic[@"UILaunchImageName"];
                break;
            }
        }
    }
    return launchImageName;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}


@end
