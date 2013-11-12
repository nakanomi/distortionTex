//
//  AppDelegate.m
//  distortionTex
//
//  Created by nakano_michiharu on 2013/11/12.
//  Copyright (c) 2013年 nakanomi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
{
	NSImage* _imgTestSource;
	NSImage* _imgDistortion;
	NSImage* _imgTestDest;
}
- (NSURL*)getFileUrl;
- (void)drawTest:(NSCustomImageRep*)customRep;
@end
#define _SIZE_WIDTH	256.0f
#define _SIZE_HEIGHT	256.0f
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	_imgDistortion = nil;
	_imgTestSource = nil;
	_imgTestDest = nil;
	[self.imgViewDistortion setImageScaling:NSScaleNone];
	[self.imgcellTestSource setImageScaling:NSScaleNone];
	[self.imgViewTestDest setImageScaling:NSScaleNone];
}

- (NSURL*)getFileUrl
{
	NSURL* url = nil;
	// ファイルタイプのフィルター
	NSArray* arrFileTypes = [NSArray arrayWithObjects:@"png", @"PNG", nil];
	@try {
		NSOpenPanel* openPanel = [NSOpenPanel openPanel];
		[openPanel setAllowedFileTypes:arrFileTypes];
		NSInteger openResult = [openPanel runModal];
		if (openResult == NSOKButton) {
			url = [openPanel URL];
		}
	}
	@catch (NSException *exception) {
	}
	@finally {
	}
	return url;
}

- (void)drawTest:(NSCustomImageRep*)customRep
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	[[NSColor redColor] set];
	NSRect rect;
	rect.origin = NSZeroPoint;
	rect.size = _imgDistortion.size;
	NSRectFill(rect );
}



#pragma mark -Event
- (IBAction)onPushButton:(id)sender
{
	NSURL* url = nil;
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if ([sender isEqual:self.btnLoadTestSource] ) {
		NSLog(@"load test source");
		url = [self getFileUrl];
		if (url != nil) {
			_imgTestSource = [[NSImage alloc] initWithContentsOfURL:url];
			NSLog(@"w:%f, h:%f", _imgTestSource.size.width, _imgTestSource.size.height);
			[self.imgcellTestSource setImage:_imgTestSource];
			//[self.imgViewDistortion setImage:_imgTestSource];
		}
	}
	else if ([sender isEqual:self.btnLoadDistortion]) {
		NSLog(@"load distortion");
	}
	else if ([sender isEqual:self.btnTest]) {
		NSLog(@"test");
		if (_imgDistortion == nil) {
			NSSize size = CGSizeMake(_SIZE_WIDTH, _SIZE_HEIGHT);
			_imgDistortion = [[NSImage alloc] initWithSize:size];
			NSCustomImageRep* customRep = [[NSCustomImageRep alloc] initWithDrawSelector:@selector(drawTest:)
																				delegate:self];
			[_imgDistortion addRepresentation:customRep];
			
		}
		[self.imgViewDistortion setImage:_imgDistortion];
	}
}

- (IBAction)sliderChange:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSSlider* slider = (NSSlider*)sender;
	if ([sender isEqual:self.sliderPower]) {
		NSLog(@"change power :%f", [slider floatValue]);
	}
	else if ([sender isEqual:self.sliderRadius]) {
		NSLog(@"change radius : %f", [slider floatValue]);
	}
}

@end
