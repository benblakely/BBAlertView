//  Copyright 2013 Ben Blakely. All rights reserved.
//  See included License file for licensing information.

#import "BBAlertView.h"

@interface BBAlertView () <UIAlertViewDelegate>

@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) NSMutableDictionary *clickedHandlersByButtonIndex;
@property (nonatomic) NSMutableDictionary *willDismissHandlersByButtonIndex;
@property (nonatomic) NSMutableDictionary *didDismissHandlersByButtonIndex;

@end

@implementation BBAlertView

+ (NSMutableSet *)alertViews {
    static NSMutableSet *_alertViews = nil;
    if (!_alertViews) {
        _alertViews = [NSMutableSet set];
    }
    return _alertViews;
}

- (id)init {
    return [self initWithTitle:nil message:nil cancelButtonTitle:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    self = [super init];
    if (!self) return nil;
    
    [self setClickedHandlersByButtonIndex:[NSMutableDictionary dictionary]];
    [self setWillDismissHandlersByButtonIndex:[NSMutableDictionary dictionary]];
    [self setDidDismissHandlersByButtonIndex:[NSMutableDictionary dictionary]];
    [self setAlertView:[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil]];
    
    if (cancelButtonTitle) {
        NSUInteger buttonIndex = [self addButtonWithTitle:title clicked:nil];
        [self setCancelButtonIndex:buttonIndex];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    [[self alertView] setTitle:title];
}

- (NSString *)title {
    return [[self alertView] title];
}

- (void)setMessage:(NSString *)message {
    [[self alertView] setMessage:message];
}

- (NSString *)message {
    return [[self alertView] message];
}

- (BOOL)isVisible {
    return [[self alertView] isVisible];
}

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle {
    [[self alertView] setAlertViewStyle:alertViewStyle];
}

- (UIAlertViewStyle)alertViewStyle {
    return [[self alertView] alertViewStyle];
}

- (NSInteger)addButtonWithTitle:(NSString *)title clicked:(void (^)(BBAlertView *alertView))handler {
    return [self addButtonWithTitle:title clicked:handler willDismiss:nil didDismiss:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title willDismiss:(void (^)(BBAlertView *alertView))handler {
    return [self addButtonWithTitle:title clicked:nil willDismiss:handler didDismiss:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title didDismiss:(void (^)(BBAlertView *alertView))handler {
    return [self addButtonWithTitle:title clicked:nil willDismiss:nil didDismiss:handler];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
                        clicked:(void (^)(BBAlertView *alertView))clickedHandler
                    willDismiss:(void (^)(BBAlertView *alertView))willDismissHandler
                     didDismiss:(void (^)(BBAlertView *alertView))didDismissHandler {
    NSInteger buttonIndex = [[self alertView] addButtonWithTitle:title];
    
    [self setHandler:clickedHandler buttonIndex:buttonIndex dictionary:[self clickedHandlersByButtonIndex]];
    [self setHandler:willDismissHandler buttonIndex:buttonIndex dictionary:[self willDismissHandlersByButtonIndex]];
    [self setHandler:didDismissHandler buttonIndex:buttonIndex dictionary:[self didDismissHandlersByButtonIndex]];
    
    return buttonIndex;
}

- (void)setHandler:(void (^)(BBAlertView *alertView))handler buttonIndex:(NSInteger)buttonIndex dictionary:(NSMutableDictionary *)dictionary {
    if (handler) {
        dictionary[@(buttonIndex)] = [handler copy];
    } else {
        [dictionary removeObjectForKey:@(buttonIndex)];
    }
}

- (NSInteger)numberOfButtons {
    return [[self alertView] numberOfButtons];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return [[self alertView] buttonTitleAtIndex:buttonIndex];
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
    return [[self alertView] textFieldAtIndex:textFieldIndex];
}

- (NSInteger)cancelButtonIndex {
    return [[self alertView] cancelButtonIndex];
}

- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex {
    [[self alertView] setCancelButtonIndex:cancelButtonIndex];
}

- (NSInteger)firstOtherButtonIndex {
    return [[self alertView] firstOtherButtonIndex];
}

- (void)show {
    [[[self class] alertViews] addObject:self];
    [[self alertView] show];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [[self alertView] dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^handler)(BBAlertView *alertView) = [self clickedHandlersByButtonIndex][@(buttonIndex)];
    if (handler) handler(self);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([self willDismissHandler]) [self willDismissHandler](self, buttonIndex);
    
    void (^handler)(BBAlertView *alertView) = [self willDismissHandlersByButtonIndex][@(buttonIndex)];
    if (handler) handler(self);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([self didDismissHandler]) [self didDismissHandler](self, buttonIndex);
    
    void (^handler)(BBAlertView *alertView) = [self didDismissHandlersByButtonIndex][@(buttonIndex)];
    if (handler) handler(self);
    
    [[[self class] alertViews] removeObject:self];
}

@end
