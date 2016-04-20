//
//  ListTableViewController.m
//  SSDP_Client
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ListTableViewController.h"
#import "TICKSSDP_Client.h"
#import "DetailViewController.h"

@interface ListTableViewController ()
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, weak) TICKSSDP_Client *ssdpClient;
@end

@implementation ListTableViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _resultList = [[NSMutableArray alloc] init];
    _ssdpClient = [TICKSSDP_Client sharedInstance];
    [_ssdpClient addObserver:self forKeyPath:@"serviceList" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"serviceList"]) {
        [self.resultList addObjectsFromArray:[change objectForKey:NSKeyValueChangeNewKey]];
        //NSLog(@"<%d>, %@", __LINE__, self.resultList);
        //NSLog(@"<%d>, %@", __LINE__, self.tableView);
        //[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:5.0];
        [self.tableView reloadData];
    }
}

#pragma mark - Response
- (IBAction)refreshBtnAction:(id)sender {
    [self.resultList removeAllObjects];
    [self.tableView reloadData];
    // 重新搜索设备
    TICKSSDP_Client *client = [TICKSSDP_Client sharedInstance];
    
    if (![client startOnQueue:nil]) {
        NSLog(@"start error");
        return;
    }
    [client sendDiscoverMessage:nil];
}

- (IBAction)all_refreshBtnAction:(id)sender {
    [self.resultList removeAllObjects];
    [self.tableView reloadData];
    // 重新搜索设备
    TICKSSDP_Client *client = [TICKSSDP_Client sharedInstance];
    
    if (![client startOnQueue:nil]) {
        NSLog(@"start error");
        return;
    }
    [client sendDiscoverMessage:@"all"];
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
    return self.resultList.count > 0 ? self.resultList.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kServiceItemCellIdentifier = @"kServiceItemCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceItemCellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:
//                kServiceItemCellIdentifier];
//        cell.clipsToBounds = true;
//        cell.detailTextLabel.numberOfLines = 0;
//        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
//    }
    
    if (self.resultList.count==0) {
        cell.textLabel.text = @"没有找到符合以下条件的Servcie";
        cell.detailTextLabel.text = @"urn:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"找到%ld/%lu个",(long)indexPath.row+1, (unsigned long)self.resultList.count];
        cell.detailTextLabel.text = self.resultList[indexPath.row];
    }
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (self.resultList.count==0) {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue destinationViewController] isKindOfClass:[DetailViewController class]]) {
        NSString *message = self.resultList[indexPath.row];
        DetailViewController *desVC = (DetailViewController *)[segue destinationViewController];
        desVC.message = message;
    }
    [super prepareForSegue:segue sender:sender];
}

@end
