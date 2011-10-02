//
//  UIViewController+ILFindingContainer.m
//  Activity
//
//  Created by ∞ on 02/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+ILFindingContainer.h"

#if TARGET_OS_IPHONE

@implementation UIViewController (ILFindingContainer)

- (id)containingViewControllerOfClass:(Class)c;
{
    UIViewController* vc = self.parentViewController;
    
    while (vc && ![vc isKindOfClass:c])
        vc = vc.parentViewController;
    
    return vc;
}

@end

#endif
