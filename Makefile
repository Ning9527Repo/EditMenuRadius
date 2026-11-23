ARCHS = arm64e
TARGET = iphone:clang:latest:16.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EditMenuRadius
EditMenuRadius_FILES = Tweak/EditMenuRadius.m
EditMenuRadius_CFLAGS = -fobjc-arc
EditMenuRadius_FRAMEWORKS = UIKit
EditMenuRadius_LIBRARIES = substrate

BUNDLE_NAME = EditMenuRadius
EditMenuRadius_PREFS_FILES = Prefs/EMRRootListController.m
EditMenuRadius_PREFS_INSTALL_PATH = /Library/PreferenceBundles
EditMenuRadius_PREFS_FRAMEWORKS = UIKit
EditMenuRadius_PREFS_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp layout/Library/MobileSubstrate/DynamicLibraries/EditMenuRadius.plist $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(ECHO_END)
	$(ECHO_NOTHING)cp layout/Library/PreferenceLoader/Preferences/EditMenuRadius.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
