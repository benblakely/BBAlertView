//  Copyright 2013 Ben Blakely. All rights reserved.
//  See included License file for licensing information.

#import <Foundation/Foundation.h>

@interface BBAlertView : NSObject

@property (nonatomic) UIAlertViewStyle alertViewStyle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly) NSInteger numberOfButtons;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) NSInteger firstOtherButtonIndex;
@property (nonatomic, copy) void (^willDismissHandler)(BBAlertView *alertView, NSInteger buttonIndex);
@property (nonatomic, copy) void (^didDismissHandler)(BBAlertView *alertView, NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

- (NSInteger)addButtonWithTitle:(NSString *)title clicked:(void (^)(BBAlertView *alertView))handler;
- (NSInteger)addButtonWithTitle:(NSString *)title willDismiss:(void (^)(BBAlertView *alertView))handler;
- (NSInteger)addButtonWithTitle:(NSString *)title didDismiss:(void (^)(BBAlertView *alertView))handler;
- (NSInteger)addButtonWithTitle:(NSString *)title
                        clicked:(void (^)(BBAlertView *alertView))clicked
                    willDismiss:(void (^)(BBAlertView *alertView))willDismiss
                     didDismiss:(void (^)(BBAlertView *alertView))didDismiss;

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

- (void)show;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end
