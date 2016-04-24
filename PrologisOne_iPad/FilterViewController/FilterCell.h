//
//  FilterCell.h
//  dd
//
//  Created by Sasi on 28/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"

@protocol FilterCellProtocol <NSObject>
@end
@interface FilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *_lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *_txtField;
@property (nonatomic, strong) FilterModel *model;
@property (nonatomic,assign)id <FilterCellProtocol>delegate;
@end
