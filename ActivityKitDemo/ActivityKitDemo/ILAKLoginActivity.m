//
//  ILAKLoginActivity.m
//  ActivityKitDemo
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILAKLoginActivity.h"
#import "Activity/ILAlertViewController.h"

@interface ILAKLoginActivity ()
- (void) performLoginWithUserName:(NSString*) name password:(NSString*) password;
- (void) showTwoFieldsLoginAlert;
- (void) showOneFieldLoginAlertWithUserName:(NSString*) name;
@end

@implementation ILAKLoginActivity

- (void)main;
{
    [self showTwoFieldsLoginAlert];
}

- (void)cancel;
{
    NSLog(@"Login cancelled");
    [super cancel];
}

- (void) performLoginWithUserName:(NSString*) name password:(NSString*) password;
{
    BOOL isCorrect = [name isEqualToString:@"asdf"] && [password isEqualToString:@"1234"];
    
    if (isCorrect) {
        NSLog(@"Login successful");
        [self end];
        return;
    }
        
    ILAlertViewController* retryAlert = [ILAlertViewController new];
    
    retryAlert.alertView.title = @"The name or password for Some Service were incorrect.";
    retryAlert.alertView.cancelButtonIndex = [retryAlert addButtonWithTitle:@"Cancel" block:^{ [self cancel]; }];

    [retryAlert addButtonWithTitle:@"Retry" block:^{
        if (name && ![name isEqualToString:@""])
            [self showOneFieldLoginAlertWithUserName:name];
        else
            [self showTwoFieldsLoginAlert];
    }];
    
    [retryAlert show];
}

- (void) showTwoFieldsLoginAlert;
{
    
    ILAlertViewController* alert = [ILAlertViewController new];

    alert.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.alertView.title = @"Some Service";
    
    __weak UIAlertView* weakAlertView = alert.alertView;
    
    [alert addButtonWithTitle:@"Log In" block:^{
        
        UIAlertView* alertView = weakAlertView;
        
        if (alertView) {
            [self performLoginWithUserName:[alertView textFieldAtIndex:0].text password:[alertView textFieldAtIndex:1].text];
        }
        
    }];
    
    alert.alertView.cancelButtonIndex = [alert addButtonWithTitle:@"Cancel" block:^{ [self cancel]; }];
    
    [alert show];
}

- (void) showOneFieldLoginAlertWithUserName:(NSString*) name;
{
    
    ILAlertViewController* alert = [ILAlertViewController new];
    
    alert.alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.alertView.title = @"Some Service password";
    alert.alertView.message = name;
    
    __weak UIAlertView* weakAlertView = alert.alertView;
    
    [alert addButtonWithTitle:@"Log In" block:^{
        
        UIAlertView* alertView = weakAlertView;
        
        if (alertView) {
            [self performLoginWithUserName:name password:[alertView textFieldAtIndex:0].text];
        }
        
    }];
    
    alert.alertView.cancelButtonIndex = [alert addButtonWithTitle:@"Cancel" block:^{ [self cancel]; }];
    
    [alert show];
}

@end
