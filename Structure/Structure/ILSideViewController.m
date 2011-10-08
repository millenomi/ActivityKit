//
//  ILDrawerController.m
//  DrawerController
//
//  Created by ∞ on 26/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILSideViewController.h"
#import "Activity/ILChoreography.h"

@interface UINavigationController (ILDrawerControllerPart) <ILDrawerControllerPart>
@end

@implementation UINavigationController (ILDrawerControllerPart)

- (void)drawerController:(ILSideViewController *)ctl willChangeVisibleBounds:(CGRect)newBounds;
{
    if ([self.topViewController conformsToProtocol:@protocol(ILDrawerControllerPart)]) {
        newBounds = [self.view convertRect:newBounds toView:self.topViewController.view];
        newBounds = CGRectIntersection(newBounds, self.topViewController.view.bounds);
        [(id <ILDrawerControllerPart>)self.topViewController drawerController:ctl willChangeVisibleBounds:newBounds];
    }
}

@end


@interface ILSideViewController ()
- (void) addSubviewsWithoutAnimation;

@property(copy, nonatomic) NSDate* lastAnimationTime;

@property(readonly, nonatomic) UIView* accentView;

@property(readonly, nonatomic) CGFloat drawerWidth, accentAreaWidth;
@property(readonly, nonatomic) CGRect mainArea, drawerArea, accentArea, accentAreaBeforeAnimation;

- (void) setMainControllerFrame:(CGRect) frame;
- (void) setDrawerControllerPrimitive:(UIViewController*) vc;

@end

@implementation ILSideViewController {
    BOOL animating;
    BOOL mainControllerTakesDelegateMethods;
    
    UISwipeGestureRecognizer* showDrawerRecognizer, * hideDrawerRecognizer;
}

@synthesize delegate;

@synthesize lastAnimationTime;

@synthesize mainController;
@synthesize drawerController;
@synthesize accentView;

- (void)dealloc {
    if ([mainController isViewLoaded])
        [mainController.view removeFromSuperview];
    if ([drawerController isViewLoaded])
        [drawerController.view removeFromSuperview];
    
    [mainController removeFromParentViewController];
    [drawerController removeFromParentViewController];
    
    [mainController release];
    [drawerController release];
    
    [accentView removeFromSuperview];
    [accentView release];
    
    [lastAnimationTime release];
    
    // Remove all targets and actions
    [showDrawerRecognizer removeTarget:nil action:NULL];
    [showDrawerRecognizer release];
    [hideDrawerRecognizer removeTarget:nil action:NULL];
    [hideDrawerRecognizer release];
    
    
    [super dealloc];
}

- (void)loadView;
{
    CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:screenFrame] autorelease];
    
    showDrawerRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shouldShowDrawerWithUserGesture:)];
    showDrawerRecognizer.numberOfTouchesRequired = 1;
    showDrawerRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    hideDrawerRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shouldHideDrawerWithUserGesture:)];
    hideDrawerRecognizer.numberOfTouchesRequired = 1;
    hideDrawerRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addSubviewsWithoutAnimation];
}

- (void)viewDidUnload;
{
    [showDrawerRecognizer removeTarget:nil action:NULL];
    [showDrawerRecognizer release];
    showDrawerRecognizer = nil;
    
    [hideDrawerRecognizer removeTarget:nil action:NULL];
    [hideDrawerRecognizer release];
    hideDrawerRecognizer = nil;
    
    [super viewDidUnload];
}

- (void) shouldShowDrawerWithUserGesture:(id) recog;
{
    if (!self.drawerController && [self.delegate respondsToSelector:@selector(drawerControllerForUserGestureInSideViewController:)]) {
        UIViewController* vc = [self.delegate drawerControllerForUserGestureInSideViewController:self];
        
        if (vc)
            [self setDrawerController:vc animated:YES];
    }
}

