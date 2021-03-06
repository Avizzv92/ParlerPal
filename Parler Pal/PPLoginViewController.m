//
//  PPViewController.m
//  Parler Pal
//
//  Created by Aaron Vizzini on 6/8/14.
//  Copyright (c) 2014 Aaron Vizzini. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPMainViewController.h"
#import "PPDatabaseManager.h"
#import "PPDataShare.h"
#import "KeychainItemWrapper.h"

@implementation PPLoginViewController
@synthesize userName, password, scrollView, contentView, welcomeMessage, savePassword;

#pragma mark - view methods
-(void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRec.delegate = self;
    [self.view addGestureRecognizer:tapRec];
    
    languageIndex = 0;
    welcomeLanguages = @[@"Welcome",@"أهلا وسهلا", @"Bienvenue",@"Willkommen",@"Benvenuto",@"ようこそ",@"환영합니다",@"歡迎",@"Bem-vindo",@"Merhaba", @"witaj", @"добро пожаловать", @"Ласкаво просимо",@"chào mừng"];
    
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(changeWelcomeText) userInfo:nil repeats:YES];
}

- (void)applicationEnteredForeground:(NSNotification *)notification
{
    [self.welcomeMessage.layer removeAllAnimations];
    self.welcomeMessage.alpha = 1.0;
    [self animate];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(changeWelcomeText) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.welcomeMessage.layer removeAllAnimations];
    self.welcomeMessage.alpha = 1.0;
    [self animate];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(changeWelcomeText) userInfo:nil repeats:YES];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ParlerPalLogin" accessGroup:nil];
    NSString *usernameKeychain = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSData *passData = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *passwordKeychain = [[NSString alloc] initWithBytes:[passData bytes] length:[passData length] encoding:NSUTF8StringEncoding];

    if(passwordKeychain.length > 0 && usernameKeychain.length > 0)
    {
        userName.text = usernameKeychain;
        password.text = passwordKeychain;

        self.savePassword.on = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - animate

-(void)animate
{
    [UIView animateWithDuration:3.0 delay:3.0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        self.welcomeMessage.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}

-(void)changeWelcomeText
{
    languageIndex = languageIndex + 1 > welcomeLanguages.count -1 ? 0 : languageIndex + 1;
    self.welcomeMessage.text = [welcomeLanguages objectAtIndex:languageIndex];
}

#pragma mark - gesture methods

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

#pragma mark - textfield action methods

-(IBAction)userFieldDidReturn:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password becomeFirstResponder];
}

-(IBAction)passwordFieldDidReturn:(id)sender
{
    [self.password resignFirstResponder];
    [self login:nil];
}

-(IBAction)switchSelected:(id)sender
{
    if(!savePassword.on)
    {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ParlerPalLogin" accessGroup:nil];
        [keychainItem resetKeychainItem];
        
        userName.text = @"";
        password.text = @"";
    }
}

#pragma mark - textfield delegate methods

// Call this method somewhere in your view controller setup code.
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+10, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark create account button action

-(IBAction)createAccount:(id)sender
{

}

#pragma mark - login methods

-(IBAction)login:(id)sender
{    
    [[PPDatabaseManager sharedDatabaseManager]signinWithUsername:userName.text password:password.text completionHandler:^(bool success){
        if(success)
        {
            //Save Password
            if(savePassword.on)
            {
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ParlerPalLogin" accessGroup:nil];
                [keychainItem setObject:userName.text forKey:(__bridge id)(kSecAttrAccount)];
                [keychainItem setObject:password.text forKey:(__bridge id)(kSecValueData)];
            }
            
            [[PPDataShare sharedSingleton]setCurrentUser:userName.text];
            
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else {}
    }];
}

#pragma mark - segue methods

-(IBAction)unwindToLogin:(UIStoryboardSegue *)unwindSegue
{
    [[PPDatabaseManager sharedDatabaseManager]logoutCompletionHandler:^(bool success) {
    }];
    self.userName.text = @"";
    self.password.text = @"";
}

@end
