#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSListController : UIViewController
@property(nonatomic, retain) NSMutableArray *specifiers;
- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController

- (NSArray *)specifiers {
    if (!self.specifiers) {
        self.specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return self.specifiers;
}

@end
