#import <Preferences/PSListController.h>

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController

// Root.plist supplies the slider. Do not dynamically create PSSpecifiers:
// iOS Settings crashes when the private cell class is constructed here.
- (NSArray *)specifiers {
    return [super specifiers];
}

@end
