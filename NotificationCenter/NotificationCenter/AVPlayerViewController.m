//
//  AVPlayerViewController.m
//  NotificationCenter
//
//  Created by admin on 15/02/2017.
//  Copyright © 2017 admin. All rights reserved.
//

#import "AVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#define TranslucentGrayColor [UIColor colorWithRed:53.1/255.0 green:45.2/255.0 blue:37.3/255.0 alpha:0.2]
#define Picture(pictureName) UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)?[UIImage imageNamed:pictureName]:[UIImage imageNamed:[NSString stringWithFormat:@"%@-2",pictureName]]

@interface AVPlayerViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIView *toolBarTop;
@property (nonatomic, strong) UIView *toolBarBottom;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIView *playBtnBackView;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UISlider *soundSlider;
@end

@implementation AVPlayerViewController
#pragma mark 懒加载
- (UIView *)playView {
    if (!_playView) {
        CGRect rect = CGRectZero;
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            rect = CGRectMake(0, 20, self.view.frame.size.width, 200);
        }else {
            rect = self.view.frame;
        }
        self.playView = [[UIView alloc]initWithFrame:rect];
        _playView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSubviewOfPlayView)];
        [_playView addGestureRecognizer:tap];
    }
    return _playView;
}

- (UIView *)toolBarTop {
    if (!_toolBarTop) {
        CGRect rect = CGRectZero;
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
            self.backBtn.frame = CGRectMake(5, 0, 30, 30);
        }else {
            rect = CGRectMake(0, 0, self.view.frame.size.width, 50);
            self.backBtn.frame = CGRectMake(5, 0, 50, 50);
        }
        [self.backBtn setImage:Picture(@"back") forState:UIControlStateNormal];
        self.toolBarTop = [[UIView alloc]initWithFrame:rect];
        _toolBarTop.backgroundColor = TranslucentGrayColor;
    }
    return _toolBarTop;
}

- (UIView *)toolBarBottom {
    if (!_toolBarBottom) {
        CGRect rect = CGRectZero;
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            rect = CGRectMake(0, 150, self.view.frame.size.width, 50);
        }else {
            rect = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
        }
        self.toolBarBottom = [[UIView alloc]initWithFrame:rect];
        _toolBarBottom.backgroundColor = TranslucentGrayColor;

    }
    return _toolBarBottom;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (UIButton *)playPauseBtn {
    if (!_playPauseBtn) {
        _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = CGRectZero;
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            rect = CGRectMake(self.view.frame.size.width-70, 100, 30, 30);
        }else {
            rect = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height-150, 50, 50);
        }
        [_playPauseBtn setImage:Picture(@"play") forState:UIControlStateNormal];
        _playPauseBtn.frame = rect;
        [_playPauseBtn addTarget:self action:@selector(playPauseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playPauseBtn;
}

- (UIView *)playBtnBackView {
    if (!_playBtnBackView) {
        _playBtnBackView = [UIView new];
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            _playBtnBackView.frame = CGRectMake(CGRectGetMinX(self.playPauseBtn.frame)-20, CGRectGetMinY(self.playPauseBtn.frame)-10, 70, 50);
        }else {
            _playBtnBackView.frame = CGRectMake(CGRectGetMinX(self.playPauseBtn.frame)-20, CGRectGetMinY(self.playPauseBtn.frame)-10, 90, 70);
        }
        _playBtnBackView.backgroundColor = TranslucentGrayColor;
    }
    return _playBtnBackView;
}

- (UIImageView *)playImageV {
    if (!_playImageV) {
        _playImageV = [UIImageView new];
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            _playImageV.frame = CGRectMake(10, 10, 30, 30);
        }else {
            _playImageV.frame = CGRectMake(10, 10, 50, 50);
        }
        _playImageV.image = Picture(@"playI");
    }
    return _playImageV;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [UISlider new];
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            _progressSlider.frame = CGRectMake(50, 10, 150, 30);
        }else {
            _progressSlider.frame = CGRectMake(70, 10, 250, 50);
        }
        [_progressSlider setThumbImage:Picture(@"player_slider_dot") forState:UIControlStateNormal];
    }
    return _progressSlider;
}

