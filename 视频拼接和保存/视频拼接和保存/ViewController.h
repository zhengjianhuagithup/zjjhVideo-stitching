//
//  ViewController.h
//  table
//
//  Created by tusm on 16/6/17.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *leftTableViewPlayer;
@property (weak, nonatomic) IBOutlet UITextField *leftstartTime;

@property (weak, nonatomic) IBOutlet UITextField *leftEndStartTime;
@property (weak, nonatomic) IBOutlet UITextField *rightstartTime;
@property (weak, nonatomic) IBOutlet UITextField *rigntEndTime;
@property (weak, nonatomic) IBOutlet UIView      *rightTableViewPlayer;
@property (weak, nonatomic) IBOutlet UIView      *syntheticPlayerView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

@end

