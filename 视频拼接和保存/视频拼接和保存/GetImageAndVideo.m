//
//  GetImageAndVideo.m
//  从相册中获取图片和视频
//
//  Created by tusm on 16/6/17.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import "GetImageAndVideo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"

@interface GetImageAndVideo ()


@property (nonatomic,retain)AVAsset               *leftAsset;     //左边视频容器
@property (nonatomic,retain)AVAsset               *rightAsset;    //右边视频容器
@property (nonatomic,retain)ViewController        *viewVC;
@property (nonatomic,retain)AVAssetExportSession  *exprot;        //用于导出
@property (nonatomic,retain)AVMutableComposition  *composition;   //轨道配置
@property (nonatomic,retain)AVPlayerItem          *leftPlayerItem;
@property (nonatomic,retain)AVPlayerLayer         *leftPlayerLayer;
@property (nonatomic,retain)AVPlayerLayer         *rightPlayerLayer;
@property (nonatomic,retain)AVPlayerItem          *rightPlayerItem;
@end

@implementation GetImageAndVideo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getImageAndVidoeFormLibrary];
    }
    return self;
}

//得到相册中的视频文件的url
- (void)getImageAndVidoeFormLibrary {
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];   //生成整个photolibrary实例
    
    __block NSInteger v=0;
    __block NSInteger p;
    __block NSInteger g=0;
    self.imageMA = [NSMutableArray array];
    self.imageForViduo = [NSMutableArray array];
    NSMutableArray *assetURLDictionaries = [NSMutableArray array];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        NSLog(@"ALAssetsGroupSavedPhotos===%@",group);
        NSString* groupname = [group valueForProperty:ALAssetsGroupPropertyName];
        NSLog(@"groupname--%@",groupname);

        //对组进行遍历，筛选分类
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            NSString* type = [result valueForProperty:ALAssetPropertyType];
            
            
            if ([type isEqualToString:ALAssetTypePhoto]) {
      
                //图片
            }else if([type isEqualToString:ALAssetTypeVideo]){
             
                //保存视频URL
                NSLog(@"ALAssetTypeVideo-----%ld",++v);
                ALAssetRepresentation *representation = [result defaultRepresentation];
                NSURL *url = [representation url];
                NSLog(@"%@",url);
                [self.imageMA addObject:url];
                [self generateIamgeForViodeWithURL:url];
                
                
                //                    long long size = representation.size;
                //                    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:size];
                //                    void* buffer = [data mutableBytes];
                //                    [representation getBytes:buffer fromOffset:0 length:size error:nil];
                //                    NSData *fileData = [[NSData alloc] initWithBytes:buffer length:size];
                //
                //
                //                NSDate *  senddate=[NSDate date];
                //
                //                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                //
                //                [dateformatter setDateFormat:@"YYYYMMdd"];
                //
                //                NSString *  locationString=[dateformatter stringFromDate:senddate];
                //
                //                    //File URL
                //                    NSString *savePath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@",locationString]], representation.filename];
                //                    [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
                //
                //                
                //                
                //                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)   {
                //                        [fileData writeToFile:savePath atomically:NO];
                //                        
                //                    });

            }else if([type isEqualToString:ALAssetTypeUnknown]){
                
                NSLog(@"Unknow AssetType");
            }
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
    
}


//根据录制视频生成一张视频的展示图
- (void)generateIamgeForViodeWithURL:(NSURL *)url {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
            //容器，根据地址获取到视频流
            AVAsset *sesst = [AVAsset assetWithURL:url];
            AVAssetImageGenerator * generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:sesst];
            //图片大小
            generator.maximumSize = CGSizeMake(100, 0.0f);
            generator.appliesPreferredTrackTransform = YES;
            //转换
            CGImageRef imageRef = [generator copyCGImageAtTime:kCMTimeZero actualTime:NULL error:nil];
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image) {
                    [self.imageForViduo addObject:image];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nihao" object:nil];
            });
        
    });
}

//左边table播放方法
- (void)leftTableViewSelectCellPlayer:(NSURL *)url viewController:(ViewController *)viewController {
    
    [self.leftPlayer pause];
    self.leftPlayerItem = nil;
    [self.leftPlayerLayer removeFromSuperlayer];
    
    self.viewVC = viewController;
    self.leftAsset       = [AVAsset assetWithURL:url];
    self.leftPlayerItem  = [AVPlayerItem playerItemWithAsset:self.leftAsset];
    self.leftPlayer      = [[AVPlayer alloc]initWithPlayerItem:self.leftPlayerItem];
    [self.leftPlayer replaceCurrentItemWithPlayerItem:self.leftPlayerItem];
    
    self.leftPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.leftPlayer];
    self.leftPlayerLayer.frame      = CGRectMake(0, 0, 100, 100);
    self.leftPlayerLayer.videoGravity = AVLayerVideoGravityResize;

    [viewController.leftTableViewPlayer.layer addSublayer:self.leftPlayerLayer];
    [self.leftPlayer play];

}

//右边table播放方法
- (void)rightTableViewSelectCellPlayer:(NSURL *)url viewController:(ViewController *)viewController {
    
    [self.righrPlayer pause];
    self.rightPlayerItem  = nil;
    [self.rightPlayerLayer removeFromSuperlayer];
    
    self.rightAsset       = [AVAsset assetWithURL:url];
    self.rightPlayerItem  = [AVPlayerItem playerItemWithAsset:self.rightAsset];
    self.righrPlayer      = [[AVPlayer alloc]init];
    [self.righrPlayer replaceCurrentItemWithPlayerItem:self.rightPlayerItem];
    self.rightPlayerLayer  = [AVPlayerLayer playerLayerWithPlayer:self.righrPlayer];
    self.rightPlayerLayer.frame      = CGRectMake(0, 0, 100, 100);
    [viewController.rightTableViewPlayer.layer addSublayer:self.rightPlayerLayer];
    self.rightPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.righrPlayer play];
}

