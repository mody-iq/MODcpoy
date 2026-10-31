#include <objc/runtime.h>
#include <WebKit/WebKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 180000
@interface UIResponder (CanPerformActionHook)
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
@end

@interface WKWebView (CopyPasteHook)
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
- (void)_handleMenuRequestForHitNodeWith:(id)menu;
@end

@interface UIWebView (CopyPasteFix)
@end
#endif

%hook UIResponder
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(paste:) || action == @selector(select:)) {
        return YES;
    }
    return %orig(action, sender);
}
%end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
@interface UIWebBrowserView : UIViewController
@end

%hook UIWebBrowserView
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return YES;
}
%end
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
%hook UIWebView
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return YES;
}

- (id)menuItems {
    return [NSOrderedSet orderedSetWithArray:@[
        @{NSMenuItemActionKey: @selector(copy:)},
        @{NSMenuItemActionKey: @selector(paste:)},
        @{NSMenuItemActionKey: @selector(select:)}
    ]];
}
%end
#endif

%hook WKWebView
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return YES;
}

- (void)_handleMenuRequestForHitNodeWith:(id)menu {
    %orig;
    if (menu && [menu isKindOfClass:NSClassFromString(@"NSMenu")]) {
        NSEnumerator *enumerator = [menu itemEnumerator];
        NSMenuItem *item;
        while ((item = [enumerator nextObject])) {
            if ([item.action isEqual:@selector(copy:)] || [item.action isEqual:@selector(paste:)] || [item.action isEqual:@selector(select:)]) {
                item.enabled = YES;
                item.hidden = NO;
            }
        }
    }
}

- (id)menuItems {
    return [NSOrderedSet orderedSetWithArray:@[
        @{NSMenuItemActionKey: @selector(copy:), NSMenuItemTitleKey: @"Copy"},
        @{NSMenuItemActionKey: @selector(paste:), NSMenuItemTitleKey: @"Paste"},
        @{NSMenuItemActionKey: @selector(select:), NSMenuItemTitleKey: @"Select All"}
    ]];
}

- (id)makeMenuItems {
    return [self menuItems];
}
%end

%hook WKUserContentController
- (void)addUserScript:(id)userScript {
    %orig(userScript);
}
%end

%hook UIApplication
- (void)sendAction:(SEL)action to:(id)target fromSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(paste:)) {
    }
    %orig(action, target, sender);
}
%end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000
@interface WKWebView (ExtraCopyPasteHook)
- (BOOL)shouldAllowCopyAction:(id)arg1 withSender:(id)arg2;
@end

%hook WKWebView
- (BOOL)shouldAllowCopyAction:(id)arg1 withSender:(id)arg2 {
    return YES;
}
%end
#endif

%hook UIPasteboard
- (void)setString:(id)string {
    %orig(string);
}

- (id)string {
    return %orig;
}
%end

%hook SFLegacyBrowserViewController
- (BOOL)shouldAllowCopy:(id)command withSender:(id)sender {
    return YES;
}

- (BOOL)shouldAllowPaste:(id)command withSender:(id)sender {
    return YES;
}
%end

%hook SFContentViewController
- (BOOL)shouldAllowCopy:(id)command withSender:(id)sender {
    return YES;
}

- (BOOL)shouldAllowPaste:(id)command withSender:(id)sender {
    return YES;
}
%end

#if __IPHONE_OS_VERSION_MIN_ALLOWED < 110000
%hook UIWindow
- (BOOL)canBecomeKeyWindow {
    return YES;
}
%end
#endif

static void initialize(void) {
    NSLog(@"[MODcpoy] initialized for iOS 18.7 copy/paste bypass");
}

static void finishedLoading(void) {
    NSLog(@"[MODcpoy] ready - copy/paste should work now");
}

%ctor {
    initialize();
    finishedLoading();
}