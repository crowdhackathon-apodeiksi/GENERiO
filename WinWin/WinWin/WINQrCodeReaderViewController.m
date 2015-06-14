//
//  WINQrCodeReaderViewController.m
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 9/6/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINQrCodeReaderViewController.h"

#import <Parse/Parse.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSUserDefaultsHelper.h"
#import "WINUser.h"
#import "WINTagsListViewController.h"
#import "WINAlarm.h"
#import "AppDelegate.h"
#import "WINManualReceiptEntryViewController.h"

@interface WINQrCodeReaderViewController ()


@property (weak, nonatomic) IBOutlet UILabel *afmLabel;
@property (weak, nonatomic) IBOutlet UILabel *aaLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fpaLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnTags;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (nonatomic) BOOL isReading;

@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSDateFormatter *dateFormatter;
@property(nonatomic,strong) NSDateFormatter *dateStringFormatter;
@property(nonatomic,strong) PFObject *receipt;
@property(nonatomic,strong) NSString *sellerVat;
@property(nonatomic,strong) NSMutableArray *tags;
@property(nonatomic,strong) WINAlarm *alarm;


-(BOOL)startReading;
-(void)stopReading;
-(void)loadSound;

@end

@implementation WINQrCodeReaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.alarm = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).alarm;

    self.navigationItem.title = @"Καταχώρηση";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(p_barBtnManualEntryPressed:)];
    
    self.statusView.hidden = YES;
    
    [self.btnStart setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnStart.bounds.size] forState:UIControlStateNormal];
    [self.btnSave setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnSave.bounds.size] forState:UIControlStateNormal];
    [self.btnTags setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnTags.bounds.size] forState:UIControlStateNormal];
    [self.btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnCancel.bounds.size] forState:UIControlStateNormal];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    self.dateStringFormatter = [[NSDateFormatter alloc] init];
    self.dateStringFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    self.dateStringFormatter.locale = [NSLocale currentLocale];
    self.dateStringFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    self.tags = [NSMutableArray array];
    
    [self loadSound];

    _isReading = NO;
    _captureSession = nil;
}

#pragma mark - Private methods

- (BOOL)startReading {
    NSError *error;
    self.statusView.hidden = YES;

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewQRcodeView.layer.bounds];
    [_previewQRcodeView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)loadSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}


-(void)stopReading{
    [_captureSession stopRunning];
    self.statusView.hidden = NO;
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    [_btnStart setTitle:@"Έναρξη Σάρωσης" forState:UIControlStateNormal];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            //self.statusView.hidden = NO;
            //[_statusLabel setText:[metadataObj stringValue]];
            self.receipt = nil;
            //[self p_parseReceiptCodeWithString:(NSString*)[metadataObj stringValue]];
            
            [self performSelectorOnMainThread:@selector(p_parseReceiptCodeWithString:) withObject:(NSString*)[metadataObj stringValue] waitUntilDone:YES];

            //[_statusLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_btnStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            if (_audioPlayer) {
                [_audioPlayer play];
            }

        }
    }
}

#pragma mark - IBActions

- (IBAction)startStopReading:(id)sender
{
    [self.tags removeAllObjects];
    
    if (!_isReading) {
        if ([self startReading]) {
            [_btnStart setTitle:@"Διακοπή Σάρωσης" forState:UIControlStateNormal];
        }
    }
    else{
        [self stopReading];
        [_btnStart setTitle:@"Έναρξη Σάρωσης" forState:UIControlStateNormal];
        self.statusView.hidden = YES;

    }
    
    _isReading = !_isReading;
}

- (IBAction)sendReceiptToBackendAction:(id)sender
{
    [self p_sendReceiptToBackend];
}

- (IBAction)cancelScannedReceipt:(id)sender
{
    self.statusView.hidden = YES;
    [self startStopReading:nil];
}

- (IBAction)exitFromTagsList:(UIStoryboardSegue *)segue
{
    WINTagsListViewController *controller = (WINTagsListViewController *)segue.sourceViewController;
    self.tags = controller.selectedTags;
}

- (IBAction)exitFromManualReceiptEntry:(UIStoryboardSegue *)segue
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentTagsModallySegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        WINTagsListViewController *controller = (WINTagsListViewController *)navController.topViewController;
        controller.selectedTags = self.tags;
        return;
    }
}

#pragma mark - Private

- (void)p_barBtnManualEntryPressed:(id)sender
{
    UINavigationController *navController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ManualReceiptEntryNavController"];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)p_parseReceiptCodeWithString:(NSString*)receiptCode
{
    //NSString *receiptCode = @"800426779#000133#2015-06-04T19:13#22.84#2.63#0";
    
    NSArray *receiptComponents = [receiptCode componentsSeparatedByString:@"#"];
    
    NSString *sellerVat = receiptComponents[0];
    self.sellerVat = sellerVat;
    
    NSString *receiptNumber = receiptComponents[1];
    NSString *receiptDateString = receiptComponents[2];
    NSDate *receiptDate = [self.dateFormatter dateFromString:receiptDateString];
    
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:receiptDate];
    NSDate *receiptDateLocal = [NSDate dateWithTimeInterval:seconds sinceDate:receiptDate];
    
    NSString *receiptAmount = receiptComponents[3];
    NSString *receiptTaxAmount = receiptComponents[4];
    
    
    self.afmLabel.text = [NSString stringWithFormat:@"ΑΦΜ:  %@",sellerVat];
    self.aaLabel.text = [NSString stringWithFormat:@"Α.Α.:  %@",receiptNumber];
    self.dateLabel.text = [NSString stringWithFormat:@"ΗΜΕΡΟΜΗΝΙΑ:  %@", [self.dateStringFormatter stringFromDate:receiptDate]];
    self.amountLabel.text = [NSString stringWithFormat:@"ΠΟΣΟ:  %@",receiptAmount];
    self.fpaLabel.text = [NSString stringWithFormat:@"ΦΠΑ  %@",receiptTaxAmount];
    
    PFObject *receipt = [PFObject objectWithClassName:@"RECEIPTS"];
    receipt[@"NUM"] = @([receiptNumber integerValue]);
    receipt[@"DATETIME"] = receiptDateLocal;
    receipt[@"COST"] = @([receiptAmount floatValue]);
    receipt[@"VATCOST"] = @([receiptTaxAmount floatValue]);
    receipt[@"LOTTERY_WON"] = @NO;
    self.receipt = receipt;
    
}

