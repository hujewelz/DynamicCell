//
//  ViewController.m
//  DynamicCell
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "ViewController.h"
#import "Cell1.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableDictionary *offScreenCells;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 60;
    self.offScreenCells  =[NSMutableDictionary dictionary]; //存储离屏的cell, ios7下使用
    
    #ifdef IOS_8

    self.tableView.rowHeight = UITableViewAutomaticDimension; //ios8下使用
    
    #endif
    
    
    [self.tableView registerNib:[Cell1 nib] forCellReuseIdentifier:[Cell1 identifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)data {
    if (!_data) {
        NSArray *array = @[@"曾经有一个算命的人跟我说过，",
                           @"曾经有一个算命的人跟我说过，我是一个蓄财能力很强的人，这点没错。但我觉得真正的蓄财并不仅仅是省钱也不仅仅是赚钱，而是开源与节流并存的一种方式。",
                           @"我觉得赚钱最重要的就是找到一个空白的领域，用你的核心竞争力来赚钱，才会又快又稳又好。比如在大学的时候，我上过一个四级辅导班，因为当时是大一去上课的，基本上什么都听不懂，但我的优点是能够疯狂的把所有的笔记记得非常清楚。",
                           @"我毕业从实习的月薪1200块钱，毕业后第一份工作月薪3000元，而房子的首付要几十万。这些钱是如何赚来的呢？我觉得最重要的一点就是，一定要广泛的开源，什么钱都要去赚，不要嫌少。",
                           @"我的工资从开始一个月1200块钱开始，我就要求自己，下班后想办法去赚钱，别动工资卡。",
                           @"曾经有一个算命的人跟我说过，我是一个蓄财能力很强的人，这点没错。但我觉得真正的蓄财并不仅仅是省钱也不仅仅是赚钱，而是开源与节流并存的一种方式。",
                           @"我觉得赚钱最重要的就是找到一个空白的领域，用你的核心竞争力来赚钱，才会又快又稳又好。比如在大学的时候，我上过一个四级辅导班，因为当时是大一去上课的，基本上什么都听不懂，但我的优点是能够疯狂的把所有的笔记记得非常清楚。",
                           @"我毕业从实习的月薪1200块钱，毕业后第一份工作月薪3000元，而房子的首付要几十万。这些钱是如何赚来的呢？我觉得最重要的一点就是，一定要广泛的开源，什么钱都要去赚，不要嫌少。",
                           @"我的工资从开始一个月1200块钱开始，我就要求自己，下班后想办法去赚钱，别动工资卡。"];
        _data = [NSArray arrayWithArray:array];
    }
    return _data;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:[Cell1 identifier] forIndexPath:indexPath];
    
    cell1.textLab.text = self.data[indexPath.row];

    return cell1;
}

#ifndef IOS_8

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [Cell1 identifier];
    Cell1 *cell1 = self.offScreenCells[identifier];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"Cell1" owner:nil options:nil] lastObject];
        self.offScreenCells[identifier] = cell1;
    }
    cell1.textLab.text = self.data[indexPath.row];
    
    [cell1 setNeedsUpdateConstraints];
    [cell1 updateConstraintsIfNeeded];
    
    CGFloat height = [cell1.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height + 1;
}

#endif
@end
