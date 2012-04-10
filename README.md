Breezy iOS SDK v1
============================

Don't reinvent the printing wheel. Use the Breezy iOS SDK to **let your users print documents in minutes**!

Setup
----------------


The BreezySDK is bundled with the [ASIHTTP](https://github.com/pokeb/asi-http-request/tree) & [SBJSON](https://github.com/stig/json-framework/) libraries. If you are already using them in your project skip this step as you've probably already added these.  If you are using another library to handle REST POST operations the Breezy SDK code must be modified to use your library. If you have any problems please let us know, we are happy to help!

Add the following files to "Link Binary With Libraries":

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

### Step 1 - Import Breezy into the desired .h file
```objc
#import "PrintModule.h"
#import "PrintModuleDelegate.h"
```

### Step 2 - Add the Breezy Delegate Module to the desired .h file
Add the following delegates into your view controller
```objc
<PrintModuleDelegate, UIAlertViewDelegate>
```

### Step 3 - Implement Breezy Callback methods in the desired .m file
```objc
//delegate fired when document start sending
-(void)sendingDocument 
```

```objc
//delegate fired when document fails
-(void)sendingDocumentFailed: (NSError *)error 
```

```objc
//delegate fired when document is sent successfully, returns documentId
-(void)sendingDocumentComplete:(int)documentId; 
```

### Step 4 - Allocate an instance of Breezy, set the delegate, and pass the NSURL to Breezy
```objc
	//aURL = NSURL path to the document
	//progressView = UIProgressView that will be reflect the progress of the document upload
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:aURL:progressView];
```

Example
----------------

For a working example see the Breezy SDK Example App
```objc
- (IBAction)printWithBreezy 
{
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
	//aURL = NSURL path to the document
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:aURL:progressView];
    }
}
```

```objc
//delegate fired when document start sending
-(void)sendingDocument
{   
    //Show UIProgressView to inform the user the document is loading
}
```

```objc
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

```objc
//delegate fired when document is sent successfully
-(void)sendingDocumentComplete:(int)documentId;
{
	//The Breezy app will return to your application when printing is complete. Just pass your URLSchema name here
	NSString *callBackUrlSchema = [[NSString alloc] initWithString:@"breezyphoto"];

    NSString *stringURL = [[NSString alloc] initWithFormat:@"breezy://document_id=%i&customUrl=%@",documentId,callBackUrlSchema];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
    [stringURL release];
}
```
```objc
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/app/breezy-print-and-fax/id438846342?mt=8&uo=6"]];
    }
}
```
