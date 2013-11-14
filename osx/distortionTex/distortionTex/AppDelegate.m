//
//  AppDelegate.m
//  distortionTex
//
//  Created by nakano_michiharu on 2013/11/12.
//  Copyright (c) 2013年 nakanomi. All rights reserved.
//

#import "AppDelegate.h"
#include "vectorUtil.h"
#include "matrixUtil.h"

#define _RGB_CENTER	(128.0 / 255.0)

@interface AppDelegate()
{
	NSImage* _imgTestSource;
	NSImage* _imgDistortion;
	NSImage* _imgTestDest;
	NSImage* _imgPerseSource;
	float _power;
	float _radius;
	CGPoint _posCenter;
}
- (NSURL*)getFileUrlByOpenPanel;
- (NSImage*)filterColorFromImage:(NSImage*)image retainColor:(NSString*)colorName;
- (BOOL)drawDistortionedImage;
- (NSImage*)drawCircle;
- (NSImage*)drawPerse;
- (NSString*)getCurTabIdentifier;
- (NSImage*)createTemporaryImage;
- (int)getCurTabIndex;
- (void)test;
- (void)calcMtxMultiplyVec:(float*)vSrc matrix:(float*)mtx result:(float*)vResult;
- (void)logMtx:(float*)mtx;
@end
#define _SIZE_WIDTH	256.0f
#define _SIZE_HEIGHT	256.0f
enum {
	_TAB_CIRCLE = 0,
	_TAB_PERSE,
};

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	_imgDistortion = nil;
	_imgTestSource = nil;
	_imgTestDest = nil;
	_imgPerseSource = nil;
	[self.imgViewDistortion setImageScaling:NSScaleNone];
	[self.imgcellTestSource setImageScaling:NSScaleNone];
	[self.imgViewTestDest setImageScaling:NSScaleNone];
	_power = [self.sliderPower floatValue];
	_radius = [self.sliderRadius floatValue];
	_posCenter = CGPointMake(128.0, 128.0);
	{
		int tabCount = (int)[self.tabViewDistortion.tabViewItems count];
		for (int i = 0; i < tabCount; i++) {
			NSTabViewItem* item = [self.tabViewDistortion.tabViewItems objectAtIndex:i];
			NSLog(@"%@", item.identifier);
		}
	}
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
		NSLog(@"%s:exception:%@", __PRETTY_FUNCTION__, exception);
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
#pragma mark -UI
- (NSString*)getCurTabIdentifier
{
	NSTabViewItem* item = [self.tabViewDistortion selectedTabViewItem];
	if (item == nil) {
		return nil;
	}
	return item.identifier;
}
- (int)getCurTabIndex
{
	int result = -1;
	NSString* strIdentifier = [self getCurTabIdentifier];
	if (strIdentifier != nil) {
		int count = (int)[self.tabViewDistortion.tabViewItems count];
		for (int i = 0; i < count; i++) {
			NSTabViewItem* item = [self.tabViewDistortion.tabViewItems objectAtIndex:i];
			int compare = [strIdentifier compare:item.identifier];
			if (compare == NSOrderedSame) {
				result = i;
				break;
			}
		}
	}
	return result;
}

#pragma mark -Utility
- (NSImage*)createTemporaryImage
{
	NSImage* result = nil;
	@try {
		NSBundle* thisBundle = [NSBundle mainBundle];
		NSString* filePath = [thisBundle pathForResource:@"white256x256" ofType:@"png"];
		NSImage* tmpImage = [[NSImage alloc] initWithContentsOfFile:filePath];
		result = tmpImage;
	}
	@catch (NSException *exception) {
		NSLog(@"%s:exception:%@", __PRETTY_FUNCTION__, exception);
	}
	return result;
}

#pragma mark -Draw
// 円形の歪みマップを描画
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
			NSImage* tmpImage = [self createTemporaryImage];
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
							offsetX = (r * _power);
							
							g -= _RGB_CENTER;
							offsetY = (g * _power);
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

