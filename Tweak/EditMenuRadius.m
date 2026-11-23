#import "EMR.h"
#import <objc/runtime.h>
#import <substrate.h>

static BOOL EMRIsMenuClass(Class cls) {
    if (!cls) return NO;
    NSString *n = NSStringFromClass(cls);
    return [n containsString:@"EditMenu"] ||
           [n containsString:@"UIMenu"] ||
           [n containsString:@"MenuBar"] ||
           [n containsString:@"ContextMenu"];
}

static CGFloat EMRRadius(void) {
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] persistentDomainForName:kEMRDomain];
    NSNumber *n = d[kEMRRadiusKey];
    return [n isKindOfClass:[NSNumber class]] ? MAX(0.0, n.doubleValue) : 0.0;
}

static void EMRApply(UIView *v, CGFloat r) {
    if (!v || !EMRIsMenuClass(v.class)) return;
    CGFloat maxR = MIN(CGRectGetWidth(v.bounds), CGRectGetHeight(v.bounds)) / 2.0;
    if (maxR <= 0.0) return;
    v.layer.cornerCurve = kCACornerCurveContinuous;
    v.layer.cornerRadius = MIN(r, maxR);
    v.layer.masksToBounds = YES;
}

static void (*emr_origLayout)(UIView *, SEL);
static void emr_layout(UIView *self, SEL cmd) {
    emr_origLayout(self, cmd);
    CGFloat r = EMRRadius();
    if (r <= 0.0) return;
    if (EMRIsMenuClass(self.class)) EMRApply(self, r);
    for (UIView *child in self.subviews) EMRApply(child, r);
}

__attribute__((constructor)) static void EMRInit(void) {
    @autoreleasepool {
        Method m = class_getInstanceMethod(UIView.class, @selector(layoutSubviews));
        if (m) MSHookMessageEx(UIView.class, @selector(layoutSubviews), (IMP)emr_layout, (IMP *)&emr_origLayout);
    }
}
