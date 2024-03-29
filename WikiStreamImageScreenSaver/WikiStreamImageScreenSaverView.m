//
//  WikiStreamImageScreenSaverView.m
//  WikiStreamImageScreenSaver
//
//  Created by koyachi on 12/07/22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WikiStreamImageScreenSaverView.h"

#define SOURCE_URL @"http://wikistream.inkdroid.org/"

// http://userstyles.org/styles/69744/wikistream-screensaver
#define USER_STYLE @"#updatePanel, header, img[alt=\"Fork me on GitHub\"] { display: none; }"

@implementation WikiStreamImageScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        _webView = [[WebView alloc] initWithFrame:[self bounds]];
        [_webView setFrameLoadDelegate:self];
        [_webView setShouldUpdateWhileOffscreen:YES];
        [_webView setPolicyDelegate:self];
        [_webView setUIDelegate:self];
        [_webView setEditingDelegate:self];
        [_webView setResourceLoadDelegate:self];
        [_webView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        [_webView setAutoresizesSubviews:YES];
        [_webView setMainFrameURL:SOURCE_URL];

        {
            // via http://www.yoheim.net/blog.php?q=20120718
            // 最初webView:resource:didFinishLoadingFromDataSource:でやってたけど最初チラッと映るのでやめた
            NSString* css = USER_STYLE;
            NSMutableString* js = [NSMutableString string];
            [js appendString:@"window.onload = function(){"];
            [js appendString:@"  var style = document.createElement('style');"];
            [js appendString:@"  style.type = 'text/css';"];
            [js appendFormat:@"  var cssContent = document.createTextNode('%@'); ", css];
            [js appendString:@"  style.appendChild(cssContent);"];
            [js appendString:@"  document.body.appendChild(style);"];
            [js appendString:@"};"];
            [_webView stringByEvaluatingJavaScriptFromString:js];
        }
        
        [self setAnimationTimeInterval:1/30.0];
        [self addSubview:_webView];
        _urls = [[NSMutableArray new] autorelease];
        [self pushUrlToPasteboard:@"hello, world!!!!!"];
    }
    return self;
}

/*
  TODO: ARCでこういうの書かなくてよくなったんだっけ?っていうのを確認する
- (void)dealloc {
    [_webView release];
}
*/

- (void)pushUrlToPasteboard:(NSString*)url {
    [_urls addObject:url];
    if ([_urls count] > 20)
        [_urls removeObjectAtIndex:0];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:_urls];
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


#pragma mark WebPolicyDelegate

- (void)webView:(WebView*)webView
  decidePolicyForNewWindowAction:(NSDictionary*)actionInformation
           request:(NSURLRequest*)request
      newFrameName:(NSString*)frameName
  decisionListener:(id < WebPolicyDecisionListener >)listener {
    // don't open new windows.
    [listener ignore];
}

- (void)webView:(WebView*)webView didFinishLoadForFrame:(WebFrame*)frame {
    [webView resignFirstResponder];
    [[[webView mainFrame] frameView] setAllowsScrolling:NO];
}


#pragma mark WebUIDelegate

- (NSResponder*)webViewFirstResponder:(WebView*)sender {
    return self;
}

- (void)webViewClose:(WebView*)sender {
    return;
}


#pragma mark WebResourceLoadDelegate

- (id)webView:(WebView*)sender identifierForInitiaRequest:(NSURLRequest*)request fromDataSource:(WebDataSource*)dataSource {
    return request;
}

- (void)webView:(WebView*)sender resource:(id)identifier didReceiveResponse:(NSURLResponse*)response fromDataSource:(WebDataSource*)dataSource {
    NSString* url = [[response URL] absoluteString];
    NSString* wikimediaCommonsRequest = @"http://wikistream.inkdroid.org/commons-image/";
    if ([url hasPrefix:wikimediaCommonsRequest]) {
        NSString* path = [url substringFromIndex:[wikimediaCommonsRequest length]];
        [self pushUrlToPasteboard:[NSString stringWithFormat:@"http://commons.wikimedia.org/wiki/%@", path]];
    }
}

@end
