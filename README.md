Breezy iOS SDK v1
============================

The Breezy iOS SDK allows app developers to easily integrate Breezy into new and existing apps.  The approach is simple.  Use our SDK to add a 'Print With Breezy' button into your app. When the user clicks the 'Print With Breezy' button we upload their document to our secure cloud storage location where the document is immediately encrypted and return a document_id.  Use the document_id to call open the Breezy app using our custom URL Schema.  If the Breezy app isn't installed on the device prompt the user to download Breezy.


Setup
----------------
The BreezySDK is bundled with the ASIHTTPRequest & JSON libraries. If you are already using them in your project skip this step as you've probably already added these.  If you are using another library to handle REST POST methods the Breezy SDK code must be to use your library.  If you have any problems please let us know, we are happy to help.

Add the following files to "Link Binary With Libraries"
- Open the settings for your target by clicking on the blue bar at the very top of the Xcode sidebar:
- Open the Build Phases tab, expand the box labeled Link Binary With Libraries then click the plus button.
- Add the following: 
- CFNetwork.framework
- SystemConfiguration.framework
- MobileCoreServices.framework
- CoreGraphics.framework
- libz.dylib

How to use
----------------

### Step 1 .h
```objective-c
#import "PrintModule.h"
#import "PrintModuleDelegate.h"
```

### Step 2 .h
Add the following delegates into your view controller
PrintModuleDelegate, UIAlertViewDelegate

### Step 3 Implement Breezy Callback methods in .m
```objective-c
//delegate fired when document start sending
-(void)sendingDocument 
```

```objective-c
//delegate fired when document fails
-(void)sendingDocumentFailed: (NSError *)error 
```

```objective-c
//delegate fired when document is sent successfully, returns documentId
-(void)sendingDocumentComplete:(int)documentId; 
```

### Step 4 .m
```objective-c
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:imageURL:progressView];
```

Example
----------------

For a working example see the Breezy SDK Example App
```objective-c
- (IBAction)printWithBreezy {
    
    //Confirm Breezy is installed on iOS before launching the Breezy app. 
    //If it's not installed then alert the user to download the app.
    NSString *stringURL = [[NSString alloc] initWithString:@"breezy://"];
    NSURL *url = [NSURL URLWithString:stringURL];
    if(![[UIApplication sharedApplication] canOpenURL:url])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Breezy Not Installed"
                                                          message:@"Breezy is the world's most secure mobile printing app.  Download it now to continue printing this document."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Download",nil];
        message.tag = 1;
        [message show];
    }
    else
    {
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:imageURL:progressView];
    }
}
```

```objective-c
//delegate fired when document start sending
-(void)sendingDocument
{   
    //Show a waiting dialog to inform the user the document is loading
    [selectButton setHidden:YES];
    [printButton setHidden:YES];
    [progressView setHidden:NO];
}

//delegate fired when document fails
-(void)sendingDocumentFailed: (NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"There was an error communicating with the Breezy print service.\nPlease try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
}
```

```objective-c
//delegate fired when document is sent successfully
-(void)sendingDocumentComplete:(int)documentId;
{
    [selectButton setHidden:NO];
    [printButton setHidden:NO];
    [progressView setHidden:YES];
    
    NSString *stringURL = [[NSString alloc] initWithFormat:@"breezy://document_id=%i&customUrl=%@",documentId,@"breezyphoto"];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
    [stringURL release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/app/breezy-print-and-fax/id438846342?mt=8&uo=6"]];
    }
}
```
