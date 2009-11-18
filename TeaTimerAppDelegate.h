//
//  TeaTimerAppDelegate.h
//  TeaTimer
//
//  Created by Andre Torrez on 11/16/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NUMBER_OF_INTERVALS 10

@interface TeaTimerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow        *window;
    NSMenu          *status_menu;
    NSStatusItem    *status_item;

    NSImage         *empty_cup;
    NSImage         *brewing_cup;
    NSImage         *brewed_cup;
    
    NSTimer         *brew_timer;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,retain) NSTimer *brew_timer;

- (void)startNewInterval:(id)sender;
- (void)bringBackTheMainWindow:(id)sender;
- (void)cancelBrewing:(id)sender;
- (void)teaIsDone:(NSTimer *)timer;

@end
