//
//  ILAKViewController.h
//  ActivityKitDemo
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILAKViewController : UIViewController

- (IBAction)logIn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginSpinner;

@end
