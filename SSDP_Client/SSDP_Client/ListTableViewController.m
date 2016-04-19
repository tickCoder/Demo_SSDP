//
//  ListTableViewController.m
//  SSDP_Client
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ListTableViewController.h"
#import "TICKSSDP_Client.h"

@interface ListTableViewController ()
@property (nonatomic, strong) NSMutableArray *resultList;
@end

@implementation ListTableViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response
- (IBAction)refreshBtnAction:(id)sender {
    // 重新搜索设备
    TICKSSDP_Client *client = [TICKSSDP_Client sharedInstance];
    
    if (![client startOnQueue:nil]) {
        NSLog(@"start error");
        return;
    }
    [client sendDiscoverMessage:nil];
}

#pragma mark - Setter & Getter
- (NSMutableArray *)resultList {
    if (!_resultList) {
        _resultList = [[NSMutableArray alloc] init];
    }
    return _resultList;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultList.count > 0 ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kServiceItemCellIdentifier = @"kServiceItemCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceItemCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kServiceItemCellIdentifier];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    cell.textLabel.text = @"没有找到符合以下条件的Servcie";
    cell.detailTextLabel.text = @"urn:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    return cell;
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
