//
//  FilterCell.m
//  dd
//
//  Created by Sasi on 28/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FilterModel *)model {
    _model = model;
    self._lblTitle.text = _model.title;
    self._txtField.placeholder = _model.placeHolder;
}
@end
