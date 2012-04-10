//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
{
    NSString *documentName;
    NSString *extension;
    NSURL *documentPath;
    NSData *documentData;
}

@property (nonatomic, copy) NSString *documentName;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, retain) NSURL *documentPath;
@property (nonatomic, retain) NSData *documentData;

-(id)initWithDocumentPath:(NSURL *)urlToLoad;

@end
