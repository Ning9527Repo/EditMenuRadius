#import <Preferences/PSListController.h>

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

@end
