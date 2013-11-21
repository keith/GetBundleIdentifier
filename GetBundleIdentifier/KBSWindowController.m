//
//  KBSWindowController.m
//  GetBundleIdentifier
//
//  Created by Keith Smiley on 7/24/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KBSWindowController.h"

@interface KBSWindowController ()

@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KBSWindowController

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

- (void)loadWindow {
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 100, 300, 500) styleMask:(NSTitledWindowMask | NSClosableWindowMask) backing:NSBackingStoreBuffered defer:false];
    [self.window setDelegate:self];
    [self.window setLevel:NSFloatingWindowLevel];
    NSView *contentView = [[NSView alloc] initWithFrame:self.window.frame];
    [self.window setContentView:contentView];

    self.textView = [[NSTextView alloc] init];
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.textView setTextContainerInset:NSMakeSize(2, 5)];
    [self.textView setFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]];
    [self.textView setEditable:false];
    [self.textView setSelectable:true];
    [self.textView setHorizontallyResizable:true];

    NSScrollView *scrollView = [[NSScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:false];
    [scrollView setBorderType:NSBezelBorder];
    [scrollView setHasVerticalScroller:true];
    [scrollView setHasHorizontalScroller:false];
    [scrollView setAutohidesScrollers:true];
    [scrollView setDocumentView:self.textView];

    [contentView addSubview:scrollView];

    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, _textView);
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_textView]-|" options:kNilOptions metrics:nil views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:kNilOptions metrics:nil views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[scrollView]-|" options:kNilOptions metrics:nil views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[scrollView]-|" options:kNilOptions metrics:nil views:views]];

//    [self.window visualizeConstraints:contentView.constraints];
}

- (void)showWindow:(id)sender {
    if (!self.window) {
        [self loadWindow];
    }

    [super showWindow:sender];
    [self startMonitoring];
}

- (void)startMonitoring {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(printCurrentApplication) userInfo:nil repeats:true];
}

- (void)stopMonitoring {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)printCurrentApplication {
    NSString *identifier = [[[NSWorkspace sharedWorkspace] frontmostApplication] bundleIdentifier];
    NSString *currentText = [self.textView string];
    if ([currentText rangeOfString:identifier].location == NSNotFound) {
        NSString *newText = [currentText stringByAppendingFormat:@"%@\n", identifier];
        [self.textView setString:newText];
    }

    NSLog(@"%@", identifier);
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    [self stopMonitoring];
}

@end
