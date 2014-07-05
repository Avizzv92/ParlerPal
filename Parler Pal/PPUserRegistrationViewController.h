//
//  PPUserRegistrationViewController.h
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/17/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPUserRegistrationViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, weak)UITextField *usernameField, *passwordField, *confirmField, *emailField;
@property(nonatomic, weak)UILabel *welcomeMessage;
@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIView *contentView;

//Textfield did end editing so hide it
-(IBAction)usernameFieldDidReturn:(id)sender;
-(IBAction)passwordFieldDidReturn:(id)sender;
-(IBAction)confirmFieldDidReturn:(id)sender;
-(IBAction)emailFieldDidReturn:(id)sender;

//Signup methods, cancel or signup!
-(IBAction)signup:(id)sender;
-(IBAction)cancel:(id)segue;

@end
