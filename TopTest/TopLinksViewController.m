//
//  TopLinkViewController.m
//  TopTest
//
//  Created by Yanelsy Rivera on 10/31/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import "TopLinksViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Network.h"
#import "FilterViewController.h"

#define NUMBER_CELL_IN_PAGE 5

@interface TopLinksTableViewCell : UITableViewCell

@property(nonatomic, strong) LinkObject *linkObject;
@property(nonatomic, strong) IBOutlet UIImageView *thumbnail;
@property(nonatomic, strong) IBOutlet UILabel *title;
@property(nonatomic, strong) IBOutlet UILabel *num_comments;
@property(nonatomic, strong) IBOutlet UILabel *author;
@property(nonatomic, strong) IBOutlet UILabel *subreddit;
@property(nonatomic, strong) IBOutlet UILabel *createdDate;

@end

@implementation TopLinksTableViewCell

- (void)setLinkObject:(LinkObject *)linkObject
{
    _linkObject = linkObject;
    
    [self.thumbnail setImageWithURL:[NSURL URLWithString:linkObject.thumbnail]];
    self.title.text = linkObject.title;
    self.num_comments.text = [NSString stringWithFormat:@"%ld comments", linkObject.num_comments];
    self.author.text = [NSString stringWithFormat:@"by %@",linkObject.author];
    self.subreddit.text = linkObject.subreddit;
    self.createdDate.text = [linkObject getTimeString];
    
}

@end

@interface TopLinksViewController () <FilterViewControllerDelegate>

@property(nonatomic, strong) IBOutlet UITableView *topTable;
@property(nonatomic, strong) IBOutlet UIButton *filterButton;
@property(nonatomic, strong) NSArray *linksArray;
@property(nonatomic, strong) NSArray *linksArrayPaginated;
@property(nonatomic, assign) NSInteger page;

@end

@implementation TopLinksViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.page = 1;
    
    self.linksArray = [self createNewArrayWithLinksObject:[self getDataSaved]];
    
    [self requestData];
    
}

- (void)setLinksArray:(NSArray *)linksArray
{
    _linksArray = linksArray;
    
    [self paginateArray];
    [self.topTable reloadData];
}

-(NSArray *)getDataSaved
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"topLinks"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(void)persistData:(NSArray *)array
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:@"topLinks"];
   [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)requestData
{
    [Request requestLinksWithResponse:^(NSArray *response, NSError *error) {
        if(error != nil) {
            return;
        }
        
        [self persistData:response];
        self.linksArray = [self createNewArrayWithLinksObject:response];
        
    }];
}

-(NSArray *)createNewArrayWithLinksObject:(NSArray *)response
{
    NSMutableArray *newResponse = [NSMutableArray new];
    
    for (NSDictionary *childrenDict in response) {
        LinkObject *children = [[LinkObject alloc] initWithDictionary:childrenDict[@"data"]];
        [newResponse addObject:children];
    }

    return newResponse;
}

-(void)paginateArray
{
    NSInteger maximunPages = self.linksArray.count / NUMBER_CELL_IN_PAGE;
    
    if (self.page > maximunPages) {
        return;
    }
    
    NSRange range = NSMakeRange(0, self.page*NUMBER_CELL_IN_PAGE);
    self.linksArrayPaginated = [self.linksArray subarrayWithRange:range];
}

-(IBAction)filterButtonTapped:(id)sender
{
    FilterViewController *filterView = [[FilterViewController alloc] initWithNibName:@"FilterViewController"
                                                                              bundle:nil];
    filterView.delegate = self;
    filterView.linksArray = [self.linksArray copy];
    filterView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:filterView
                       animated:YES
                     completion:nil];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.linksArrayPaginated.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopLinksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.linkObject = [self.linksArrayPaginated objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -40 && currentOffset>0) {
        if (self.linksArrayPaginated.count > 0) {
            self.page++;
            [self paginateArray];
            [self.topTable reloadData];
        }
    }
}


#pragma mark - Filter View Delegate

-(void)filterViewController:(FilterViewController *)view
              didSelectItem:(NSArray *)filterArray
                   andTitle:(NSString *)title
{
    self.linksArrayPaginated = filterArray;
    [self.filterButton setTitle:title
                       forState:UIControlStateNormal];
    [self.topTable reloadData];
}

@end