- (void)p_sendReceiptToBackend
{
    [SVProgressHUD showWithStatus:@"Καταχώρηση.." maskType:SVProgressHUDMaskTypeGradient];
    
    __weak WINQrCodeReaderViewController *weakSelf = self;
    PFQuery *sellerQuery = [PFQuery queryWithClassName:@"SELLER"];
    [sellerQuery whereKey:@"VAT" equalTo:@([self.sellerVat integerValue])];
    [sellerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"Σφάλμα Καταχώρησης" maskType:SVProgressHUDMaskTypeGradient];
            [weakSelf.tags removeAllObjects];
            return;
        }
        
        if (objects.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"Λάθος Χρήστης" maskType:SVProgressHUDMaskTypeGradient];
            [weakSelf.tags removeAllObjects];
            return;
        }
        
        PFObject *seller = (PFObject *)objects[0];
        weakSelf.receipt[@"SELLER_ID"] = seller;
        
        WINUser *user = [NSUserDefaultsHelper GetUser];
        
        PFQuery *customerQuery = [PFQuery queryWithClassName:@"CUSTOMER"];
        [customerQuery whereKey:@"objectId" equalTo:user.ID];
        [customerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"Σφάλμα Καταχώρησης" maskType:SVProgressHUDMaskTypeGradient];
                [weakSelf.tags removeAllObjects];
                return;
            }
            
            if (objects.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"Λάθος Χρήστης" maskType:SVProgressHUDMaskTypeGradient];
                [weakSelf.tags removeAllObjects];
                return;
            }
            
            PFObject *customer = (PFObject *)objects[0];
            weakSelf.receipt[@"CUSTOMER_ID"] = customer;
            
            PFQuery *receiptQuery = [PFQuery queryWithClassName:@"RECEIPTS"];
            [receiptQuery whereKey:@"NUM" equalTo:weakSelf.receipt[@"NUM"]];
            [receiptQuery whereKey:@"DATETIME" equalTo:weakSelf.receipt[@"DATETIME"]];
            [receiptQuery whereKey:@"COST" equalTo:weakSelf.receipt[@"COST"]];
            [receiptQuery whereKey:@"VATCOST" equalTo:weakSelf.receipt[@"VATCOST"]];
            [receiptQuery whereKey:@"SELLER_ID" equalTo:weakSelf.receipt[@"SELLER_ID"]];
            [receiptQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"Σφάλμα Καταχώρησης" maskType:SVProgressHUDMaskTypeGradient];
                    [weakSelf.tags removeAllObjects];
                    return;
                }
                
                if (objects.count == 0) {
                    [SVProgressHUD showErrorWithStatus:@"Λάθος Απόδειξη" maskType:SVProgressHUDMaskTypeGradient];
                    [weakSelf.tags removeAllObjects];
                    return;
                }
                
                PFObject *receipt = (PFObject *)objects[0];
                
                if (receipt[@"CUSTOMER_ID"]) {
                    [SVProgressHUD showErrorWithStatus:@"Υπάρχουσα Απόδειξη" maskType:SVProgressHUDMaskTypeGradient];
                    [weakSelf.tags removeAllObjects];
                    return;
                }
                
                weakSelf.receipt.objectId = receipt.objectId;
                
                [weakSelf.receipt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        for (PFObject *tag in weakSelf.tags) {
                            
                            PFObject *receiptTag = [PFObject objectWithClassName:@"RECEIPTTAG"];
                            receiptTag[@"RECEIPT_ID"] = weakSelf.receipt;
                            receiptTag[@"TAG_ID"] = tag;
                            
                            [receiptTag saveInBackground];
                            
                            
                            if ([self.alarm.tag.objectId isEqualToString:tag.objectId]) {
                                
                                self.alarm.counter += [receipt[@"COST"] floatValue];
                                
                                if (self.alarm.counter > self.alarm.value) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Προσοχή!" message:[NSString stringWithFormat:@"Ξεπεράστηκε το μηνιαίο όριο στην κατηγορία:\"%@\"", tag[@"SHORT_DESCRIPTION"]] delegate:nil cancelButtonTitle:@"Κλείσιμο" otherButtonTitles:nil];
                                        [alert show];
                                    });

                                }
                            }
                        }
                        
                        [SVProgressHUD showSuccessWithStatus:@"Επιτυχής Καταχώρηση" maskType:SVProgressHUDMaskTypeGradient];
                        self.statusView.hidden = YES;
                        [self startStopReading:nil];
                        return;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"Σφάλμα Καταχώρησης" maskType:SVProgressHUDMaskTypeGradient];
                    return;
                }];
                
            }];
            
        }];
        
    }];
}

@end
