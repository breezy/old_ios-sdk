//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import "PrintModule.h"

#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface PrintModule ()

@end

@implementation PrintModule

NSOperationQueue *requestQueue;

@synthesize delegate, requestQueue;

#pragma logic
-(void)sendDocumentToBreezy:(NSURL *)documentUrl:(UIProgressView *)progressIndicator
{
    //Breezy will provide you with a clientId and ClientSecret that can be used in production
    //The keys provided in this application will only work in test environment.
    NSString *testBaseUrl = [[NSString alloc] initWithString:@"https://apitest.breezy.com/"];
    NSString *prodBaseURL = [[NSString alloc] initWithString:@"https://api.breezy.com/"]; 
    NSString *clientId =  [[NSString alloc] initWithString:@"7663e72b-2296-4ab0-8192-def01c99d32f"];
    NSString *clientSecret =  [[NSString alloc] initWithString:@"1f1a5f7e-f642-41a2-ad1e-7d5d3e7df775"];
    
    
    Document *documentToPrint = [[Document alloc] initWithDocumentPath:documentUrl];;
    NSMutableData *mutableDocData = [[NSMutableData alloc] initWithData:documentToPrint.documentData];
    NSString *url = [[NSString alloc] initWithFormat:@"%@breezy_cloud_print?friendly_name=%@&file_extension=%@&client_id=%@&client_secret=%@", testBaseUrl, [documentToPrint.documentName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], documentToPrint.extension, clientId, clientSecret];
    ![self requestQueue] ? [self setRequestQueue:[[[NSOperationQueue alloc] init] autorelease]] : nil;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: url]];
    [url release];
    [request setDelegate:self];
    
    if (progressIndicator != nil)
    {
        [request setUploadProgressDelegate:progressIndicator];
    }
    
    [request addRequestHeader:@"content-type" value:@"application/octet-stream"];
    [request setPostBody:mutableDocData];
    [mutableDocData release];
    [request setDidStartSelector:@selector(sendingDocument)];
    [request setDidFailSelector:@selector(sendingRequestFailed:)];
    [request setDidFinishSelector:@selector(sendingDocumentCompleteParse:)];
    [[self requestQueue] addOperation:request];
    
    [testBaseUrl release];
    [prodBaseURL release];
    [clientId release];
    [clientSecret release];
    
    [documentToPrint release];
}


//delegate method used for showing that the document is printing
-(void)sendingDocument
{
    if([[self delegate] respondsToSelector:@selector(sendingDocument)])
    {
        [[self delegate] sendingDocument];
    }
}

//delegate method used for showing that the print request has failed
-(void)sendingRequestFailed: (ASIHTTPRequest *)request
{
    [self sendingDocumentFailed:[request error]];
}

//delegate method used for logging an error that the printing request has failed
-(void)sendingDocumentFailed:(NSError *)error
{
    if([[self delegate] respondsToSelector:@selector(sendingDocumentFailed:)])
    {
        [[self delegate] sendingDocumentFailed:error];
    }
}

-(void)sendingDocumentCompleteParse: (ASIHTTPRequest *)request
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseStringDictionary = [jsonParser objectWithString:request.responseString error:nil];
    [jsonParser release], jsonParser = nil;
    int documentId = [[responseStringDictionary objectForKey:@"document_id"] intValue];
    [self sendingDocumentComplete:documentId];
}


//delegate method used for showing that the printing is complete
-(void)sendingDocumentComplete: (int)documentId
{
     
    if([[self delegate] respondsToSelector:@selector(sendingDocumentComplete:)])
    {
        [[self delegate] sendingDocumentComplete:documentId];
    }
}

//Used to cancel printing by clearing the delegates
-(void)cancelPrinting
{
    for (ASIHTTPRequest *request in self.requestQueue.operations) 
    {
        [request clearDelegatesAndCancel];
        request.uploadProgressDelegate = nil;
    }
}

- (void)dealloc
{
    for (ASIHTTPRequest *request in self.requestQueue.operations) 
    {
        [request clearDelegatesAndCancel];
        request.uploadProgressDelegate = nil;
    }
    
    [super dealloc];
}

@end
