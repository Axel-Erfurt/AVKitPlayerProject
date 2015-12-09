//
//  Document.m
//  NPlayer
//
//  Created by Axel Schneider on 08.12.15.
//  Copyright (c) 2015 Axel Schneider. All rights reserved.
//

#import "Document.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <objc/runtime.h>

@interface Document ()
@property (weak) IBOutlet AVPlayerView *playerView;

@property AVPlayer *player;
@property NSURL *myurl;
@property(nonatomic, readonly) CGSize naturalSize;

@end

@implementation Document

- (NSString *)windowNibName {
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    
    [super windowControllerDidLoadNib:aController];
    
    aController.window.titleVisibility = NSWindowTitleHidden;
    aController.window.titlebarAppearsTransparent = true;
    aController.window.movableByWindowBackground  = true;
    aController.window.aspectRatio = NSMakeSize(1.7777777778,1.0);
    //aController.window.acceptsMouseMovedEvents = true;
    aController.window.level = 1;
    
    NSButton *closeButton = [aController.window standardWindowButton:NSWindowCloseButton];
    [closeButton setHidden:YES];
    NSButton *minimizeButton = [aController.window standardWindowButton:NSWindowMiniaturizeButton];
    [minimizeButton setHidden:YES];
    NSButton *maximizeButton = [aController.window standardWindowButton:NSWindowZoomButton];
    [maximizeButton setHidden:YES];
    
    self.playerView.player = _player;
    self.playerView.showsFrameSteppingButtons = false;
    self.playerView.showsFullScreenToggleButton = true;
    self.playerView.controlsStyle = 1;
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_myurl options:nil];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    _naturalSize = track.naturalSize;
    
    int w = _naturalSize.width;
    int h = _naturalSize.height;
    float ratio = (float)w/h;
    
    [aController.window setFrame:NSMakeRect(0.f, 0.f, _naturalSize.width, _naturalSize.height) display:YES animate:YES];
    aController.window.minSize = NSMakeSize(220, 220 / ratio);
    
    aController.window.aspectRatio = NSMakeSize(ratio,1.0);
    
    [aController.window displayIfNeeded];
    [aController.window display] ;
    
//    NSString *pathstr = [NSString stringWithFormat:@"%@", _myurl];
//    NSAlert *pathalert = [[NSAlert alloc] init];
//    [pathalert setMessageText:@"File Path:"];
//    [pathalert setInformativeText:pathstr];
//    [pathalert addButtonWithTitle:@"Cancel"];
//    [pathalert addButtonWithTitle:@"Ok"];
//    [pathalert runModal];
//    
//    NSString *str = [NSString stringWithFormat:@"%f", asp];
//    NSAlert *alert = [[NSAlert alloc] init];
//    [alert setMessageText:@"Aspect Ratio"];
//    [alert setInformativeText:str];
//    [alert addButtonWithTitle:@"Cancel"];
//    [alert addButtonWithTitle:@"Ok"];
//    [alert runModal];

}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    return ([menuItem action] == @selector(performClose:) || [menuItem action] == @selector(performZoom:) || [menuItem action] == @selector(performMiniaturize:)) ? YES : [super validateMenuItem:menuItem];
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError

{
    _player = [AVPlayer playerWithURL:absoluteURL];
    _player.volume = 0.85;
    _myurl = absoluteURL;
    return YES;
}
@end
