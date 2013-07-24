/**
 * ZBModule Demo Project
 * Code for ZBModule PWM Peripheral
 * Created on: 24/07/13
 * Blog : http://blog.csdn.net/u011341435
 * Copyright 2013 Cole Yu <gzble@qq.com>
 * QQ: <2843127527>
 * TaoBao:<http://antek.taobao.com/>
 */
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CBPeripheral.h>
#import "bluekitBle.h"

@interface TXRXViewController : UIViewController<UITextFieldDelegate,blueKitBLEDelegate>
{
    bluekitBle *t;
    Boolean isConnect;
}
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) CBPeripheral *gConDev;


@property (weak, nonatomic) IBOutlet UINavigationItem *gNavigationBar;

@property (weak, nonatomic) IBOutlet UITextView *gRecvTxt;

- (IBAction)doDisconnect:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *gBle_LED_RSlider;

@property (weak, nonatomic) IBOutlet UISlider *gBle_LED_GSlider;

@property (weak, nonatomic) IBOutlet UISlider *gBle_LED_BSlider;
- (IBAction)doLedSliderChanged:(id)sender;
- (IBAction)doSaveToBoard:(id)sender;
- (IBAction)doCleanConfig:(id)sender;

@end
