//
//  TeaTimerAppDelegate.m
//  TeaTimer
//
//  Created by Andre Torrez on 11/16/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "TeaTimerAppDelegate.h"

@implementation TeaTimerAppDelegate

@synthesize window;
@synthesize first_run_window;
@synthesize brew_timer;
@synthesize reset_icon_timer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[window makeKeyAndOrderFront:nil];

    //grabbing a spot on the status bar 
    status_item = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];

    NSBundle *bundle = [NSBundle mainBundle];
    
    [status_menu setAutoenablesItems:NO];
    brewing_cup	= [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Brewing" ofType:@"png"]];
    empty_cup	= [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Empty" ofType:@"png"]];
    brewed_cup  = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Brewed" ofType:@"png"]];
    
    //Sets the images in our NSStatusItem
    [status_item setImage:empty_cup];
    //[statusItem setAlternateImage:statusHighlightImage];
    
    //Tells the NSStatusItem what menu to load
    [status_item setMenu:status_menu];

    //Sets the tooptip for our item
    [status_item setToolTip:@"Tea Is Good"];

    //Enables highlighting
    //[statusItem setHighlightMode:YES];
	
    //set the disconnect option to disabled
	//[disconnectItem setEnabled:NO];
    
    //now fill our menu with numbers 1 to 10 representing each interval
    for(int i = 1; i <= NUMBER_OF_INTERVALS; i++)
    {
        NSMenuItem *item;
        item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%d", i] action:@selector(startNewInterval:) keyEquivalent:@""];
        [status_menu insertItem:item atIndex:i-1];
        [item setEnabled:YES];
        [item setTag:i];
        [item release];
    }
    
    //have we ever run before?
    NSUserDefaults *preferences = [[NSUserDefaults standardUserDefaults] retain];    
    int has_ever_run = [preferences integerForKey:@"has_ever_run"];
    if (has_ever_run == 0)
    {
     	[first_run_window makeKeyAndOrderFront:nil];
        [preferences setInteger:1 forKey:@"has_ever_run"];
    } else {
        [first_run_window orderOut:nil];
    }
    [preferences release];
}


- (void)dealloc
{
    [brew_timer invalidate];
    [brew_timer release];
    [status_item release];
    [brewing_cup release];
    [empty_cup release];
    [brewed_cup release];
    [super dealloc];
}

- (void)bringBackTheMainWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:nil];

}

- (void)startNewInterval:(id)sender
{
    [self cancelBrewing:sender];
    
    [reset_icon_timer invalidate];
    reset_icon_timer = nil;
    
    if (([sender tag] > 0) && ([sender tag] < (NUMBER_OF_INTERVALS + 1))) {      
        brew_timer = [NSTimer scheduledTimerWithTimeInterval:([sender tag] * 60) target:self selector:@selector(teaIsDone:) userInfo:nil repeats:NO];
        [status_item  setImage:brewing_cup];
    }
}

- (void)teaIsDone:(NSTimer*)timer
{
    [brew_timer invalidate];
    brew_timer = nil;

    
    NSUserDefaults *preferences = [[NSUserDefaults standardUserDefaults] retain];    
    int alert_sound = [preferences integerForKey:@"alertWithSound"];
    int alert_icon = [preferences integerForKey:@"alertWithIconBounce"];
    
    if (alert_sound == 1)
    {
        NSSound *glass_sound = [NSSound soundNamed:@"Glass"];
        [glass_sound play];
    } 
    
    if (alert_icon == 1)
    {
        [NSApp requestUserAttention:NSCriticalRequest];
    }
    
    [preferences release];
        
    
    [status_item setImage:brewed_cup];
    //reset the icon in ten minutes to an empty cup.
    reset_icon_timer = [NSTimer scheduledTimerWithTimeInterval:(10 * 60) target:self selector:@selector(resetStatusMenuIcon:) userInfo:nil repeats:NO];

}

- (void)cancelBrewing:(id)sender
{
    [brew_timer invalidate];
    brew_timer = nil;
    
    for(int i = 0; i < NUMBER_OF_INTERVALS; i++)
    {
        NSMenuItem *item = [status_menu itemAtIndex:i];
        if ([sender tag] == [item tag]) {
            [item setState:NSOnState];
        } else {
            [item setState:NSOffState];
        }
    }
}

- (void)resetStatusMenuIcon:(id)sender
{
    [status_item setImage:empty_cup];
    reset_icon_timer = nil;
}

@end
