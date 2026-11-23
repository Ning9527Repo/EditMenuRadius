#import "EMR.h"
#import <objc/runtime.h>
#import <substrate.h>

static CGFloat EMRRadius(void) {
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] persistentDomainForName:kEMRDomain];
    NSNumber *n = d[kEMRRadiusKey];
    return [n isKindOfClass:[NSNumber class]] ? MAX(0.0, n.doubleValue) : 0.0;
}

static BOOL EMRIsMenuName(NSString *name) {
    return [name containsString:@"EditMenu"] || [name containsString:@"MenuBar"] ||
           [name containsString:@"ContextMenu"] || [name containsString:@"UIMenuController"] ||
           [name containsString:@"SelectionView"];
}

static void EMRApply(UIView *v, CGFloat radius) {
    if (v.bounds.size.width <= 0 || v.bounds.size.height <= 0) return;
    CGFloat limit = MIN(v.bounds.size.width, v.bounds.size.height) * 0.5;
    v.layer.cornerCurve = kCACornerCurveContinuous;
    v.layer.cornerRadius = MIN(radius, limit);
    v.layer.masksToBounds = YES;
}

static void EMRScan(UIView *v, CGFloat radius, NSUInteger depth) {
    if (!v || depth > 12) return;
    if (EMRIsMenuName(NSStringFromClass(v.class))) EMRApply(v, radius);
    for (UIView *child in v.subviews) EMRScan(child, radius, depth + 1);
}

static void (*emr_origLayout)(UIView *, SEL);
static void emr_layout(UIView *self, SEL cmd) {
    if (emr_origLayout) emr_origLayout(self, cmd);
    CGFloat radius = EMRRadius();
    if (radius > 0.0) EMRScan(self, radius, 0);
}

__attribute__((constructor)) static void EMRInit(void) {
    Method method = class_getInstanceMethod(UIView.class, @selector(layoutSubviews));
    if (method && method_getImplementation(method) != (IMP)emr_layout) {
        MSHookMessageEx(UIView.class, @selector(layoutSubviews), (IMP)emr_layout, (IMP *)&emr_origLayout);
    }
}
