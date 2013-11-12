//
//  AppDelegate.h
//  distortionTex
//
//  Created by nakano_michiharu on 2013/11/12.
//  Copyright (c) 2013年 nakanomi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	
}
@property (unsafe_unretained) IBOutlet NSImageView *imgViewDistortion;
@property (unsafe_unretained) IBOutlet NSImageView *imgViewTestDest;
@property (unsafe_unretained) IBOutlet NSButton *btnLoadTestSource;
@property (unsafe_unretained) IBOutlet NSButton *btnLoadDistortion;
@property (unsafe_unretained) IBOutlet NSButton *btnTest;
@property (unsafe_unretained) IBOutlet NSSlider *sliderPower;
@property (unsafe_unretained) IBOutlet NSSlider *sliderRadius;
@property (unsafe_unretained) IBOutlet NSImageCell *imgcellTest;

@property (assign) IBOutlet NSWindow *window;

- (IBAction)onPushButton:(id)sender;
- (IBAction)sliderChange:(id)sender;

@end
