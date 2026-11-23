#import <Preferences/PSListController.h>

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController

- (NSArray *)specifiers {
    NSArray *loaded = [super specifiers];
    if (!loaded) {
        loaded = [self loadSpecifiersFromPlistName:@"Root" target:self];
        [self setSpecifiers:loaded];
    }
    return loaded;
}

@end
