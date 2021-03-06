//
//  TeaTimerAppDelegate.h
//  TeaTimer
//
//  Created by Andre Torrez on 11/16/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NUMBER_OF_INTERVALS 10
#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface TeaTimerAppDelegate : NSObject  {
#else
@interface TeaTimerAppDelegate : NSObject <NSApplicationDelegate> {
#endif
    NSWindow        *window;
    NSWindow        *first_run_window;
    IBOutlet NSMenu *status_menu;
    NSStatusItem    *status_item;

    NSImage         *empty_cup;
    NSImage         *brewing_cup;
    NSImage         *brewed_cup;
    
    NSTimer         *brew_timer;
    NSTimer         *reset_icon_timer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *first_run_window;
@property (nonatomic,retain) NSTimer *brew_timer;
@property (nonatomic,retain) NSTimer *reset_icon_timer;

- (void)startNewInterval:(id)sender;
- (void)bringBackTheMainWindow:(id)sender;
- (void)cancelBrewing:(id)sender;
- (void)teaIsDone:(NSTimer *)timer;
- (void)resetStatusMenuIcon:(id)sender;

@end
