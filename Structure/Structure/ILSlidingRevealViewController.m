//
//  ILDrawerController.m
//  DrawerController
//
//  Created by ∞ on 26/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILSlidingRevealViewController.h"
#import "Activity/ILChoreography.h"

@interface UINavigationController (ILDrawerControllerPart) <ILDrawerControllerPart>
@end

@implementation UINavigationController (ILDrawerControllerPart)

- (void)drawerController:(ILSlidingRevealViewController *)ctl willChangeVisibleBounds:(CGRect)newBounds;
{
    if ([self.topViewController conformsToProtocol:@protocol(ILDrawerControllerPart)]) {
        newBounds = [self.view convertRect:newBounds toView:self.topViewController.view];
        newBounds = CGRectIntersection(newBounds, self.topViewController.view.bounds);
        [(id <ILDrawerControllerPart>)self.topViewController drawerController:ctl willChangeVisibleBounds:newBounds];
    }
}

@end


@interface ILSlidingRevealViewController ()
- (void) addSubviewsWithoutAnimation;

@property(copy, nonatomic) NSDate* lastAnimationTime;

@property(readonly, nonatomic) UIView* accentView;

@property(readonly, nonatomic) CGFloat drawerWidth, accentAreaWidth;
@property(readonly, nonatomic) CGRect mainArea, drawerArea, accentArea, accentAreaBeforeAnimation;

- (void) setMainControllerFrame:(CGRect) frame;
- (void) setDrawerControllerPrimitive:(UIViewController*) vc;

@end

@implementation ILSlidingRevealViewController {
    BOOL animating;
    BOOL mainControllerTakesDelegateMethods;
}

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
    
    [super dealloc];
}

- (void)loadView;
{
    CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:screenFrame] autorelease];
    
    [self addSubviewsWithoutAnimation];
}

- (void) addSubviewsWithoutAnimation;
{
    if (self.mainController)
        [self.view addSubview:self.mainController.view];
    
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
        if ([mainController isViewLoaded])
            [mainController.view removeFromSuperview];
        
        [mainController removeFromParentViewController];
        
        [mainController release];
        mainController = [mc retain];
        
        mainControllerTakesDelegateMethods = mainController && [mainController conformsToProtocol:@protocol(ILDrawerControllerPart)];
        
        if (mainController)
            [self addChildViewController:mainController];
            
        if ([self isViewLoaded])
            [self addSubviewsWithoutAnimation];
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
        if ([drawerController isViewLoaded])
            [drawerController.view removeFromSuperview];
        
        [drawerController removeFromParentViewController];
        
        [drawerController release];
        drawerController = [dc retain];
        
        if (drawerController)
            [self addChildViewController:drawerController];
        
        if ([self isViewLoaded])
            [self addSubviewsWithoutAnimation];
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

- (ILChoreography*) choreographyForSettingDrawerController:(UIViewController*) newController;
{
    UIViewController* pastController = [[self.drawerController retain] autorelease];
    ILChoreography* choreography = [[ILChoreography new] autorelease];
    
    NSDate* animationTime = [NSDate date];
    self.lastAnimationTime = animationTime;
    
    if (!pastController && newController) {
        [choreography addAnimationWithBlocksForPreparing:^{
            
            [self setDrawerControllerPrimitive:newController];
            
            [self addChildViewController:newController];
            
            drawerController.view.frame = self.drawerArea;
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
            
        }];
    } else if (!newController && pastController) {
        [choreography addAnimationWithBlocksForPreparing:^{
            
            [self setDrawerControllerPrimitive:nil];

            animating = YES;
            
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
            drawerController.view.frame = self.drawerArea;
            [self.view insertSubview:newController.view belowSubview:pastController.view];
            
            animating = YES;
            
        } animating:^{
            
            pastController.view.alpha = 0;
            
        } completing:^(BOOL finished) {
            
            [pastController.view removeFromSuperview];
            pastController.view.alpha = 1.0;
            [pastController removeFromParentViewController];
            
            if ([animationTime isEqualToDate:self.lastAnimationTime])
                animating = NO;
            
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
        [[self choreographyForSettingDrawerController:dc] start];
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
