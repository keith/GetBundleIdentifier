//
//  KBSAppDelegate.m
//  GetBundleIdentifier
//
//  Created by Keith Smiley on 7/24/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KBSAppDelegate.h"
#import "KBSWindowController.h"

@interface KBSAppDelegate ()

@property (nonatomic, strong) KBSWindowController *wc;

@end

@implementation KBSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.wc = [[KBSWindowController alloc] init];
    [self.wc showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    self.wc = nil;
}

@end
