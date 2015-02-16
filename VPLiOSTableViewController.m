//
//  VPLiOSTableViewController.m
//  VPLiOS
//
//  Created by Josh Rojas on 2/15/15.
//  Copyright (c) 2015 Josh Rojas. All rights reserved.
//

#import "VPLiOSTableViewController.h"
#import <Parse/Parse.h>
#import "SecondViewController.h"

@interface VPLiOSTableViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *programs;
@property (nonatomic) NSInteger selectedRow;
-(IBAction)logout:(id)sender;
@end

@implementation VPLiOSTableViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    self.programs = [[NSMutableArray alloc]init];
    PFUser *curr = [PFUser currentUser];
    NSArray *arr = [curr valueForKey:@"files"];
    PFQuery *query = [PFQuery queryWithClassName:@"Files"];
    [query whereKey:@"objectId" containedIn:arr];
    [query orderByAscending:@"createdAt"];
    NSArray *results = [query findObjects];
    for (int i = 0; i < results.count; i++) {
        PFObject *curr = [results objectAtIndex:i];
        [self.programs addObject:curr[@"Name"]];
    }
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.programs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.programs objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    svc.fileNo = [[NSNumber alloc] initWithInteger:self.selectedRow];
    [self presentViewController:svc animated:YES completion:^{}];
}



-(IBAction)logout:(id)sender{
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Logged Out"
                          message:@"You have logged out!"
                          delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
