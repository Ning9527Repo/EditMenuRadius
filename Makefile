ARCHS = arm64e
TARGET = iphone:clang:latest:16.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EditMenuRadiusTweak
EditMenuRadiusTweak_FILES = Tweak/EditMenuRadius.m
EditMenuRadiusTweak_CFLAGS = -fobjc-arc
EditMenuRadiusTweak_FRAMEWORKS = UIKit
EditMenuRadiusTweak_LIBRARIES = substrate

BUNDLE_NAME = EditMenuRadiusPrefs
EditMenuRadiusPrefs_FILES = Prefs/EMRRootListController.m
EditMenuRadiusPrefs_INSTALL_PATH = /Library/PreferenceBundles
EditMenuRadiusPrefs_FRAMEWORKS = UIKit
EditMenuRadiusPrefs_LDFLAGS = -Wl,-undefined,dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-all::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries $(THEOS_STAGING_DIR)/Library/PreferenceBundles/EditMenuRadiusPrefs.bundle/Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp layout/Library/MobileSubstrate/DynamicLibraries/EditMenuRadius.plist $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(ECHO_END)
	$(ECHO_NOTHING)cp layout/Library/PreferenceLoader/Preferences/EditMenuRadius.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
	$(ECHO_NOTHING)cp Prefs/Info.plist $(THEOS_STAGING_DIR)/Library/PreferenceBundles/EditMenuRadiusPrefs.bundle/$(ECHO_END)
	$(ECHO_NOTHING)cp Prefs/Root.plist $(THEOS_STAGING_DIR)/Library/PreferenceBundles/EditMenuRadiusPrefs.bundle/$(ECHO_END)
	$(ECHO_NOTHING)cp Prefs/Root.plist $(THEOS_STAGING_DIR)/Library/PreferenceBundles/EditMenuRadiusPrefs.bundle/Resources/$(ECHO_END)
