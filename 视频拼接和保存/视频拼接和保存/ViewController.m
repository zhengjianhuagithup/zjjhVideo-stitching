//
//  ViewController.m
//  table
//
//  Created by tusm on 16/6/17.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import "ViewController.h"
#import "GetImageAndVideo.h"
#import "CellForVideo.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) GetImageAndVideo    *get;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.get = [[GetImageAndVideo alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:@"nihao" object:nil];
    
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"CellForVideo" bundle:nil] forCellReuseIdentifier:@"CellForVideo"];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"CellForVideo" bundle:nil] forCellReuseIdentifier:@"CellForVideo"];
    
    //键盘样式
    self.leftEndStartTime.keyboardType = UIKeyboardTypeNumberPad;
    self.leftstartTime.keyboardType    = UIKeyboardTypeNumberPad;
    self.rigntEndTime.keyboardType     = UIKeyboardTypeNumberPad;
    self.rightstartTime.keyboardType   = UIKeyboardTypeNumberPad;

    //注册通知,监听键盘，实现输入框的上下动弹~~
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark ---键盘事件
- (void)keyboardAction:(NSNotification *)notif {
    
    //避免黑框出现，延迟更改页面位置
    [self performSelector:@selector(changeFrame) withObject:self afterDelay:0.3];
}

- (void)changeFrame {
    
    CGRect rect = self.view.frame;
    rect.origin.y = -286;
    self.view.frame =rect;

}

- (void)keyBoardHideAction:(NSNotification *)notifi {

    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
}

#pragma mark ---tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.get.imageForViduo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellForVideo *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForVideo" forIndexPath:indexPath];
    cell.myImage.image = self.get.imageForViduo[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

//实现点击cell播放对应位置的视频
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        
        [self.get leftTableViewSelectCellPlayer:self.get.imageMA[indexPath.row] viewController:self];
        NSLog(@"%@",self.get.imageMA[indexPath.row]);

    }else {
        
        [self.get rightTableViewSelectCellPlayer:self.get.imageMA[indexPath.row] viewController:self];
    }
}

#pragma mark --- button点击事件

- (IBAction)ayntheticBTAction:(UIButton *)sender {
    
    [self.get syntheticVideo];
}
- (IBAction)saveSyntheticBTAction:(UIButton *)sender {
    
    [self.get saveSynthetic];
}


//因为视频生成占位图片的方法中有异步执行，所以在异步执行完成后发送通知。让tableview上重新刷新视图
- (void)notificationAction {
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
