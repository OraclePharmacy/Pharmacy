//
//  TianTableViewCell.m
//  MyYaoBao
//
//  Created by ll on 15/6/12.
//  Copyright (c) 2015年 aipuyifeng. All rights reserved.
//

#import "TianTableViewCell.h"

@implementation TianTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        self.botline=[[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
        self.botline.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:self.botline];
        
        self.add=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 200, 30)];
        
        [self addSubview:self.add];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
