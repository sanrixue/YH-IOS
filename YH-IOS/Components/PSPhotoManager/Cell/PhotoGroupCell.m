//
//  PhotoGroupCell.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoGroupCell.h"
#import "PhotoManagerConfig.h"

static CGFloat const kGroupCellHeight = 60;

@interface PhotoGroupCell ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UILabel *photoNumberLabel;

@end

@implementation PhotoGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)reloadDataWithImage:(UIImage *)image groupName:(NSString *)groupName photoNumber:(NSInteger)photoNumber {
    self.thumbnailImageView.image = image;
    self.groupNameLabel.text = groupName;
    self.photoNumberLabel.text = Format(@"(%zd)", photoNumber);
}

+ (CGFloat)height {
    return kGroupCellHeight;
}

#pragma mark -
#pragma mark - privite methods
- (void)buildingUI {
    self.thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.backgroundColor = kPlaceholderImageColor;
    [self addSubview:_thumbnailImageView];
    
    self.groupNameLabel = building_label(1, [UIColor blackColor], 0, FontBold(17));
    [self addSubview:_groupNameLabel];
    
    self.photoNumberLabel = building_label(1, HEXCOLOR(0x7d7d7d), 0, Font(17));
    [self addSubview:_photoNumberLabel];
}

- (void)layoutUI {
    WeakSelf(self)
    
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kGroupCellHeight, kGroupCellHeight));
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.thumbnailImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.photoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.groupNameLabel.mas_right).offset(15);
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
