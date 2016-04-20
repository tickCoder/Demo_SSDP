//
//  ViewController.m
//  SSDP_Service
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ViewController.h"
#import "TICKSSDP_Service.h"
#import <ARNAlert/ARNAlert.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *listenBtn;
@property (weak, nonatomic) IBOutlet UIButton *responseBtn;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (nonatomic, weak) TICKSSDP_Service *ssdpService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _ssdpService = [TICKSSDP_Service sharedInstance];
    [_ssdpService addObserver:self forKeyPath:@"receivedMessage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"receivedMessage"]) {
        NSString *msg = [change objectForKey:NSKeyValueChangeNewKey];
        [ARNAlert showNoActionAlertWithTitle:@"收到discover" message:msg buttonTitle:@"确定"];
        _msgTextView.text = msg;
    }
}

- (IBAction)listenBtnAction:(id)sender {
    [_ssdpService startOnQueue:nil];
}
- (IBAction)responseBtnAction:(id)sender {
    
}
- (IBAction)aliveBtnAction:(id)sender {
    [_ssdpService sendAlive];
}
- (IBAction)byebyeBtnAction:(id)sender {
    [_ssdpService sendByebye];
}
@end
