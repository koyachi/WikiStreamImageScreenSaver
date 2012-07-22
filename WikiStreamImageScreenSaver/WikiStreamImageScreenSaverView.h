//
//  WikiStreamImageScreenSaverView.h
//  WikiStreamImageScreenSaver
//
//  Created by koyachi on 12/07/22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>

@interface WikiStreamImageScreenSaverView : ScreenSaverView {
@private
    WebView* _webView;
}

@end
