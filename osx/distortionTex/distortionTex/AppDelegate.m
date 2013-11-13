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
- (NSURL*)getFileUrlByOpenPanel;
- (NSImage*)filterColorFromImage:(NSImage*)image retainColor:(NSString*)colorName;
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

- (NSURL*)getFileUrlByOpenPanel
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


// http://www.mindfiresolutions.com/Filtering-colors-from-images-and-creating-a-new-image-from-filtered-color-1592.php
- (NSImage*)filterColorFromImage:(NSImage*)image retainColor:(NSString*)colorName
{
	NSSize size = image.size;
	NSColor* color = [[NSColor alloc] init];
	
	//NSBitmapImageRep* imageRep = [NSBitmapImageRepimageRepWithData:[image TIFFRepresentation]];
	NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
	
	[image lockFocus];
	
	if ([colorName caseInsensitiveCompare:@"red"] == NSOrderedSame) {
		for (int x = 0; x < size.width; x++) {
			for (int y = 0; y < size.height; y++) {
				color = NSReadPixel(NSMakePoint(x, y));
				NSColor* fColor = [NSColor colorWithDeviceRed:[color redComponent]
														green:0.0
														 blue:0.0
														alpha:[color alphaComponent]];
				[imageRep setColor:fColor atX:x y:y];
			}
		}
	}
	// blue green skip
	
	[image unlockFocus];
	NSImage* filteredImage = [[NSImage alloc] initWithCGImage:[imageRep CGImage] size:size];
	
	return filteredImage;
}



#pragma mark -Event
- (IBAction)onPushButton:(id)sender
{
	NSURL* url = nil;
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if ([sender isEqual:self.btnLoadTestSource] ) {
		NSLog(@"load test source");
		url = [self getFileUrlByOpenPanel];
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
		if (_imgDistortion != nil) {
			_imgDistortion = nil;
		}
		url = [self getFileUrlByOpenPanel];
		if (url != nil) {
			NSImage* tmpImage = [[NSImage alloc] initWithContentsOfURL:url];
			_imgDistortion = [self filterColorFromImage:tmpImage retainColor:@"red"];
			[self.imgViewDistortion setImage:_imgDistortion];
			tmpImage = nil;
		}
		
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