- (UISlider *)soundSlider {
    if (!_soundSlider) {
        _soundSlider = [UISlider new];
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            _soundSlider.frame = CGRectMake(210, 10, 70, 30);
        }else {
            _soundSlider.frame = CGRectMake(330, 10, 100, 50);
        }
        [_soundSlider setThumbImage:Picture(@"player_slider_dot") forState:UIControlStateNormal];
    }
    return _soundSlider;
}

#pragma mark-
- (void)playPauseAction {
    if (self.isPlaying) {
        self.isPlaying = NO;
        [self pause];
    }else {
        self.isPlaying = YES;
        [self play];
    }
}

- (void)play {
    [self.player play];
    [_playPauseBtn setImage:Picture(@"pause") forState:UIControlStateNormal];
    self.playImageV.image = Picture(@"pauseI");
    [self performSelector:@selector(hideSubviewOfPlayView) withObject:nil afterDelay:3];
}

- (void)hideSubviewOfPlayView {
    self.toolBarTop.hidden = YES;
    self.toolBarBottom.hidden = YES;
    self.playPauseBtn.hidden = YES;
    self.playBtnBackView.hidden = YES;
}

- (void)showSubviewOfPlayView {
    self.toolBarTop.hidden = NO;
    self.toolBarBottom.hidden = NO;
    self.playPauseBtn.hidden = NO;
    self.playBtnBackView.hidden = NO;
    if (self.isPlaying) {
        [self performSelector:@selector(hideSubviewOfPlayView) withObject:nil afterDelay:3];
    }
}

- (void)pause {
    [self.player pause];
    [_playPauseBtn setImage:Picture(@"play") forState:UIControlStateNormal];
    self.playImageV.image = Picture(@"playI");
    if ([self respondsToSelector:@selector(performSelector:withObject:afterDelay:)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSubviewOfPlayView) object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self uploadUI];
    self.isPlaying = NO;
}

- (void)uploadUI {
    [self.playView addSubview:self.toolBarTop];
    [self.playView addSubview:self.toolBarBottom];
    [self.toolBarTop addSubview:self.backBtn];
    [self.playView addSubview:self.playBtnBackView];
    [self.playView addSubview:self.playPauseBtn];
    [self.toolBarBottom addSubview:self.playImageV];
    [self.toolBarBottom addSubview:self.progressSlider];
    [self.toolBarBottom addSubview:self.soundSlider];
}

- (void)turnOrientation:(NSNotification *)notification {
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.playView.frame = CGRectMake(0, 20, self.view.frame.size.width, 200);
        self.toolBarTop.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        self.toolBarBottom.frame = CGRectMake(0, 150, self.view.frame.size.width, 50);
        self.backBtn.frame = CGRectMake(5, 0, 30, 30);
        _playBtnBackView.frame = CGRectMake(self.view.frame.size.width-90, 90, 70, 50);
        self.playPauseBtn.frame = CGRectMake(self.view.frame.size.width-70, 100, 30, 30);
        self.playImageV.frame = CGRectMake(10, 10, 30, 30);
        _soundSlider.frame = CGRectMake(210, 10, 70, 30);
        _progressSlider.frame = CGRectMake(50, 10, 150, 30);
    }else {
        self.playView.frame = self.view.frame;
        self.toolBarTop.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        self.toolBarBottom.frame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
        self.backBtn.frame = CGRectMake(5, 0, 50, 50);
        _playBtnBackView.frame = CGRectMake(self.view.frame.size.width-110, self.view.frame.size.height-160, 90, 70);
        self.playPauseBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height-150, 50, 50);
        self.playImageV.frame = CGRectMake(10, 10, 50, 50);
        _soundSlider.frame = CGRectMake(330, 10, 100, 50);
        _progressSlider.frame = CGRectMake(70, 10, 250, 50);
    }

    self.isPlaying ? [self.playPauseBtn setImage:Picture(@"pause") forState:UIControlStateNormal] : [self.playPauseBtn setImage:Picture(@"play") forState:UIControlStateNormal];
    [self.backBtn setImage:Picture(@"back") forState:UIControlStateNormal];
    self.playImageV.image = Picture(@"playI");
    [self.soundSlider setThumbImage:Picture(@"player_slider_dot") forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:Picture(@"player_slider_dot") forState:UIControlStateNormal];
}

- (void)playMovieWithURL:(NSURL *)url {
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playView.layer addSublayer:self.playerLayer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
