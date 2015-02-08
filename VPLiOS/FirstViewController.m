//
//  FirstViewController.m
//  VPLiOS
//
//  Created by Josh Rojas on 11/1/14.
//  Copyright (c) 2014 Josh Rojas. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>

@interface FirstViewController (){
    IBOutlet UIImageView *imgview;
}


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)downloadButtonHit:(id)sender{
    PFUser *curr = [PFUser currentUser];
    NSArray *arr = [curr valueForKey:@"files"];
    PFQuery *query = [PFQuery queryWithClassName:@"Files"];
    [query whereKey:@"objectId" equalTo:[arr objectAtIndex:0]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            PFFile *file = [[objects objectAtIndex:0] valueForKey:@"File"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *imgerror) {
                if(!error){
                    imgview.image = [UIImage imageWithData:data];
                } else {
                    NSLog(@"Error: %@ .. %@", imgerror, [imgerror userInfo]);

                }
            }];
        }
        else {
            NSLog(@"Error: %@ .. %@", error, [error userInfo]);
        }
    }];
}


@end