- (void) shouldHideDrawerWithUserGesture:(id) recog;
{
    if (self.drawerController) {
        BOOL shouldDismiss = [self.delegate respondsToSelector:@selector(sideViewControllerCanDismissDrawerByUserGesture:)] && [self.delegate sideViewControllerCanDismissDrawerByUserGesture:self];
        
        if (shouldDismiss) {
            if ([self.delegate respondsToSelector:@selector(sideViewController:userWillAttemptDismissalAnimated:)])
                [self.delegate sideViewController:self userWillAttemptDismissalAnimated:YES];
            
            ILChoreography* cho = [self choreographyForChangingDrawerController:nil];
            [cho addAnimationWithBlocksForPreparing:nil animating:nil completing:^(BOOL finished) {
                
                if ([self.delegate respondsToSelector:@selector(sideViewController:userDidFinishDismissing:animated:)])
                    [self.delegate sideViewController:self userDidFinishDismissing:YES animated:YES];
                
            }];
            
            [cho start];
        }
    }
}

- (void) addSubviewsWithoutAnimation;
{
    if (self.mainController) {
        [self.view addSubview:self.mainController.view];
        [self.mainController.view addGestureRecognizer:showDrawerRecognizer];
        [self.mainController.view addGestureRecognizer:hideDrawerRecognizer];
    }
    
    if (self.drawerController) {
        [self.view addSubview:self.drawerController.view];
        [self.view addSubview:self.accentView];
    } else {
        [self.accentView removeFromSuperview];
    }
}

- (void) viewWillLayoutSubviews;
{
    if (animating)
        return;
    
    [self setMainControllerFrame:self.mainArea];
    
    if (self.drawerController) {
        self.drawerController.view.frame = self.drawerArea;
        self.accentView.frame = self.accentArea;
    }
}

- (void)setMainController:(UIViewController *) mc;
{
    if (mc != mainController) {
        [mainController willMoveToParentViewController:nil];
        
        if ([mainController isViewLoaded]) {
            [mainController.view removeFromSuperview];
            [mainController.view removeGestureRecognizer:showDrawerRecognizer];
        }
        
        [mainController removeFromParentViewController];
        
        [mainController release];
        mainController = [mc retain];
        
        mainControllerTakesDelegateMethods = mainController && [mainController conformsToProtocol:@protocol(ILDrawerControllerPart)];
        
        if (mainController)
            [self addChildViewController:mainController];
        
        if ([self isViewLoaded])
            [self addSubviewsWithoutAnimation];
        
        [mainController didMoveToParentViewController:self];
    }
}

- (CGFloat)drawerWidth;
{
    return self.view.bounds.size.width / 2 + self.accentAreaWidth;
}

- (CGFloat)accentAreaWidth;
{
    return 25; // <#TODO#>
}

- (CGRect) mainArea;
{
    if (!self.drawerController)
        return self.view.bounds;
    else {
        CGRect r = self.view.bounds;
        r.origin.x -= self.drawerWidth;
        return CGRectIntegral(r);
    }
}

- (CGRect) drawerArea;
{
    CGFloat width = self.drawerWidth;
    CGRect r = self.view.bounds;
    CGFloat delta = r.size.width - width;
    
    r.size.width = width;
    r.origin.x += delta;
    return CGRectIntegral(r);
}

- (void) setDrawerControllerPrimitive:(UIViewController*) vc;
{
    if (vc != drawerController) {
        [self willChangeValueForKey:@"drawerController"];
        
        [drawerController release];
        drawerController = [vc retain];
        
        [self didChangeValueForKey:@"drawerController"];
    }
}

- (void)setDrawerController:(UIViewController *)dc;
{
    if (dc != drawerController) {
        [drawerController willMoveToParentViewController:nil];
        
        if ([drawerController isViewLoaded])
            [drawerController.view removeFromSuperview];
        
        [drawerController removeFromParentViewController];
        
        [drawerController release];
        drawerController = [dc retain];
        
        if (drawerController)
            [self addChildViewController:drawerController];
        
        if ([self isViewLoaded])
            [self addSubviewsWithoutAnimation];
        
        [drawerController didMoveToParentViewController:self];
    }
}

- (UIView *)accentView;
{
    if (!accentView) {
        accentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftShadow.png"]];
        accentView.contentMode = UIViewContentModeScaleToFill;
        [accentView sizeToFit];
    }
    
    return accentView;
}

