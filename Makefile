include theos/makefiles/common.mk

BUNDLE_NAME = QuickNote
QuickNote_FILES = QuickNoteController.m
QuickNote_INSTALL_PATH = /System/Library/WeeAppPlugins/
QuickNote_FRAMEWORKS = QuartzCore UIKit


include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
