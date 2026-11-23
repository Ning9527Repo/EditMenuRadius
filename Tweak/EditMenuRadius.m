#import "EMR.h"
#import <objc/runtime.h>

extern void MSHookMessageEx(Class, SEL, IMP, IMP *);

static BOOL EMRIsEditMenuView(UIView *view) {
    NSString *name = NSStringFromClass([view class]);
    // Keep the hook global, but restrict the mutation to UIKit edit-menu views.
    return [name containsString:@"EditMenu"] ||
           [name containsString:@"UIMenuController"] ||
           [name containsString:@"MenuBar"];
}

static CGFloat EMRRadius(void) {
    NSNumber *n = [[NSUserDefaults standardUserDefaults] persistentDomainForName:kEMRDomain][kEMRRadiusKey];
    if (![n isKindOfClass:[NSNumber class]]) return 0.0;
    return MAX(0.0, [n doubleValue]);
}

static void (*emr_origLayout)(UIView *, SEL);
static void emr_layout(UIView *self, SEL _cmd) {
    emr_origLayout(self, _cmd);
    CGFloat radius = EMRRadius();
    if (radius <= 0.0 || !EMRIsEditMenuView(self)) return;
    // Preserve the system menu's frame, material, separators, labels, and actions.
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.layer.cornerRadius = MIN(radius, MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0);
    self.layer.masksToBounds = YES;
}

__attribute__((constructor)) static void EMRInit(void) {
    @autoreleasepool {
        Class view = [UIView class];
        Method m = class_getInstanceMethod(view, @selector(layoutSubviews));
        if (m && method_getImplementation(m) != (IMP)emr_layout)
            MSHookMessageEx(view, @selector(layoutSubviews), (IMP)emr_layout, (IMP *)&emr_origLayout);
    }
}
