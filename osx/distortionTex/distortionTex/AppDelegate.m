//
//  AppDelegate.m
//  distortionTex
//
//  Created by nakano_michiharu on 2013/11/12.
//  Copyright (c) 2013年 nakanomi. All rights reserved.
//

#import "AppDelegate.h"

#define _RGB_CENTER	(128.0 / 255.0)

@interface AppDelegate()
{
	NSImage* _imgTestSource;
	NSImage* _imgDistortion;
	NSImage* _imgTestDest;
}
- (NSURL*)getFileUrlByOpenPanel;
- (NSImage*)filterColorFromImage:(NSImage*)image retainColor:(NSString*)colorName;
- (BOOL)drawDistortionedImage;
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

#pragma mark -Draw
- (BOOL)drawDistortionedImage
{
	BOOL result = NO;
	@try {
		if (_imgTestDest != nil) {
			_imgTestDest = nil;
		}
		if ((_imgTestSource != nil)&&(_imgDistortion != nil))
		{
			//
			NSColor* colSource = [[NSColor alloc] init];
			NSColor* colDistortion = [[NSColor alloc] init];
			CGSize size = _imgTestSource.size;
			// 何かしらのイメージが無いとNSBitmapImageRepを取得できない
			// サイズなどを動的にしたい場合は描画する必要がある
			NSBundle* thisBundle = [NSBundle mainBundle];
			NSString* filePath = [thisBundle pathForResource:@"white256x256" ofType:@"png"];
			NSImage* tmpImage = [[NSImage alloc] initWithContentsOfFile:filePath];
			NSBitmapImageRep* outImageRep = [[NSBitmapImageRep alloc] initWithData:[tmpImage TIFFRepresentation]];
			NSBitmapImageRep* inImageRep = [[NSBitmapImageRep alloc] initWithData:[_imgTestSource TIFFRepresentation]];
			NSBitmapImageRep* distortionImageRep = [[NSBitmapImageRep alloc] initWithData:[_imgDistortion TIFFRepresentation]];
			[tmpImage lockFocus];
			for (int y = 0; y < size.height; y++) {
				for (int x = 0; x < size.width; x++) {
					colSource = [inImageRep colorAtX:x y:y];
					colDistortion = [distortionImageRep colorAtX:x y:y];
					{
						CGFloat a, r, g, b;
						[colDistortion getRed:&r green:&g blue:&b alpha:&a];
						if (a != 0.0) {
							float offsetX = 0.0;
							float offsetY = 0.0;
							r -= _RGB_CENTER;
							offsetX = (r * 10.0);
							
							g -= _RGB_CENTER;
							offsetY = (g * 10.0);
							/*
							NSLog(@"r:%f, g:%f, b:%f, offsetX:%f, offsetY:%f",
								  r, g, b, offsetX, offsetY);
							 */
							colSource = [inImageRep colorAtX:(int)((float)x + offsetX)
														   y:(int)((float)y + offsetY)];
							
						}
						[outImageRep setColor:colSource atX:x y:y];
					}
				}
			}
			[tmpImage unlockFocus];
			_imgTestDest = [[NSImage alloc] initWithCGImage:[outImageRep CGImage] size:size];
			[self.imgViewTestDest setImage:_imgTestDest];
			
			tmpImage = nil;
			outImageRep = nil;
			distortionImageRep = nil;
			inImageRep = nil;
			colSource = nil;
			colDistortion = nil;
		}
	}
	@catch (NSException *exception) {
		NSLog(@"%s:exception:%@", __PRETTY_FUNCTION__, exception);
	}
	return result;
	
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
			//NSImage* tmpImage = [[NSImage alloc] initWithContentsOfURL:url];
			//_imgDistortion = [self filterColorFromImage:tmpImage retainColor:@"red"];
			_imgDistortion = [[NSImage alloc] initWithContentsOfURL:url];
			[self.imgViewDistortion setImage:_imgDistortion];
		}
		[self drawDistortionedImage];
		
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
