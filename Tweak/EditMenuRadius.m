#import "EMR.h"
#import <objc/runtime.h>
#import <substrate.h>

static CGFloat EMRRadius(void) {
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] persistentDomainForName:kEMRDomain];
    NSNumber *n = d[kEMRRadiusKey];
    return [n isKindOfClass:[NSNumber class]] ? MAX(0.0, n.doubleValue) : 0.0;
}

static BOOL EMRMenuClass(Class cls) {
    NSString *n = NSStringFromClass(cls);
    return [n containsString:@"EditMenu"] || [n containsString:@"MenuBar"] ||
           [n containsString:@"ContextMenu"] || [n containsString:@"UIMenuController"];
}

static void EMRApply(UIView *v, CGFloat r) {
    if (!v || v.bounds.size.width <= 0 || v.bounds.size.height <= 0) return;
    v.layer.cornerCurve = kCACornerCurveContinuous;
    v.layer.cornerRadius = MIN(r, MIN(v.bounds.size.width, v.bounds.size.height) / 2.0);
    v.layer.masksToBounds = YES;
}

static void EMRApplyTree(UIView *v, CGFloat r) {
    if (EMRMenuClass(v.class)) EMRApply(v, r);
    for (UIView *child in v.subviews) EMRApplyTree(child, r);
}

typedef void (*EMRLayoutIMP)(id, SEL);
typedef struct { Class cls; EMRLayoutIMP orig; } EMRHook;
static EMRHook gHooks[128];
static NSUInteger gHookCount;
static BOOL gInstalling;

static EMRLayoutIMP EMROriginalForClass(Class cls) {
    for (NSUInteger i = 0; i < gHookCount; i++) if (gHooks[i].cls == cls) return gHooks[i].orig;
    return NULL;
}

static void EMRLayout(id self, SEL cmd) {
    Class cls = object_getClass(self);
    EMRLayoutIMP orig = EMROriginalForClass(cls);
    if (orig) orig(self, cmd);
    CGFloat r = EMRRadius();
    if (r > 0.0) EMRApplyTree((UIView *)self, r);
}

static void EMRInstallClass(Class cls) {
    if (!cls || gHookCount >= 128 || !EMRMenuClass(cls)) return;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    Method m = NULL;
    for (unsigned int i = 0; i < methodCount; i++) {
        if (method_getName(methods[i]) == @selector(layoutSubviews)) {
            m = methods[i];
            break;
        }
    }
    free(methods);
    if (!m) return;
    IMP old = method_getImplementation(m);
    if (old == (IMP)EMRLayout) return;
    gHooks[gHookCount++] = (EMRHook){ cls, (EMRLayoutIMP)old };
    method_setImplementation(m, (IMP)EMRLayout);
}

__attribute__((constructor)) static void EMRInit(void) {
    @autoreleasepool {
        if (gInstalling) return;
        gInstalling = YES;
        int count = objc_getClassList(NULL, 0);
        __unsafe_unretained Class *classes = (__unsafe_unretained Class *)calloc((size_t)count, sizeof(Class));
        count = objc_getClassList(classes, count);
        for (int i = 0; i < count; i++) EMRInstallClass(classes[i]);
        free(classes);
    }
}
