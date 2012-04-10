//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import "Document.h"


@implementation Document

@synthesize documentName, extension, documentPath, documentData;

//initializes the document object with the file that was opened
-(id)initWithDocumentPath:(NSURL *)urlToLoad
{
    if ((self = [super init]))
    {
        self.documentPath = urlToLoad;
        
        NSError *error = nil;
        
        NSFileHandle *documentFileHandle = [NSFileHandle fileHandleForReadingFromURL:self.documentPath error:&error];
        
        if (error || documentFileHandle == nil)
        {
        
        }
        else
        {
            NSArray *pathParts = [[self.documentPath path] componentsSeparatedByString:@"/"];
            self.documentName = [pathParts objectAtIndex:[pathParts count]-1];
            
            NSArray *extensionParts = [self.documentName componentsSeparatedByString:@"."];
            self.extension = [extensionParts objectAtIndex:[extensionParts count]-1];
            
            self.documentData = [documentFileHandle readDataToEndOfFile];
            
            [documentFileHandle closeFile];
        }
    }
    
    return self;
}

#pragma teardown

-(void)dealloc
{
    [documentName release];
    [extension release];
    [documentPath release];
    [documentData release];
    
    [super dealloc];
}

@end
