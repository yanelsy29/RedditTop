//
//  FilterViewController.h
//  TopTest
//
//  Created by Yanelsy Rivera on 11/1/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController*)view
               didSelectItem:(NSArray*)filterArray
                    andTitle:(NSString*)title;

- (void)filterViewControllerDismiss;

@end

@interface FilterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) id <FilterViewControllerDelegate> delegate;

@property(nonatomic, strong) NSArray *linksArray;

@end
