//
//  FilterViewController.m
//  TopTest
//
//  Created by Yanelsy Rivera on 11/1/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import "FilterViewController.h"
#import "Model.h"

typedef enum : NSUInteger {
    NoneFilter,
    FilterByLastHour,
    FilterByLastDay,
    FilterByLastMonth
} FilterParameters;

@interface FilterViewController ()

@property(nonatomic, strong) NSMutableArray *filterResult;
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property(nonatomic, assign) NSInteger selectedItem;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@"All",@"last hour", @"last day"];
    self.view.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.items[row];
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selectedItem = row;
}

- (IBAction)btnDoneTapped:(id)sender {
    [self sortByFilter];
    [self.delegate filterViewController:self
                          didSelectItem:self.filterResult
                               andTitle:self.items[self.selectedItem]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sortByFilter
{
    self.filterResult = [NSMutableArray new];
    
    if (self.selectedItem == NoneFilter) {
        self.filterResult = [NSMutableArray arrayWithArray:self.linksArray];
        return;
    }
    
    for (LinkObject *object in self.linksArray) {
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                          fromDate:object.createdDate
                                                            toDate:currentDate
                                                           options:0];
        if (self.selectedItem == FilterByLastHour){
            if (components.hour < 1) {
                [self.filterResult addObject:object];
            }
        } else if (self.selectedItem == FilterByLastDay){
            if (components.day < 1) {
                [self.filterResult addObject:object];
            }
        }
    }
    
    
    
}

@end
