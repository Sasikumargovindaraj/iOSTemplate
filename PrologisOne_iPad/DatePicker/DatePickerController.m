//
//  DatePickerController.m
//  dd
//
//  Created by Upendra on 29/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController ()
- (IBAction)didDateChage:(UIDatePicker *)sender;

@end

@implementation DatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didDateChage:(UIDatePicker *)sender {
}
@end