//合成方法
- (void)syntheticVideo {
    
    NSInteger leftST = [self.viewVC.leftstartTime.text intValue];
    NSInteger leftET = [self.viewVC.leftEndStartTime.text intValue]-leftST;
    NSInteger rightST = [self.viewVC.rightstartTime.text intValue];
    NSInteger rightET = [self.viewVC.rigntEndTime.text intValue]-rightST;
    
    //对输入时间进行简单判断
    if (leftST > leftET || rightST > rightET || rightET == 0 || leftET == 0) {
        
        [self alerViewShowMessage:@"输入的时间有问题"];
        return;
    }
    
    //音视频截取、拼接
    if (self.leftAsset && self.rightAsset) {  //判断是输入截取视频
        
        NSLog(@"%ld,%ld,%ld,%ld",leftST,leftET,rightST,rightET);
        
        
        //左侧截取时间配置
        CMTime leftTimeStart = CMTimeMake(leftST, 1);
        CMTime leftTimeEnd   = CMTimeMake(leftET, 1);
        CMTimeRange leftRangee = CMTimeRangeMake(leftTimeStart, leftTimeEnd);
        
        //右侧视频截取时间配置
        CMTime rightTimeStart  = CMTimeMake(rightST, 1);
        CMTime rightTimeEnd    = CMTimeMake(rightET, 1);
        CMTimeRange rightRange = CMTimeRangeMake(rightTimeStart, rightTimeEnd);
        
        //配置一个轨道容器
        AVAssetTrack *assetTrackVideo;
        AVAssetTrack *assetTrackAudio;
        CMTime cusorTime = kCMTimeZero;  //得到添加位置

        self.composition = [AVMutableComposition composition];  //创建轨道容器
        AVMutableCompositionTrack *videoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];       //创建配置视频轨道，并加入到轨道容器总
        AVMutableCompositionTrack *audioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];       //创建音频轨道，并加入到轨道容器中
        
        //得到音视频信息，截取并加入到对应的轨道中
        assetTrackVideo = [[self.leftAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];  //得到视频信息
        assetTrackAudio = [[self.leftAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [videoTrack insertTimeRange:leftRangee ofTrack:assetTrackVideo atTime:cusorTime error:nil];  //截取视频数据，并放入视频轨道中
        [audioTrack insertTimeRange:leftRangee ofTrack:assetTrackAudio atTime:cusorTime error:nil];  //截取音频数据，并放入音频轨道中
        
        //第二个视频截取，并放入轨道对应位置，实现拼接

        cusorTime = CMTimeAdd(cusorTime, leftTimeEnd);
        CMTimeShow(cusorTime);
        assetTrackVideo  = [[self.rightAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        assetTrackAudio  = [[self.rightAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        [videoTrack insertTimeRange:rightRange ofTrack:assetTrackVideo atTime:cusorTime error:nil];
        [audioTrack insertTimeRange:rightRange ofTrack:assetTrackAudio atTime:cusorTime error:nil];

        //播放拼接音频
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:[self.composition copy]];
        AVPlayer *player   = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame = self.viewVC.syntheticPlayerView.bounds;
        [self.viewVC.syntheticPlayerView.layer addSublayer:layer];
        [player play];

    }else {
        
        [self alerViewShowMessage:@"请至少选择一个播放视频，选择一个针对单个视频截取，两个为合成截取"];
    }
    
}

- (void)alerViewShowMessage:(NSString *)message {
    
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
}

//导出截取、拼接的视频数据
- (void)saveSynthetic {
    
    //初始化配置导出实例
    self.exprot = [AVAssetExportSession exportSessionWithAsset:[self.composition copy] presetName:AVAssetExportPresetHighestQuality];
    self.exprot.outputURL      = [self saveSynteticAdress];  //保存地址
    self.exprot.outputFileType = AVFileTypeMPEG4;            //格式
    
    [self.exprot exportAsynchronouslyWithCompletionHandler:^{   //导出完成后
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            AVAssetExportSessionStatus status = self.exprot.status;
            
            //将文件存入系统相册
            if (status == AVAssetExportSessionStatusCompleted) {
                
                [self writeExportedVideoToassetsLibrary];
            }else {
                
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"出现错误" message:@"saveSynthetic方法" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alerView show];
            }
        });
    }];
}

//获取沙盒路径存储到沙河中
- (NSURL *)saveSynteticAdress {
    
    NSString *filePath = nil;
    NSUInteger count = 0;
    do {
        
        filePath = NSTemporaryDirectory();
        NSString *numberString = count >0 ? [NSString stringWithFormat:@"-%li",(unsigned long) count ]: @" ";
        NSString *fileNameString = [NSString stringWithFormat:@"Masterpiece-%@.mov",numberString];
        filePath = [filePath stringByAppendingPathComponent:fileNameString];
        count++;
    }while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
        
        return [NSURL fileURLWithPath:filePath];
    
}

//将合成写入照片库中
- (void)writeExportedVideoToassetsLibrary {
    
    NSURL *url = self.exprot.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url]) {
        
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            
            if (error) {
                
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"出现错误" message:@"问题出在保存中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alerView show];
            }else {
                
                [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
            
                [self alerViewShowMessage:@"已经保存到系统相册"];

            }
        }];
    }else {
        
        NSLog(@"保存失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
