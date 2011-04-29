//
//  TextMacro2SnippetAppDelegate.m
//  TextMacro2Snippet
//
//  Created by ppm on 10/11/13.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "TextMacro2SnippetAppDelegate.h"

#import "PPFoundation.h"


@implementation TextMacro2SnippetAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)dealloc {

    [window release];
    [super dealloc];
}

- (IBAction)startAction:(id)sender
{
    NSOpenPanel* openPanel;
    openPanel = [NSOpenPanel openPanel];
    [openPanel setRequiredFileType:@"xctxtmacro"];
	[openPanel setMessage:@"Choose a .xctxtmacro file to convert."];
    
    NSInteger result;
    result = [openPanel runModal];
    if (result == NSCancelButton) {
        return;
    }
    
    NSURL* macroFileUrl;
    macroFileUrl = [openPanel URL];
    
    NSURL* url;
    
    url = macroFileUrl;
    url = [url URLByDeletingPathExtension];
    
    NSString* filename;
    filename = [url lastPathComponent];
    
    NSURL* destinationUrl;
    destinationUrl = [url URLByDeletingLastPathComponent];
    
    NSURL* snippetFolderUrl;
    snippetFolderUrl = destinationUrl;
    snippetFolderUrl = [snippetFolderUrl URLByAppendingPathComponent:filename];
    
    NSFileManager* fileManager;
    fileManager = [[NSFileManager alloc] init];
    
    [fileManager createDirectoryAtPath:[snippetFolderUrl path] withIntermediateDirectories:YES attributes:nil error:NULL];
    [fileManager release];
   
    NSArray* macroPlist;
    macroPlist = PPPropertyListFromContentsOfUrl(macroFileUrl);

    NSMutableArray* snippetPlist;
    snippetPlist = [[NSMutableArray alloc] initWithCapacity:[macroPlist count]];
    
    for (NSDictionary* item in macroPlist) {
        NSString* textString;
        textString = [item objectForKey:@"TextString"];
        if (!textString) {
            NSLog(@"Ignored: %@", item);
            
            continue;
        }
        
        NSMutableDictionary* snippetItem;
        snippetItem = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        [snippetItem setObject:PPUUIDString() forKey:@"IDECodeSnippetIdentifier"];
        [snippetItem setObject:[NSNumber numberWithBool:YES] forKey:@"IDECodeSnippetUserSnippet"];
        [snippetItem setObject:textString forKey:@"IDECodeSnippetContents"];
        [snippetItem setObject:@"Xcode.SourceCodeLanguage.Objective-C" forKey:@"IDECodeSnippetLanguage"];
        
        id value;
        NSString* name;
        
        value = [item objectForKey:@"Name"];
        if (value) {
            [snippetItem setObject:value forKey:@"IDECodeSnippetTitle"];
        }
#if 0   // Use uuid
        name = PPUUIDString();
#else   // Use name if available
        name = (value ?: PPUUIDString());
#endif
        
        value = [item objectForKey:@"CompletionPrefix"];
        if (value) {
            [snippetItem setObject:value forKey:@"IDECodeSnippetCompletionPrefix"];
        }
        
        value = [item objectForKey:@"IncludeContexts"];
        if (value) {
            [snippetItem setObject:value forKey:@"IDECodeSnippetIncludeContexts"];
        }
        
        value = [item objectForKey:@"ExcludeContexts"];
        if (value) {
            [snippetItem setObject:value forKey:@"IDECodeSnippetExcludeContexts"];
        }
        
        NSData* snippetData;
        snippetData = [NSPropertyListSerialization dataWithPropertyList:snippetItem format:NSPropertyListXMLFormat_v1_0 options:0 error:NULL];
    
        NSURL* snippetFileUrl;
        snippetFileUrl = snippetFolderUrl;
        snippetFileUrl = [snippetFileUrl URLByAppendingPathComponent:name];
        snippetFileUrl = [snippetFileUrl URLByAppendingPathExtension:@"codesnippet"];
        
        [snippetData writeToURL:snippetFileUrl atomically:YES];
        
        [snippetPlist addObject:snippetItem];
        [snippetItem release];
    }
    
    [snippetPlist release];
}



@end
