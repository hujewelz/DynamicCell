//
//  Cell1.m
//  DynamicCell
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "Cell1.h"

@implementation Cell1

+ (UINib *)nib {
    return [UINib nibWithNibName:@"Cell1" bundle:nil];
}

+ (NSString *)identifier {
    return @"Cell1";
}

- (void)awakeFromNib {
    // Initialization code
    #ifndef IOS_8
    self.textLab.preferredMaxLayoutWidth = 250;
    #endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
