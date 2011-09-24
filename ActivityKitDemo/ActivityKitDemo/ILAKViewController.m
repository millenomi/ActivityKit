//
//  ILAKViewController.m
//  ActivityKitDemo
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILAKViewController.h"
#import "ILAKLoginActivity.h"

#import "Activity/ILActivity.h"
#import "Activity/ILActivitiesSet.h"

@implementation ILAKViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)logIn:(id)sender;
{
    if (![ILAKLoginActivity startedActivity])
        [[ILAKLoginActivity new] start];
}

@end
