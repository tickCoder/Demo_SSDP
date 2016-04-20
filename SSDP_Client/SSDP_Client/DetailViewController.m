//
//  DetailViewController.m
//  SSDP_Client
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UITextView *msgTextView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.msgTextView.text = self.message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
