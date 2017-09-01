//
//  PXTestTableViewCell.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXTestTableViewCell.h"
#import "PXTestTableViewCellReformerKeys.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PXTestTableViewCell ()

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *merchantNameLabel;

@end

@implementation PXTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.merchantNameLabel];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10).priorityHigh();
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@120);
        make.width.equalTo(@150);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(0);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.greaterThanOrEqualTo(self.contentView.mas_right).offset(-10);
    }];

    [self.merchantNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.greaterThanOrEqualTo(self.contentView.mas_right).offset(-10);
    }];
}

#pragma mark - getters and setters
- (void)setModel:(NSDictionary *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:_model[kTestReformerImage]];
    self.titleLabel.text = _model[kTestReformerTitle];
    self.merchantNameLabel.text = _model[kTestReformerMerchantName];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)merchantNameLabel {
    if (!_merchantNameLabel) {
        _merchantNameLabel = [[UILabel alloc] init];
    }
    return _merchantNameLabel;
}

@end
