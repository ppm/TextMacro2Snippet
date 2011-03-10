/*
 PPFoundation.m

 Author: ppm

 Copyright 2011 ppm. All rights reserved.
*/

#import "PPFoundation.h"


@implementation PPFoundation

@end


NSString* PPUUIDString()
{
	CFUUIDRef uuid;
    NSString* uuidString;
    uuid = CFUUIDCreate(NULL);
    uuidString = (NSString*)CFUUIDCreateString(NULL, uuid);
    [uuidString autorelease];
    CFRelease(uuid);
	
	return uuidString;
}

id PPPropertyListFromContentsOfUrl(NSURL* url)
{
	NSData* data;
	data = [[NSData alloc] initWithContentsOfURL:url];
	
	id plist;
	NSError* error = nil;
	plist = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:&error];
	if (!plist) {
		NSLog(@"Error occured while deserializing plist: %@", error);
	}
	
	return plist;
}
