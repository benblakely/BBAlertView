# BBAlertView

Life is easier with blocks but UIAlertView was built in a time before blocks. Enter BBAlertView.

With BBAlertView it’s far easier to keep code nice and simple, especially when you have multiple alert views per view controller or you need to pass around an object. For example:

    - (void)renameNote:(BBNote *)note {
        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:NSLocalizedString(@"Rename Note", nil) message:nil];
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [alertView addCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        
        [alertView addButtonWithTitle:NSLocalizedString(@"Rename", nil) clicked:^(BBAlertView *alertView) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            [note setName:[nameField text]];
        }];
        
        [alertView show];
    }

## Installation

1. [Download the files](https://github.com/benrblakely/BBAlertView/archive/master.zip).
2. Copy `BBAlertView.h` and `BBAlertView.m` into your project’s directory.
3. Drag the files into Xcode.
4. Add `#import "BBAlertView.h"` to your project’s prefix header, e.g. `MyApp-Prefix.pch`.
5. Enjoy!
