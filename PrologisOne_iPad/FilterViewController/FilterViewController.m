//
//  FilterViewController.m
//  dd
//
//  Created by Sasi on 28/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCell.h"
#import "DatePickerController.h"

@interface FilterViewController () {
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UITextField *_txtFilterName;
}
- (IBAction)didApplyTap:(UIButton *)sender;
- (IBAction)didRestoreTap:(UIButton *)sender;
- (IBAction)didSaveFilter:(UIButton *)sender;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:@"FilterCell" bundle:nil] forCellReuseIdentifier:@"FilterCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    cell.model = [self.arrData objectAtIndex:indexPath.row];
    cell._txtField.delegate = (id)self;
    cell._txtField.tag = indexPath.row;
    return cell;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    UIViewController *filter = [UIViewController new];
//    filter.modalPresentationStyle = UIModalPresentationPopover;
//    filter.popoverPresentationController.sourceView = self.view;
//    filter.preferredContentSize = CGSizeMake(400,450);
//    filter.popoverPresentationController.sourceRect = textField.frame;
//    filter.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:filter animated:YES completion:nil];
    if (textField !=_txtFilterName) {
        FilterModel *model = [self.arrData objectAtIndex:textField.tag];
        if (model.isDateField) {
            DatePickerController *filter = [DatePickerController new];
            filter.modalPresentationStyle = UIModalPresentationPopover;
            filter.popoverPresentationController.sourceView = self.view;
            filter.preferredContentSize = CGSizeMake(300,200);
            filter.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
            CGRect frme = [textField.superview convertRect:textField.frame toView:self.view];
            filter.popoverPresentationController.sourceRect = frme;
            filter.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:filter animated:YES completion:nil];
        }
        else {
            
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didCancelTap:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didApplyTap:(UIButton *)sender {
}

- (IBAction)didRestoreTap:(UIButton *)sender {
}

- (IBAction)didSaveFilter:(UIButton *)sender {
}
@end
