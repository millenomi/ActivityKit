//
//  ILDrawerController.h
//  DrawerController
//
//  Created by ∞ on 26/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILChoreography;
@protocol ILSideViewControllerDelegate;


@interface ILSideViewController : UIViewController

@property(retain, nonatomic) UIViewController* mainController;
@property(retain, nonatomic) UIViewController* drawerController;

- (void)setDrawerController:(UIViewController *)dc animated:(BOOL) ani;
- (ILChoreography*) choreographyForChangingDrawerController:(UIViewController*) vc;

@property(assign, nonatomic) id <ILSideViewControllerDelegate> delegate;

@end


// If the .mainController of a ILDrawerController conforms to this protocol, it will receive its messages.
@protocol ILDrawerControllerPart <NSObject>

// Indicates that the view may be moved in a way that partially obscures its content. The given bounds rectangle is visible onscreen. (It's in this view controller's view's coordinate system.)
// May be called within an animation block.
// Please note: if never called, assume the entirety of the bounds of the view are visible.
- (void) drawerController:(ILSideViewController*) ctl willChangeVisibleBounds:(CGRect) newBounds;

@end

@protocol ILSideViewControllerDelegate <NSObject>

@optional
// If you implement this, and it returns a nonnil view controller, swiping right-to-left on the main VC's view will animate this view controller's view in as a drawer.
- (UIViewController*) drawerControllerForUserGestureInSideViewController:(ILSideViewController*) svc;

// If YES, the main view controller's view is dimmed when the drawer appears. Tapping on a dimmed view may also be used to dimsiss the drawer.
// - (BOOL) sideViewControllerDimsMainWhenDrawerVisible:(ILSideViewController*) svc;

// If YES, the drawer controller will be dismissable by user gesture (tapping on a dimmed main view controller, swiping left-to-right etc).
// - (BOOL) sideViewControllerCanDismissDrawerByUserGesture:(ILSideViewController*) svc;

// If the user can dismiss the drawer controller, these methods are called when the dismissal occurs (or is attempted).
// userWill... is called first; userDid... is paired. If 'dismissed' is NO, then the drawer wasn't dismissed for some reason (eg user did not complete the gesture).
// - (void) sideViewController:(ILSideViewController*) svc userWillAttemptDismissalAnimated:(BOOL) animated;
// - (void) sideViewController:(ILSideViewController*) svc userDidFinishDismissing:(BOOL) dismissed animated:(BOOL) animated;

@end
