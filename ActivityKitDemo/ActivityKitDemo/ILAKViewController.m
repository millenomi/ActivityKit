//
//  ILAKViewController.m
//  ActivityKitDemo
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILAKViewController.h"
#import "ILAKLoginActivity.h"

#import "Activity/ILActivity.h"
#import "Activity/ILActivitiesSet.h"

#import "Activity/UIViewController+ILFindingContainer.h"
#import "Structure/ILSideViewController.h"

@interface ILAKViewController ()
@property(retain, nonatomic) id <ILActivitiesQuery> loginActivityQuery;
@end


@implementation ILAKViewController

@synthesize loginActivityQuery;

@synthesize loginButton;
@synthesize loginSpinner;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginActivityQuery = [[ILActivitiesSet sharedSet] queryForActivitiesOfClass:[ILAKLoginActivity class]];
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setLoginSpinner:nil];
    
    self.loginActivityQuery = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"loginActivityQuery.activities" options:NSKeyValueObservingOptionInitial context:NULL];
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
    [self removeObserver:self forKeyPath:@"loginActivityQuery.activities"];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    BOOL isLoggingIn = self.loginActivityQuery.activities.count > 0;
    
    if (isLoggingIn)
        [self.loginSpinner startAnimating];
    else
        [self.loginSpinner stopAnimating];
    
    self.loginButton.enabled = !isLoggingIn;
}

- (IBAction)showDrawer:(id)sender;
{
    ILSideViewController* parent = [self containingViewControllerOfClass:[ILSideViewController class]];
    
    UIViewController* red = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    
    UIView* redView = [[UIView alloc] initWithFrame:CGRectZero];
    redView.backgroundColor = [UIColor redColor];
    red.view = redView;
    
    red.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideDrawer)];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:red];
    
    [parent setDrawerController:nav animated:YES];
}

- (void) hideDrawer;
{
    ILSideViewController* parent = [self containingViewControllerOfClass:[ILSideViewController class]];
    
    [parent setDrawerController:nil animated:YES];
}

@end
