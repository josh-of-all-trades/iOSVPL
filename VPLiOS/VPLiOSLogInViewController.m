//
//  VPLiOSLogInViewController.m
//  VPLiOS
//
//  Created by Josh Rojas on 11/1/14.
//  Copyright (c) 2014 Josh Rojas. All rights reserved.
//

#import "VPLiOSLogInViewController.h"
#import <Parse/Parse.h>

@interface VPLiOSLogInViewController () <UIActionSheetDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *emailOrUsernameField;
    IBOutlet UITextField *passwordField;
}

- (IBAction)signUpButtonHit:(id)sender;
- (IBAction)logInButtonHit:(id)sender;

@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;

@end


@implementation VPLiOSLogInViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emailOrUsernameField.inputAccessoryView = self.keyboardToolbar;
    passwordField.inputAccessoryView = self.keyboardToolbar;
    emailOrUsernameField.delegate = self;
    passwordField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHit:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Never Mind"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(IBAction)signUpButtonHit:(id)sender{
    
}

- (IBAction)logInButtonHit:(id)sender{
    //to handle ppl who try to log in with emails instead of usernames
    PFQuery *queryForUsername = [PFUser query];
    [queryForUsername whereKey:@"email" equalTo:emailOrUsernameField.text];
    NSArray *users = [queryForUsername findObjects];
    NSString *logInName = @"";
    if (users.count > 0){
        PFUser *foundUser = [users objectAtIndex:0];
        logInName = [foundUser valueForKey:@"username"];
    }
    if ([logInName isEqualToString:@""]){
        logInName = emailOrUsernameField.text;
    }
    
    //loging in awwww yisss
    [PFUser logInWithUsernameInBackground:logInName password:passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            UIAlertView *alert = [[UIAlertView alloc]
                                                                  initWithTitle:@"Log In"
                                                                  message:@"Hurray you Logged In!"
                                                                  delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                            [self performSegueWithIdentifier:@"LoggedIn" sender:self];
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                            UIAlertView *alert = [[UIAlertView alloc]
                                                                  initWithTitle:@"Error"
                                                                  message:@"There was an error logging in"
                                                                  delegate:self
                                                                  cancelButtonTitle:@"Try again"
                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - Keyboard Toolbar

- (void) nextField
{
    if ([emailOrUsernameField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    }
}

- (void) previousField
{
    //if text field is email
    //make name field be the one with the cursor
    if([passwordField isFirstResponder]){
        [emailOrUsernameField becomeFirstResponder];
    }
}

- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}


- (UIToolbar *)keyboardToolbar
{
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(previousField)];
        
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(nextField)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard)];
        
        [_keyboardToolbar setItems:@[self.previousButton, self.nextButton, extraSpace, doneButton]];
    }
    
    return _keyboardToolbar;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    
    if (textField == emailOrUsernameField) {
        self.previousButton.enabled = NO;
    } else {
        self.previousButton.enabled = YES;
    }
    
    if (textField == passwordField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    [textField resignFirstResponder];
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}



@end