//
//  VPLiOSSignUpViewController.m
//  VPLiOS
//
//  Created by Josh Rojas on 11/1/14.
//  Copyright (c) 2014 Josh Rojas. All rights reserved.
//

#import "VPLiOSSignUpViewController.h"
#import <Parse/Parse.h>

@interface VPLiOSSignUpViewController () <UIActionSheetDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *passwordConfirmField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *usernameField;
}

- (IBAction)backButtonHit:(id)sender;
- (IBAction)signUpButtonHit:(id)sender;

@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;

@end

@implementation VPLiOSSignUpViewController
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
    nameField.inputAccessoryView = self.keyboardToolbar;
    emailField.inputAccessoryView = self.keyboardToolbar;
    passwordField.inputAccessoryView = self.keyboardToolbar;
    passwordConfirmField.inputAccessoryView = self.keyboardToolbar;
    usernameField.inputAccessoryView = self.keyboardToolbar;
    
    nameField.delegate = self;
    emailField.delegate = self;
    usernameField.delegate = self;
    passwordField.delegate = self;
    passwordConfirmField.delegate = self;
    
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

- (IBAction)signUpButtonHit:(id)sender{
    if ([passwordField.text isEqualToString:passwordConfirmField.text]){
        PFUser *user = [PFUser user];
        user.username = usernameField.text;
        user.email = emailField.text;
        user.password = passwordField.text;
        user[@"name"] = nameField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                // Hooray! Let them use the app now.
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sign up"
                                      message:@"Hurray you signed up!"
                                      delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
                [alert show];
                [self performSegueWithIdentifier:@"SignedUp" sender:self];
            } else {
                // Show the errorString somewhere and let the user try again.
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:error.description
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
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
    if ([nameField isFirstResponder]) {
        [emailField becomeFirstResponder];
    } else if ([emailField isFirstResponder]){
        [usernameField becomeFirstResponder];
    } else if ([usernameField isFirstResponder]){
        [passwordField becomeFirstResponder];
    } else if ([passwordField isFirstResponder]){
        [passwordConfirmField becomeFirstResponder];
    }
    
}

- (void) previousField
{
    //if text field is email
    //make name field be the one with the cursor
    if([passwordConfirmField isFirstResponder]){
        [passwordField becomeFirstResponder];
    } else if ([passwordField isFirstResponder]){
        [usernameField becomeFirstResponder];
    } else if ([usernameField isFirstResponder]){
        [emailField becomeFirstResponder];
    } else if ([emailField isFirstResponder]){
        [nameField becomeFirstResponder];
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
    
    if (textField == nameField) {
        self.previousButton.enabled = NO;
    } else {
        self.previousButton.enabled = YES;
    }
    
    if (textField == passwordConfirmField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    if (textField == usernameField) {
        viewFrame.origin.y = -50;
    } else if (textField == passwordField) {
        viewFrame.origin.y = -100;
    } else if (textField == passwordConfirmField){
        viewFrame.origin.y = -150;
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
