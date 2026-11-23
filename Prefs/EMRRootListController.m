#import <Preferences/PSListController.h>

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController

- (NSArray *)specifiers {
    NSMutableArray *loaded = (NSMutableArray *)[super specifiers];
    if (!loaded) {
        NSArray *source = [self loadSpecifiersFromPlistName:@"Root" target:self];
        loaded = source ? [NSMutableArray arrayWithArray:source] : [NSMutableArray array];
        [self setSpecifiers:loaded];
    }
    return loaded;
}

@end