- (CGRect)accentArea;
{
    CGRect r = self.accentView.frame;
    
    CGRect main = self.mainArea;
    r.origin.y = main.origin.y;
    r.origin.x = main.origin.x + main.size.width;
    r.size.height = main.size.height;
    
    return r;
}

- (CGRect)accentAreaBeforeAnimation;
{
    CGRect r = self.accentView.frame;
    
    CGRect main = self.mainController.view.frame;
    r.origin.y = main.origin.y;
    r.origin.x = main.origin.x + main.size.width;
    r.size.height = main.size.height;
    
    return r;
}

- (ILChoreography*) choreographyForChangingDrawerController:(UIViewController*) newController;
{
    UIViewController* pastController = [[self.drawerController retain] autorelease];
    ILChoreography* choreography = [[ILChoreography new] autorelease];
    
    NSDate* animationTime = [NSDate date];
    self.lastAnimationTime = animationTime;
    
    if (!pastController && newController) {
        [choreography addAnimationWithBlocksForPreparing:^{
            
            [self setDrawerControllerPrimitive:newController];
            
            [self addChildViewController:newController];
            
            newController.view.frame = self.drawerArea;
            [self.view insertSubview:newController.view belowSubview:self.mainController.view];
            
            self.accentView.frame = self.accentAreaBeforeAnimation;
            [self.view insertSubview:self.accentView belowSubview:self.mainController.view];
            
            animating = YES;
            
        } animating:^{
            
            self.accentView.frame = self.accentArea;
            [self setMainControllerFrame:self.mainArea];
            
        } completing:^(BOOL finished) {
            
            if ([animationTime isEqualToDate:self.lastAnimationTime])
                animating = NO;
            
            [drawerController didMoveToParentViewController:self];
            
        }];
    } else if (!newController && pastController) {
        [choreography addAnimationWithBlocksForPreparing:^{
            
            [self setDrawerControllerPrimitive:nil];
            
            animating = YES;
            
            [pastController willMoveToParentViewController:nil];
            
        } animating:^{
            
            [self setMainControllerFrame:self.mainArea];
            self.accentView.frame = self.accentArea;
            
        } completing:^(BOOL finished) {
            
            [pastController.view removeFromSuperview];
            [pastController removeFromParentViewController];
            
            if ([animationTime isEqualToDate:self.lastAnimationTime]) {
                [self.accentView removeFromSuperview];
                animating = NO;
            }
            
        }];
    } else if (newController && pastController) {
        [choreography addAnimationWithBlocksForPreparing:^{
            
            [self setDrawerControllerPrimitive:newController];
            
            [self addChildViewController:newController];
            newController.view.frame = self.drawerArea;
            [self.view insertSubview:newController.view belowSubview:pastController.view];
            
            animating = YES;
            
            [pastController willMoveToParentViewController:nil];
            
        } animating:^{
            
            pastController.view.alpha = 0;
            
        } completing:^(BOOL finished) {
            
            [pastController.view removeFromSuperview];
            pastController.view.alpha = 1.0;
            [pastController removeFromParentViewController];
            
            if ([animationTime isEqualToDate:self.lastAnimationTime])
                animating = NO;
            
            [drawerController didMoveToParentViewController:self];
            
        }];
    }
    
    return choreography;
}

- (void)setDrawerController:(UIViewController *)dc animated:(BOOL) ani;
{
    if (!ani || ![self isViewLoaded] || !self.mainController) {
        self.drawerController = dc;
        return;
    }
    
    if (dc != drawerController) {
        [[self choreographyForChangingDrawerController:dc] start];
    }
}

- (void) setMainControllerFrame:(CGRect) frame;
{
    self.mainController.view.frame = frame;
    
    if (mainControllerTakesDelegateMethods) {
        CGRect visible = CGRectIntersection(self.view.bounds, self.mainController.view.frame);
        [(id <ILDrawerControllerPart>)self.mainController drawerController:self willChangeVisibleBounds:[self.mainController.view convertRect:visible fromView:self.view]];
    }
}

@end
