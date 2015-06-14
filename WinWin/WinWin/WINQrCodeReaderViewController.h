//
//  WINQrCodeReaderViewController.h
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 9/6/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

@import UIKit;
@import AVFoundation;

@interface WINQrCodeReaderViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewQRcodeView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

- (IBAction)startStopReading:(id)sender;


@end
