//
//  NewsfeedViewController.m
//  Karma
//
//  Created by Simon Orlovsky on 9/26/14.
//  Copyright (c) 2014 simonorlovsky. All rights reserved.
//

#import "NewsfeedViewController.h"
#import <Parse/Parse.h>
#import "NewsDetailViewController.h"

@interface NewsfeedViewController ()
{
    NSMutableArray * _completed;
    UIRefreshControl* _refreshControl;
    NSMutableArray* _completedObjects;
    int _cellSelected;
}
@end

@implementation NewsfeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    //making refresher
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    _refreshControl.backgroundColor = [UIColor purpleColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                        action:@selector(reloadData)
              forControlEvents:UIControlEventValueChanged];
    
    // Initialize the refresh control.
//    _refreshControl = [[UIRefreshControl alloc] init];
//    [self.tableView addSubview:_refreshControl];
//    _refreshControl.backgroundColor = [UIColor purpleColor];
//    _refreshControl.tintColor = [UIColor whiteColor];
//    [_refreshControl addTarget:self
//                            action:@selector(reloadData)
//                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    
    // Do any additional setup after loading the view.
    _completed = [[NSMutableArray alloc] init];
    _completedObjects = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"completed"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld requests.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [_completed insertObject:object[@"type"] atIndex:0];
                [_completedObjects insertObject:object atIndex:0];

                //NSLog(_completed[0]);
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        [_tableView reloadData];
        
    }];

}
    -(void)loadData{
        NSLog(@"YAYAYAYAY!");
        _completedObjects = [[NSMutableArray alloc] init];
        _completed = [[NSMutableArray alloc] init];
    
        PFQuery *query = [PFQuery queryWithClassName:@"request"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"type"]);
                [_completedObjects insertObject:object atIndex:0];
                [_completed insertObject:object[@"type"] atIndex:0];
                //[_requestLocations insertObject:object[@"location"] atIndex:0];
                [_tableView reloadData];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];


//-(void)reloadDataTable{
//    _completed = [[NSMutableArray alloc] init];
//    _completedObjects = [[NSMutableArray alloc] init];
//    PFQuery *query = [PFQuery queryWithClassName:@"completed"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %ld requests.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//                [_completed insertObject:object[@"type"] atIndex:0];
//                [_completedObjects insertObject:object atIndex:0];
//                //NSLog(_completed[0]);
//                
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//        
//        [_tableView reloadData];
//        
//    }];
//    [_refreshControl endRefreshing];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of requests: %ld",_completed.count);
    
    return [_completed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cellSelected = indexPath.row;

    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSLog(@"Requests size: %ld and object %@",_completed.count,[_completed objectAtIndex:indexPath.row]);
    cell.textLabel.text = [_completed objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:30];
    cell.detailTextLabel.text = [_completed objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Value Selected by user
    //NSString *selectedValue = [displayValues objectAtIndex:indexPath.row];
    //Initialize new viewController
    [self performSegueWithIdentifier:@"segue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    
    // Get reference to the destination view controller
    NewsDetailViewController *detailVC = segue.destinationViewController;;
    
    // Pass any objects to the view controller here, like...
    detailVC.completed = _completedObjects[_cellSelected];
    NSLog(@"Karma type is ???....%@",_completedObjects[_cellSelected][@"type"]);
    NSLog(@"Karma type is !!!....%@",detailVC.completed[@"type"]);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
