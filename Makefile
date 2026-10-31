THEOS_DEVICE_ARCH = arm64e
THEOS_DEVICE_ARCH_IPHONEOS = arm64e
TARGET = ios:latest
ROOTLESS = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MODcpoy
MODcpoy_FILES = Tweak.xm
MODcpoy_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
MODcpoy_FRAMEWORKS = WebKit
MODcpoy_CFLAGS = -fobjc-arc
MODcpoy_LDFLAGS = -lz -framework WebKit

include $(THEOS)/makefiles/tweak.mk