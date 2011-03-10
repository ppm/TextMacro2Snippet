/*
 PPFoundation.h

 Author: ppm

 Copyright 2011 ppm. All rights reserved.
*/

#import <Foundation/Foundation.h>


@interface PPFoundation : NSObject {

}

@end

NSString*	PPUUIDString();
id			PPPropertyListFromContentsOfUrl(NSURL* url);
