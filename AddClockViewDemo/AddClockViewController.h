//
//  AddClockViewController.h
//  AddClockViewDemo
//
//  Created by hoyifo on 2018/12/21.
//  Copyright © 2018 hoyifo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewModel.h"
@interface AddClockViewController : UITableViewController

@property (nonatomic, copy) void(^block)(ClockModel *model);

@property (nonatomic, copy) ClockModel *model;

@end