- (NSImage*)drawCircle
{
	NSImage* imageResult = nil;
	@try {
		// 何かしらのイメージが無いとNSBitmapImageRepを取得できない
		// サイズなどを動的にしたい場合は描画する必要がある
		NSImage* tmpImage = [self createTemporaryImage];
		NSColor* color = nil;
		NSBitmapImageRep* outImageRep = [[NSBitmapImageRep alloc] initWithData:[tmpImage TIFFRepresentation]];
		[tmpImage lockFocus];
		CGSize size = tmpImage.size;
		CGPoint posCur = CGPointMake(0, 0);
		for (int y = 0; y < size.height; y++) {
			for (int x = 0; x < size.width; x++) {
				posCur.x = (float)x;
				posCur.y = (float)y;
				float distX = posCur.x - _posCenter.x;
				float distY = posCur.y - _posCenter.y;
				float dist = (distX * distX) + (distY * distY);
				dist = sqrtf(dist);
				BOOL isLeft = YES;
				BOOL isUpper = YES;
				if (distX > 0.0) {
					isLeft = NO;
				}
				if (distY > 0.0) {
					isUpper = NO;
				}
				if (dist < _radius) {
					float theta = 1.0 - (dist / _radius);
					theta *= M_PI_2;
					float power = sinf(theta);
					float red = _RGB_CENTER;
					float green = _RGB_CENTER;
					if (isLeft) {
						red = power * (1.0 - _RGB_CENTER);
						red += _RGB_CENTER;
					}
					else {
						red = power * (_RGB_CENTER - 1.0);
						red += _RGB_CENTER;
					}
					if (isUpper) {
						green = power * (1.0 - _RGB_CENTER);
						green += _RGB_CENTER;
					}
					else {
						green = power * (_RGB_CENTER - 1.0);
						green += _RGB_CENTER;
					}
					
					color = [NSColor colorWithCalibratedRed:red green:green blue:0.0 alpha:1.0];
					[outImageRep setColor:color atX:x y:y];
					color = nil;
				}
			}
		}
		[tmpImage lockFocus];
		imageResult = [[NSImage alloc] initWithCGImage:[outImageRep CGImage] size:size];
		
		tmpImage = nil;
		outImageRep = nil;
		color = nil;
	}
	@catch (NSException *exception) {
		NSLog(@"%s:exception:%@", __PRETTY_FUNCTION__, exception);
	}
	return imageResult;
}

- (NSImage*)drawPerse
{
	NSImage* imageResult = nil;
	@try {
		
	}
	@catch (NSException *exception) {
		NSLog(@"%s:exception:%@", __PRETTY_FUNCTION__, exception);
	}

	return imageResult;
}

#pragma mark -Test
- (void)logMtx:(float*)mtx
{
	for (int row = 0; row < 4; row++) {
		int base = row * 4;
		NSLog(@"%f, %f, %f, %f", mtx[base], mtx[base + 1], mtx[base + 2], mtx[base + 3]);
	}
}

