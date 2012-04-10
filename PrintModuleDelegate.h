//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "Document.h"

@protocol PrintModuleDelegate <NSObject>

@optional
-(void)sendingDocument;
-(void)sendingDocumentFailed: (NSError *)error;
-(void)sendingDocumentComplete :(int)documentId;

@end
