include theos/makefiles/common.mk

BUNDLE_NAME = QuickNote
QuickNote_FILES = QuickNoteController.m
QuickNote_INSTALL_PATH = /Library/WeeLoader/Plugins/
QuickNote_FRAMEWORKS = QuartzCore CoreGraphics UIKit


include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
