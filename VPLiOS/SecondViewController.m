//
//  SecondViewController.m
//  VPLiOS
//
//  Created by Josh Rojas on 11/1/14.
//  Copyright (c) 2014 Josh Rojas. All rights reserved.
//

#import "SecondViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Parse/Parse.h>

@interface SecondViewController () <UIToolbarDelegate>{
    IBOutlet UILabel *string;
    IBOutlet UILabel *count;
    IBOutlet UIButton *button;
    IBOutlet UIToolbar *toolBar;
}

@property (strong, nonatomic) JSContext *context;

-(IBAction)evaluate:(id)sender;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    toolBar.delegate = self;
    self.context = [[JSContext alloc] init];
    [self download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)download{
    count.text = @"0";
    if (self.fileNo.intValue < 0 || self.fileNo.intValue > 5) {
        self.fileNo = @(0);
    }
    PFUser *curr = [PFUser currentUser];
    NSArray *arr = [curr valueForKey:@"files"];
    PFQuery *query = [PFQuery queryWithClassName:@"Files"];
    [query whereKey:@"objectId" equalTo:[arr objectAtIndex:self.fileNo.integerValue]];
    
    
    NSArray *results = [query findObjects];
    PFFile *file = [[results objectAtIndex:0] valueForKey:@"File"];
    NSData* data = [NSData dataWithData:[file getData]];
    NSString *jsfunction = [[NSString alloc] initWithBytes:[data bytes]
                                                    length:[data length]
                                                  encoding:NSUTF8StringEncoding];
    
    
    [self.context evaluateScript:jsfunction];
    button.hidden = NO;
    string.hidden = NO;
    count.hidden = NO;
}

-(IBAction)evaluate:(id)sender{
    
    JSValue *function = self.context[@"evaluate"];
    JSValue *result = [function callWithArguments:@[count.text] ];
    count.text = result.toString;
    
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
