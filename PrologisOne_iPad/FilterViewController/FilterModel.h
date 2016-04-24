//
//  FilterModel.h
//  dd
//
//  Created by Upendra on 29/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterModel : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)BOOL isDateField;
@property (nonatomic, strong)NSString *placeHolder;
@end
