//
//  WikiStreamImageScreenSaverView.m
//  WikiStreamImageScreenSaver
//
//  Created by コヤチ ツトム on 12/07/22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WikiStreamImageScreenSaverView.h"

@implementation WikiStreamImageScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
