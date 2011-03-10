//
//  TextMacro2SnippetAppDelegate.h
//  TextMacro2Snippet
//
//  Created by ppm on 10/11/13.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TextMacro2SnippetAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (retain) IBOutlet NSWindow *window;

// Action
- (IBAction)startAction:(id)sender;

@end
