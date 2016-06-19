//
//  GetImageAndVideo.h
//  从相册中获取图片和视频
//
//  Created by tusm on 16/6/17.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ViewController;
@interface GetImageAndVideo : UIViewController

@property (nonatomic,retain)NSMutableArray *imageMA;         //存储相册中的照片
@property (nonatomic,retain)NSMutableArray *viduoMA;         //存储相册中的视频文件
@property (nonatomic,retain)NSMutableArray *imageForViduo;   //存储由视频生成的占位图
@property (nonatomic,retain)AVPlayer       *leftPlayer;      //左边播放器
@property (nonatomic,retain)AVPlayer       *righrPlayer;     //右边播放器

- (void)getImageAndVidoeFormLibrary;                         //得到系统相册中的视频文件并生成占位图片
- (void)leftTableViewSelectCellPlayer:(NSURL *)url viewController:(ViewController *)viewController;  //左侧tableview播放方法
- (void)rightTableViewSelectCellPlayer:(NSURL *)url viewController:(ViewController *)viewController; //右侧tableview播放方法
- (void)syntheticVideo;
- (void)saveSynthetic;
@end