- (void)test
{
	float mtxPerse[16];
	float nearZ = 5.0;
	float farZ = 10000.0;
	mtxLoadPerspective(mtxPerse, 90.0, 1.0, nearZ, farZ);
	[self logMtx:mtxPerse];
	NSLog(@"%s", __PRETTY_FUNCTION__);
	{
		float mtxTest[16];
		mtxLoadIdentity(mtxTest);
		mtxLoadRotateZ(mtxTest, M_PI_2);
		mtxLoadScale(mtxTest, 2.0, 2.0, 2.0);
		float vTest[4];
		vTest[0] = 1.0;
		vTest[1] = 2.0;
		vTest[2] = 8.0;
		vTest[3] = 1.0;
		
		float vResult[4];
		[self logMtx:mtxTest];
		[self calcMtxMultiplyVec:vTest matrix:mtxPerse result:vResult];
		//[self calcMtxMultiplyVec:vTest matrix:mtxTest result:vResult];
		NSLog(@"%f, %f, %f, %f", vResult[0], vResult[1], vResult[2], vResult[3]);
		NSLog(@"%f, %f, %f, %f", vResult[0] / vResult[3], vResult[1] / vResult[3], vResult[2]/ vResult[3], vResult[3]/ vResult[3]);
		float x = 1.0;
		float y = 1.0;
		float z1 = nearZ + 1.0;
		float z2 = nearZ + 10.0;
		float positions[32] = {
			-x, y, z1, 1.0,
			x,  y, z1, 1.0,
			-x,-y, z1, 1.0,
			x, -y, z1, 1.0,

			-x, y, z2, 1.0,
			x,  y, z2, 1.0,
			-x,-y, z2, 1.0,
			x, -y, z2, 1.0,
		};
		for (int i = 0; i < 32; i += 4) {
			[self calcMtxMultiplyVec:&positions[i] matrix:mtxPerse result:vResult];
			NSLog(@"%f, %f", (vResult[0] * 1000.0)  / vResult[3], (vResult[1] * 1000.0) / vResult[3]);
		}
	}
	
}
#pragma mark -Calc
- (void)calcMtxMultiplyVec:(float*)vSrc matrix:(float*)mtx result:(float*)vResult
{
	for (int i = 0; i < 4; i++) {
		float tmpVal = 0.0;
		for (int j = 0; j < 4; j++) {
			int indexMtx = i * 4 + j;
			float vVal = vSrc[j];
			float mtxIJ = mtx[indexMtx];
			tmpVal += vVal * mtxIJ;
		}
		vResult[i] = tmpVal;
	}
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
		if ([self getCurTabIndex] == _TAB_PERSE) {
			if (_imgPerseSource != nil) {
				_imgPerseSource = nil;
			}
			url = [self getFileUrlByOpenPanel];
			if (url != nil) {
				_imgPerseSource = [[NSImage alloc] initWithContentsOfURL:url];
				[self.imgCellDistortionPerse setImage:_imgPerseSource];
			}
		}
	}
	else if ([sender isEqual:self.btnTest]) {
		NSLog(@"test");
		/*
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
		 */
		[self test];
		
	}
	else if ([sender isEqual:self.btnSave]) {
		if (_imgDistortion != nil) {
			NSSavePanel* savePanel = [NSSavePanel savePanel];
			NSArray* allowedFileTypes = [NSArray arrayWithObjects:@"png", nil];
			[savePanel setAllowedFileTypes:allowedFileTypes];
			NSInteger panelResult = [savePanel runModal];
			if (panelResult == NSOKButton) {
				NSURL* url = [savePanel URL];
				//[[_imgDistortion TIFFRepresentation] writeToURL:url atomically:YES];
				CGImageRef cgRef = [_imgDistortion CGImageForProposedRect:NULL
																  context:nil
																	hints:nil];
				NSBitmapImageRep* newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
				NSData* pngData = [newRep representationUsingType:NSPNGFileType
													   properties:nil];
				[pngData writeToURL:url atomically:YES];
			}
		}
	}
}

- (IBAction)sliderChange:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSSlider* slider = (NSSlider*)sender;
	float value = [slider floatValue];
	if ([sender isEqual:self.sliderPower]) {
		NSLog(@"change power :%f", [slider floatValue]);
		_power = [slider floatValue];
		[self drawDistortionedImage];
		NSString* strPower = [NSString stringWithFormat:@"強さ:%f", _power];
		[self.lblPower setObjectValue:strPower];
	}
	else if ([sender isEqual:self.sliderRadius]) {
		NSLog(@"change radius : %f", [slider floatValue]);
		_radius = [slider floatValue];
		if (_imgDistortion != nil) {
			_imgDistortion = nil;
		}
		_imgDistortion = [self drawCircle];
		[self.imgViewDistortion setImage:_imgDistortion];
		[self drawDistortionedImage];
		NSString* strRadius = [NSString stringWithFormat:@"半径:%f", _radius];
		[self.lblRadius setObjectValue:strRadius];
	}
	else if ([sender isEqual:self.sliderHeight]) {
		NSLog(@"change height: %f", value);
	}
	else if ([sender isEqual:self.sliderZPosition]) {
		NSLog(@"change z position:%f", value);
	}
	NSTabViewItem* item = [self.tabViewDistortion selectedTabViewItem];
	NSString* identifier = [item identifier];
	NSLog(@"%@", identifier);
	[self getCurTabIndex];
}

@end
