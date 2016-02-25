//
//  Cell1.h
//  DynamicCell
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import <UIKit/UIKit.h>

//要想在ios7下测试，注释掉以下三行代码即可，这只是在demo中演示才添加的

#ifndef IOS_8
#define IOS_8
#endif

@interface Cell1 : UITableViewCell

+ (UINib *)nib;
+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end
