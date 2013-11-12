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

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	_imgDistortion = nil;
	_imgTestSource = nil;
	_imgTestDest = nil;
	/*
	[self.imgViewDistortion setImageScaling:NSScaleNone];
	[self.imgViewTestSource setImageScaling:NSScaleNone];
	[self.imgViewTestDest setImageScaling:NSScaleNone];
	 */
}

#pragma mark -Event
- (IBAction)onPushButton:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	// ファイルタイプのフィルター
	NSArray* arrFileTypes = [NSArray arrayWithObjects:@"png", @"PNG", nil];
	if ([sender isEqual:self.btnLoadTestSource] ) {
		NSLog(@"load test source");
		NSOpenPanel* openPanel = [NSOpenPanel openPanel];
		[openPanel setAllowedFileTypes:arrFileTypes];
		NSInteger openResult = [openPanel runModal];
		if (openResult == NSOKButton) {
			_imgTestSource = nil;
			NSURL* url = [openPanel URL];
			_imgTestSource = [[NSImage alloc] initWithContentsOfURL:url];
			NSLog(@"w:%f, h:%f", _imgTestSource.size.width, _imgTestSource.size.height);
			[self.imgcellTest setImage:_imgTestSource];
			[self.imgViewTestDest setImage:_imgTestSource];
			[self.imgViewDistortion setImage:_imgTestSource];
		}
		
		
	}
	else if ([sender isEqual:self.btnLoadDistortion]) {
		NSLog(@"load distortion");
	}
	else if ([sender isEqual:self.btnTest]) {
		NSLog(@"test");
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
