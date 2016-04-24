//
// CustomPopOverViewController.h
//
//  Created by Gs on 20/03/15.
//  Copyright (c) 2015 Dr. All rights reserved.
//



#import "CustomPopOverViewController.h"
#define POPOVER_CANCEL_TITLE @"Clear"
#define POPOVER_DONE_TITLE @"Done"
#define TABLE_MAX_DISPLAY_COUNT 5
#define IMAGE_CELL_SELECTED @"select_bg"
#define SEARCH_FIELD_CHAR_LENGTH 32


@interface CustomPopOverViewController ()
{
    UIBarButtonItem *barBtnCancel;
    UIBarButtonItem *barBtnDone;
    NSIndexPath *prevIndexPath;
    
}
@end

@implementation CustomPopOverViewController
@synthesize m_arrDisplayItems,m_dlgPopOver,m_SelectedValues,m_PopOver_Title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)reloadTable
{
    [m_tblPopOverContent reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(self.isMultiSelectPopOver)
    {
        self.isDoneBtnRequired=self.isMultiSelectPopOver;
    }
    
    [self loadUIElements];
    self.view.backgroundColor= [UIColor clearColor];
}
- (id)initWithSize:(CGSize)_size
{
    if(self=[super init])
    {
        tblSize=_size;
        
        
        
    }
    return self;
}
-(void)loadUIElements
{
    
    
    m_tblPopOverContent = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tblSize.width,tblSize.height-40) style:UITableViewStylePlain ];
    self.title =self.m_PopOver_Title;
    m_tblPopOverContent.backgroundColor = [self colorFromHexString:@"00A389"];
    [m_tblPopOverContent setSeparatorColor:[UIColor lightGrayColor]];

    if(self.isCacelBtnRequired)
    {
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(0, 0, 56, 26);
        
//        [btnCancel Helvetica_12_Bold_Blue];
//        [btnCancel setBackgroundImage:[UIImage imageNamed:CANCEL_VISIT_REASON_CANCEL_BUTTON_IMAGE] forState:UIControlStateNormal];
//        
        [btnCancel setTitle:POPOVER_CANCEL_TITLE forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        
        barBtnCancel = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
        self.navigationItem.leftBarButtonItem = barBtnCancel;
        
        
        //Fixing Leak, For INDIA, commented the following lines.
        //        [btnCancel release];
        //        btnCancel = nil;
        
    }
    
    if(self.isDoneBtnRequired)
    {
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDone.frame = CGRectMake(240, 11, 56, 26);
        
//        [btnDone Helvetica_12_Bold_Blue];
//        [btnDone setBackgroundImage:[UIImage imageNamed:CANCEL_VISIT_REASON_CANCEL_BUTTON_IMAGE] forState:UIControlStateNormal];
//        [btnDone setTitle:POPOVER_DONE_TITLE forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        
        barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
        self.navigationItem.rightBarButtonItem = barBtnDone;
        
        //Fixing Leak, For INDIA, commented the following lines.
        //        [btnDone release];
        //        btnDone = nil;
        
    }
    
    m_tblPopOverContent.dataSource=self;
    m_tblPopOverContent.delegate=self;
    
    
    
    
    if(!self.isGeoPopOver){
        
        UIImageView *ivw = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height)];
      //  [ivw setImageNamed:BACKGROUND];
        m_tblPopOverContent.backgroundView =ivw;
        
       // m_tblPopOverContent.separatorColor = [UIColor blackColor];
        
    }
    [self.view addSubview:m_tblPopOverContent];
    
    
    
    
    
    if(self.isGeoPopOver)
    {
        m_tblPopOverContent.backgroundColor=[UIColor whiteColor];
        m_tblPopOverContent.sectionHeaderHeight=45;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancelPressed
{
    if([self.m_dlgPopOver respondsToSelector:@selector(multiSelectionValues:)]){
        [self.m_SelectedValues removeAllObjects];
        [self.m_dlgPopOver multiSelectionValues:[NSArray arrayWithArray:self.m_SelectedValues]];
    }
    
    if([self.m_dlgPopOver respondsToSelector:@selector(removeOnCancelButtonTap)])
        [self.m_dlgPopOver removeOnCancelButtonTap];
}
-(void)donePressed
{
    if([self.m_dlgPopOver respondsToSelector:@selector(removeOnCancelButtonTap)])
        [self.m_dlgPopOver removeOnCancelButtonTap];}

#pragma mark - Tableview  delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.isGeoPopOver?4:self.m_arrDisplayItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isGeoPopOver?55:CELL_HEIGHT;
    //    return CELL_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.tintColor = [UIColor whiteColor];

    }
    for (UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!self.isGeoPopOver)
    {
        cell.textLabel.text = [m_arrDisplayItems objectAtIndex:indexPath.row];

        
        
        cell.backgroundView = nil;
        
        if(self.isMultiSelectPopOver &&[self.m_SelectedValues containsObject:[m_arrDisplayItems objectAtIndex:indexPath.row]]){
            
//            UIImageView *imgViewTemp=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IMAGE_CELL_SELECTED ofType:IMAGE_FORMAT_PNG]]];
//            cell.backgroundView=imgViewTemp;
//            
//            [imgViewTemp release];
//            imgViewTemp = nil;
            
            
        }
    }
    else
    {
        
        NSArray *array=[[NSArray alloc]initWithObjects:@"Cus.Type  :",@"Ind.Clas    :",@"Ag.Valu    :",@"Ag.Type   :", nil];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:17];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",[array objectAtIndex:indexPath.row],[m_arrDisplayItems objectAtIndex:indexPath.row+1]];
        
       
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.backgroundColor = [self colorFromHexString:@"00A389"];// [UIColor colorWithRed:0 green:163 blue:137 alpha:1];
    cell.contentView.backgroundColor = [self colorFromHexString:@"00A389"];
    cell.backgroundColor = [self colorFromHexString:@"00A389"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if(self.isMultiSelectPopOver)
    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        
//        if([self.m_SelectedValues containsObject:[self.m_arrDisplayItems objectAtIndex:indexPath.row]])
//        {
//            
//            [self.m_SelectedValues removeObject:[self.m_arrDisplayItems objectAtIndex:indexPath.row]];
//            cell.backgroundView=nil;
// 
//            
//        }
//        else
//        {
//            [self.m_SelectedValues addObject:[self.m_arrDisplayItems objectAtIndex:indexPath.row]];
//            
//            UIImageView *imgViewTemp=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IMAGE_CELL_SELECTED ofType:IMAGE_FORMAT_PNG]]];
//            cell.backgroundView=imgViewTemp;
//            cell.textLabel.textColor = [UIColor blackColor];
//            [imgViewTemp release];
//            imgViewTemp = nil;
//            
//        }
//        
//        if([self.m_dlgPopOver respondsToSelector:@selector(multiSelectionValues:)]){
//            [self.m_dlgPopOver multiSelectionValues:[NSArray arrayWithArray:self.m_SelectedValues]];
//        }
    }
    else
    {
      //  [self resetCheckMark:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (prevIndexPath && prevIndexPath.row == indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryNone;
        else
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        if([self.m_dlgPopOver respondsToSelector:@selector(itemSelected:withIndex:)])
            [self.m_dlgPopOver itemSelected:[self.m_arrDisplayItems objectAtIndex:indexPath.row] withIndex:(int)indexPath.row ];
    }
    
    prevIndexPath = indexPath;
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return  self.isGeoPopOver?60.0:0.0;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}
-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if(self.isGeoPopOver)
//    {
//        
//        UIView *view= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)] autorelease];
//        UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, tableView.frame.size.width, 30)];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.textColor =[UIColor whiteColor];
//        lbl.font= [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
//        lbl.backgroundColor=[UIColor clearColor];
//        lbl.numberOfLines=0;
//        lbl.lineBreakMode=NSLineBreakByWordWrapping;
//        lbl.text= [m_arrDisplayItems objectAtIndex:0];
//        [view addSubview:lbl];
//        [lbl release];
//        lbl = nil;
//        [view setBackgroundColor:self.shouldShowGreenColor?[UIColor colorWithRed:1/255.0 green:89/255.0 blue:5/255.0 alpha:1.0]:[UIColor colorWithRed:146/255.0 green:5/255.0 blue:14/255.0 alpha:1.0]];
//        return view;
//    }
    
    return nil;
}


- (void)dealloc
{
//    if(m_tblPopOverContent!=nil){
//        [m_tblPopOverContent release];
//        m_tblPopOverContent = nil;
//    }
//    
//    if(m_arrItems != nil){
//        [m_arrItems release];
//        m_arrItems = nil;
//    }
//    
//    if(m_dlgPopOver!= nil)
//        m_dlgPopOver = nil;
//    
//    if(m_arrDisplayItems != nil){
//        [m_arrDisplayItems release];
//        m_arrDisplayItems = nil;
//    }
//    if(m_SelectedValues!= nil){
//        [m_SelectedValues release];
//        m_SelectedValues = nil;
//    }
//    
//    
//    
//    [super dealloc];
}


@end
