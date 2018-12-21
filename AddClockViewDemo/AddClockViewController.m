//
//  AddClockViewController.m
//  AddClockViewDemo
//
//  Created by hoyifo on 2018/12/21.
//  Copyright © 2018 hoyifo. All rights reserved.
//

#import "AddClockViewController.h"
#import "BaseTableViewController.h"
#import "WeekDayCollectionViewCell.h"
#import "Monday_Model.h"
#import <Masonry.h>

#define mStarColor [UIColor colorWithRed:0.1176 green:0.7294 blue:0.9255 alpha:1.0]
#define mBackColor [UIColor colorWithRed:0.2323 green:0.2323 blue:0.2323 alpha:0.370770474137931]
#define myScale [UIScreen mainScreen].bounds.size.width / 414


@interface AddClockViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
// 记录 定时周期
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@property (nonatomic, strong) UICollectionView *dayCollectionView;
/**
 *  周期View
 */
@property (nonatomic, strong) UIView *cycleView;
@property (nonatomic, strong) UILabel *cycleLable;

@property (nonatomic, strong) UIButton *weekendayBt;
@property (nonatomic, strong) UIButton *everydayBt;
@property (nonatomic, strong) UIButton *workdayBt;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSMutableString *dayStr;

@property (nonatomic, assign) BOOL isWorkDay;
@property (nonatomic, assign) BOOL isEveryDay;
@property (nonatomic, assign) BOOL isWeekDay;

@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayArray = [NSMutableArray array];
    NSArray  *dayArr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    
    for (int i = 0; i < 7; i ++) {
        Monday_Model *monday = [[Monday_Model alloc] init];
        monday.day = dayArr[i];
        monday.isSelect = NO;
        [self.dayArray addObject:monday];
    }
    self.tableView.tableFooterView = [UIView new];
    
    [self.dataPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.dataPicker.backgroundColor = [UIColor blackColor];
    
    [self or_reloadData];
    
    
    [self creatCycleView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView reloadData];
    
}

- (void)or_reloadData {
    
    if (!_model) {
        _model = [ClockModel new];
    }else {
        self.dataPicker.date = _model.date;
        self.repeatLabel.text = _model.repeatStr;
        
    }
    
    [self.tableView reloadData];
}



- (IBAction)action_saveBtn:(id)sender {
    
    self.model.date = _dataPicker.date;
    
    _model.repeatStr = _repeatLabel.text;
    if (self.block) {
        self.block(_model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BaseTableViewController *baseVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"repeatVC"]) {
        baseVC.block = ^(NSArray *repeats) {
            self.model.repeatStrs = repeats;
            self.repeatLabel.text = [NSString stringWithFormat:@"%@",self.model.repeatStr];
        };
        baseVC.data = self.model.repeatStrs;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setModel:(ClockModel *)model {
    _model = model;
    [self or_reloadData];
}


#pragma mark - 创建时间的collectionView
- (void)creatDayCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - 21) / 7, 35);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   
    
   
    self.dayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 420, self.view.frame.size.width - 10, 35) collectionViewLayout:flowLayout];
    
    [self.dayCollectionView registerClass:[WeekDayCollectionViewCell class] forCellWithReuseIdentifier:@"WeekDayCollectionViewCellIdentifier"];
    
    self.dayCollectionView.delegate = self;
    self.dayCollectionView.dataSource = self;
    self.dayCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.dayCollectionView];

    
    
    
    
    
}
#pragma mark - 创建周期View
- (void)creatCycleView {
    self.cycleView = [[UIView alloc] init];
    self.cycleView.backgroundColor = mBackColor;
    self.cycleView.layer.masksToBounds = YES;
    [self.cycleView.layer setCornerRadius:5.0];
    [self.view addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@81);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.cycleLable = [[UILabel alloc] init];
    self.cycleLable.text = @"周期:";
    self.cycleLable.textColor = [UIColor whiteColor];
    [self.cycleView addSubview:self.cycleLable];
    [self.cycleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(2);
        make.left.equalTo(self.cycleView).offset(5);
        make.size.mas_offset(CGSizeMake(50, 35));
    }];
    
    UIView *separatView = [[UIView alloc] init];
    separatView.backgroundColor = [UIColor whiteColor];
    [self.cycleView addSubview:separatView];
    [separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cycleView).offset(-10);
        make.left.equalTo(self.cycleView).offset(10);
        make.height.equalTo(@1);
        make.centerY.equalTo(self.cycleView.mas_centerY);
    }];
    [self creatButton];
}

#pragma mark - 创建时间周期button  周末 工作日 每天
- (void)creatButton {
    self.workdayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.workdayBt setTitle:@"工作日" forState:UIControlStateNormal];
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.workdayBt addTarget:self action:@selector(gongzuoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleView addSubview:self.workdayBt];
    [self.workdayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.cycleView).offset(0);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    
    self.everydayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.everydayBt setTitle:@"每日" forState:UIControlStateNormal];
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.everydayBt addTarget:self action:@selector(everydayAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cycleView addSubview:self.everydayBt];
    [self.everydayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.workdayBt.mas_left).offset(5);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    
    self.weekendayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.weekendayBt setTitle:@"周末" forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt addTarget:self action:@selector(weekendayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleView addSubview:self.weekendayBt];
    [self.weekendayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.everydayBt.mas_left).offset(5);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    [self creatDayCollectionView];
}

