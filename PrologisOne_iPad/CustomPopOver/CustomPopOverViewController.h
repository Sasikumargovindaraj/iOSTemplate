//
// CustomPopOverViewController.h
//
//  Created by Gs on 20/03/15.
//  Copyright (c) 2015 Dr. All rights reserved.
//



#define CELL_HEIGHT 44
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CustomPopOverProtocol <NSObject>

@optional

- (void)itemSelected:(NSString*)strItemSelected;
- (void)itemSelected:(NSString*)strItemSelected  withIndex:(int)iIndex;
- (void)removeOnCancelButtonTap;
- (void)multiSelectionValues:(NSArray *)m_arrSelectedValues;

@end


@interface CustomPopOverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *m_tblPopOverContent;
    NSMutableArray *m_arrItems;
    float m_fTableViewHeight;
    CGSize tblSize;
    
}
@property (nonatomic, assign)id<CustomPopOverProtocol> m_dlgPopOver;
@property (nonatomic, strong) NSArray *m_arrDisplayItems;
@property (nonatomic,assign )   BOOL isMultiSelectPopOver;
@property (nonatomic,strong)    NSMutableArray *m_SelectedValues;
@property (nonatomic,assign ) NSString *m_PopOver_Title;
@property(nonatomic)BOOL isCacelBtnRequired;
@property(nonatomic)BOOL isCellSelectionBtnRequired;
@property(nonatomic)BOOL isDoneBtnRequired;
@property(nonatomic)BOOL isGeoPopOver;

@property(nonatomic)BOOL shouldShowGreenColor;

- (id)initWithSize:(CGSize)_size;
- (void)reloadTable;
@end
