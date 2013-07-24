/**
 * ZBModule Demo Project
 * Code for ZBModule PWM Peripheral
 * Created on: 24/07/13
 * Blog : http://blog.csdn.net/u011341435
 * Copyright 2013 Cole Yu <gzble@qq.com>
 * QQ: <2843127527>
 * TaoBao:<http://antek.taobao.com/>
 */

#import "TXRXViewController.h"

@interface TXRXViewController ()

@end

@implementation TXRXViewController
@synthesize gConDev;
@synthesize gNavigationBar;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    t = [bluekitBle getSharedInstance];
    [t controlSetup:1];
    t.delegate = self;
    
    if(gConDev!=nil)
    {
        gNavigationBar.title = gConDev.name;
        [t connectPeripheral:gConDev];
        
    }
    [NSTimer scheduledTimerWithTimeInterval:(float)1 target:self selector:@selector(RssiReadTimer:) userInfo:nil repeats:YES];
}

-(void) RssiReadTimer:(NSTimer *)timer
{
    
  if(t.activePeripheral!=nil)
  {
      [t myReadRssi];
  }
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void) RxValueUpdate:(Byte *)buf
{
    
    if (t.activePeripheral != nil)
    {
        NSLog(@"RxValueUpdate");
        NSString *recvPkt = [NSString stringWithCString:(char*)buf encoding:NSASCIIStringEncoding];
        
    }
}

-(void) deviceFoundUpdate:(CBPeripheral *)p
{
    printf("Do device Found Update");
}

-(void) disconnectBle
{
    [t cancelConnectPeripheral];
}


-(void) bluekitDisconnect
{
}


-(void) updateRssiValue:(int)rssi
{
    NSString *rssiStr ;
    rssiStr = [NSString stringWithFormat:@"%ddBm",rssi];
    gNavigationBar.rightBarButtonItem.title = rssiStr;
}
-(void) blueConnect
{
    
}

- (IBAction)doDisconnect:(id)sender
{
    if(t.activePeripheral!=nil)
    {
        [t cancelConnectPeripheral];
        gNavigationBar.rightBarButtonItem.title = @"RSSI";
        gNavigationBar.title = @"Disconnected";
    }
}


- (IBAction)doLedSliderChanged:(id)sender { 
    
    UISlider *mSlider  = (UISlider*)sender;
    
    uint8_t cmdBuf[16] = {0};
    uint8_t channelNo  = 0;
    uint8_t duty = 0;
    
    cmdBuf[0] = 0xa5;//HEADER1
    cmdBuf[1] = 0xa3;//HEADER3
    cmdBuf[2] = 0x02;//LENGTH
    cmdBuf[3] = 0x02;//CMD
    
    switch (mSlider.tag) {
            
        case 1001:
            //NSLog(@"R");
            channelNo = 3; 
            duty = (uint8_t)(mSlider.value*99);
            break;
            
        case 1002:
            // NSLog(@"G");
            channelNo = 2;
            duty = (uint8_t)(mSlider.value*99);
            break;
            
        case 1003:
            // NSLog(@"B");
            channelNo = 4;
            duty = (uint8_t)(mSlider.value*99);
            break;
            
        default:
            break;
    }
    
    if(channelNo!= 0)
    {
        cmdBuf[4] = channelNo;//PWM channel
        cmdBuf[5] = duty;//PWM duty
        cmdBuf[6] = 0x00;
        cmdBuf[7] = 0x5a;//TAIL
        NSData *adata = [[NSData alloc] initWithBytes:cmdBuf length:16];
        
        if(t.activePeripheral != nil)
        {
            [t writeDataToSscomm:adata];
        }
        
    }
}

- (IBAction)doSaveToBoard:(id)sender
{
    NSLog(@"doSaveToBoard");
    uint8_t cmdBuf[16] = {0};
    
    cmdBuf[0] = 0xa5;
    cmdBuf[1] = 0xa3;
    cmdBuf[2] = 0x02;
    cmdBuf[3] = 0x0e;
    cmdBuf[4] = 0x00;
    cmdBuf[5] = 0x0e;
    cmdBuf[6] = 0x5a;
    
    NSData *adata = [[NSData alloc] initWithBytes:cmdBuf length:16];
    
    if(t.activePeripheral != nil)
    {
        [t writeDataToSscomm:adata];
    }

}

- (IBAction)doCleanConfig:(id)sender
{
    NSLog(@"doCleanConfig");
    uint8_t cmdBuf[16] = {0};
    
    cmdBuf[0] = 0xa5;
    cmdBuf[1] = 0xa3;
    cmdBuf[2] = 0x02;
    cmdBuf[3] = 0x10;
    cmdBuf[4] = 0x00;
    cmdBuf[5] = 0x10;
    cmdBuf[6] = 0x5a;
    
    NSData *adata = [[NSData alloc] initWithBytes:cmdBuf length:16];
    
    if(t.activePeripheral != nil)
    {
        [t writeDataToSscomm:adata];
    }

}

@end
