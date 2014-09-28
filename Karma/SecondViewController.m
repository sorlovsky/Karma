//
//  SecondViewController.m
//  Karma
//
//  Created by Simon Orlovsky on 9/19/14.
//  Copyright (c) 2014 simonorlovsky. All rights reserved.
//
// Apple Jason

#import "SecondViewController.h"
#import <Parse/Parse.h>
#import "KarmaRecieveViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
{
    NSMutableArray *_requests;
    NSMutableArray *_requests1;
    NSMutableArray *_requestObjects;
    NSMutableArray *_requestLocations;
    UIRefreshControl* _refreshControl;
    int _cellSelected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
     
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    _refreshControl.backgroundColor = [UIColor purpleColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                        action:@selector(reloadData)
              forControlEvents:UIControlEventValueChanged];
    
    self.navigationController.navigationBar.topItem.title = @"Get Karma";
    // Do any additional setup after loading the view, typically from a nib.
    _requests1 = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    _requests = [[NSMutableArray alloc] init];
    _requestObjects = [[NSMutableArray alloc] init];
    _requestLocations = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"request"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld requests.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_requests insertObject:object[@"type"] atIndex:0];
                [_requestObjects insertObject:object atIndex:0];
                [_requestLocations insertObject:object[@"location"] atIndex:0];
                
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
//        for (int i=0; i<50; i++) {
//            [_typeArray addObject:_requests[i][@"type"]];
//            NSLog(_requests[i][@"type"]);
//        }
        [_tableView reloadData];
        
        //NSString *type= _requests[0][@"type"];
        
        //NSLog(@"%@",type);
    }];
}

-(void)reloadData{
    _requests = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"request"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld requests.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [_requests insertObject:object[@"type"] atIndex:0];
                //NSLog(_completed[0]);
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        [_tableView reloadData];
        
    }];
    [_refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of requests: %ld",_requests.count);
    return [_requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //NSLog(@"Requests size: %ld and object %@",_requests.count,[_requests objectAtIndex:indexPath.row]);
    cell.textLabel.text = [_requests objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:30];
    cell.detailTextLabel.text = [_requestLocations objectAtIndex:indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Value Selected by user
    //NSString *selectedValue = [displayValues objectAtIndex:indexPath.row];
    //Initialize new viewController
    _cellSelected = indexPath.row;
    [self performSegueWithIdentifier:@"segue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    
    // Get reference to the destination view controller
    KarmaRecieveViewController *karmaRecieveVC = segue.destinationViewController;;
        
    // Pass any objects to the view controller here, like...
    karmaRecieveVC.request = _requestObjects[_cellSelected];
    NSLog(@"Karma type is ....%@",karmaRecieveVC.request[@"type"]);
    
}




@end
