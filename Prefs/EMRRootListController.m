#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface EMRRootListController : PSListController
@end

@implementation EMRRootListController
- (NSArray *)specifiers {
    if (_specifiers) return _specifiers;
    _specifiers = @[
        [PSSpecifier preferenceSpecifierNamed:@"编辑菜单圆角"
                    target:self set:@selector(setPreferenceValue:specifier:)
                    get:@selector(readPreferenceValue:) detail:Nil cell:PSSliderCell edit:Nil],
    ];
    PSSpecifier *slider = _specifiers[0];
    [slider setProperty:@0.0 forKey:@"default"];
    [slider setProperty:@0.0 forKey:@"min"];
    [slider setProperty:@80.0 forKey:@"max"];
    [slider setProperty:@"radius" forKey:@"key"];
    [slider setProperty:@"com.ning.editmenuradius" forKey:@"defaults"];
    [slider setProperty:@YES forKey:@"showValue"];
    return _specifiers;
}
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.ning.editmenuradius.changed"), NULL, NULL, YES);
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    id value = [super readPreferenceValue:specifier];
    return value ?: @0.0;
}
@end
