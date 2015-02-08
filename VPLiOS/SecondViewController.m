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

@interface SecondViewController (){
    IBOutlet UILabel *string;
    IBOutlet UILabel *count;
    IBOutlet UIButton *button;
    IBOutlet UIButton *downloadButton;
    IBOutlet UITextField *input;
}

@property (strong, nonatomic) JSContext *context;

-(IBAction)evaluate:(id)sender;
-(IBAction)download:(id)sender;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.context = [[JSContext alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)download:(id)sender{
    NSNumber *fileNo = @(input.text.intValue);
    if (fileNo.intValue < 0 || fileNo.intValue > 5) {
        fileNo = @(0);
    }
    PFUser *curr = [PFUser currentUser];
    NSArray *arr = [curr valueForKey:@"files"];
    PFQuery *query = [PFQuery queryWithClassName:@"Files"];
    [query whereKey:@"objectId" equalTo:[arr objectAtIndex:fileNo.integerValue]];
    
    
    NSArray *results = [query findObjects];
    PFFile *file = [[results objectAtIndex:0] valueForKey:@"File"];
    NSData* data = [NSData dataWithData:[file getData]];
    NSString *jsfunction = [[NSString alloc] initWithBytes:[data bytes]
                                                    length:[data length]
                                                  encoding:NSUTF8StringEncoding];
    
    
    [self.context evaluateScript:jsfunction];
}

-(IBAction)evaluate:(id)sender{
    
    JSValue *function = self.context[@"evaluate"];
    JSValue *result = [function callWithArguments:@[count.text] ];
    count.text = result.toString;
    
}

@end
