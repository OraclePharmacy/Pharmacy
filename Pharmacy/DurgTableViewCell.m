//
//  DurgTableViewCell.m
//  MyYaoBao
//
//  Created by ll on 15/6/12.
//  Copyright (c) 2015年 aipuyifeng. All rights reserved.
//

#import "DurgTableViewCell.h"

@implementation DurgTableViewCell{
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.topline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _width1, 1)];
        self.topline.backgroundColor=[UIColor lightGrayColor];
        
        self.botline=[[UIView alloc] initWithFrame:CGRectMake(0, 79, _width1, 1)];
        self.botline.backgroundColor=[UIColor lightGrayColor];
        
        [self addSubview:self.topline];
        
        [self addSubview:self.botline];
        
        //一日次数
        self.ll1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 100, 20)];
        
        [self addSubview:self.ll1];
        
        //闹钟图片
        self.nao = [[UIImageView alloc]initWithFrame:CGRectMake(16, 50, 10, 10)];
        self.nao.image = [UIImage imageNamed:@"icon_notice_time.png"];
        [self addSubview:self.nao];
        //detail
        self.ll2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 40, 160, 30)];
        //self.ll2.text = @"药品名称";
        self.ll2.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.ll2];
        
        // 开关
        
        self.sw=[[UISwitch alloc] initWithFrame:CGRectMake(_width1-46, 30, 30, 20)];
        
        [self addSubview:self.sw];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