#pragma mark - 工作日点击事件
- (void)gongzuoAction {
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWeekDay = NO;
    _isEveryDay = NO;
    if (_isWorkDay == YES) {
        for (int i = 0; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = NO;
    } else {
        
        for (int i = 0; i < 5; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        for (int i = 5; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.workdayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        
        _isWorkDay = YES;
    }
    
    [self.dayCollectionView reloadData];
}

#pragma maek - 周末的点击事件
- (void)weekendayAction {
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWorkDay = NO;
    _isEveryDay = NO;
    if (_isWeekDay == YES) {
        for (int i = 0; i < 7; i++) {
            Monday_Model * model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWeekDay = NO;
    }else{
        for (int i = 5; i < 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        
        for (int i = 0; i < 5; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.weekendayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        
        _isWeekDay = YES;
        
    }
    
    [self.dayCollectionView reloadData];
}

#pragma mark - 每天的点击事件
- (void)everydayAction {
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWorkDay = NO;
    _isWeekDay = NO;
    if (_isEveryDay == YES) {
        for (int i = 0; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isEveryDay = NO;
    } else {
        
        for (int i = 0; i < 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        [self.everydayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        
        _isEveryDay = YES;
    }
    [self.dayCollectionView reloadData];
}

#pragma makr - 时间collecttionView的代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeekDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekDayCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    Monday_Model *model = _dayArray[indexPath.item];
    
    if (model.isSelect == YES) {
        cell.titileLabel.textColor = mStarColor;
    } else {
        cell.titileLabel.textColor = [UIColor whiteColor];
    }
    
    cell.titileLabel.text = model.day;
    
    return cell;
}


#pragma mark - 添加星期的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Monday_Model *model = _dayArray[indexPath.item];
    if (self.dayStr.length == 0) {
        self.dayStr = [NSMutableString stringWithCapacity:0];
    }
    if (model.isSelect) {
        NSRange range = [self.dayStr rangeOfString:model.day];
        [self.dayStr deleteCharactersInRange:range];
        model.isSelect = NO;
    } else {
        model.isSelect = YES;
        [self.dayStr insertString:model.day atIndex:self.dayStr.length];
    }
    [self.dayCollectionView reloadData];
    NSLog(@"点击：%@", self.dayStr);
    [self changeButtonColor];
    
}
- (void)changeButtonColor {
    NSString *str1 = @"一";
    NSString *str2 = @"二";
    NSString *str3 = @"三";
    NSString *str4 = @"四";
    NSString *str5 = @"五";
    NSString *str6 = @"六";
    NSString *str7 = @"日";
    NSRange range1 = [self.dayStr rangeOfString:str1];
    NSRange range2 = [self.dayStr rangeOfString:str2];
    NSRange range3 = [self.dayStr rangeOfString:str3];
    NSRange range4 = [self.dayStr rangeOfString:str4];
    NSRange range5 = [self.dayStr rangeOfString:str5];
    NSRange range6 = [self.dayStr rangeOfString:str6];
    NSRange range7 = [self.dayStr rangeOfString:str7];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (range1.length != 0) {
        [str insertString:@"周一" atIndex:str.length];
    }
    if (range2.length != 0) {
        [str insertString:@"周二" atIndex:str.length];
    }
    if (range3.length != 0) {
        [str insertString:@"周三" atIndex:str.length];
    }
    if (range4.length != 0) {
        [str insertString:@"周四" atIndex:str.length];
    }
    if (range5.length != 0) {
        [str insertString:@"周五" atIndex:str.length];
    }
    if (range6.length != 0) {
        [str insertString:@"周六" atIndex:str.length];
    }
    if (range7.length != 0) {
        [str insertString:@"周日" atIndex:str.length];
    }
    
    self.dayStr = [NSMutableString stringWithString:str];
    
    if (range1.length != 0 && range2.length != 0 && range3.length != 0 && range4.length != 0 && range5.length != 0 && range6.length == 0 && range7.length == 0) {
        [self.workdayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = YES;
        _isWeekDay = NO;
        _isEveryDay = NO;
    } else if (range1.length != 0 && range2.length != 0 && range3.length != 0 && range4.length != 0 && range5.length != 0 && range6.length != 0 && range7.length != 0) {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = NO;
        _isEveryDay = YES;
    } else if (range1.length == 0 && range2.length == 0 && range3.length == 0 && range4.length == 0 && range5.length == 0 && range6.length != 0 && range7.length != 0) {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = YES;
        _isEveryDay = NO;
    } else {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = NO;
        _isEveryDay = NO;
    }
    
}






@end
