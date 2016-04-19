//
//  TICKSSDP_Client.h
//  SSDP_Client
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 示例
 M-SEARCH * HTTP/1.1
 HOST:239.255.255.250:1900
 MAN:"ssdp:discover"
 MX:5
 ST:urn:gateway-tick-site:device:gateway:release // release, debug, all 等等
 DATE:20160405030859_GMT8 // 2016.04.05.03:08:59或时间戳
 
 TICK_SEARCH_CODE: SC123456 // 搜索码
 TICK_CLIENT_ID: C1234123 // 客户端编号
 TICK_CLIENT_SYS: iOS9.3 // 客户端系统信息
 TICK_CLIENT_SDK: CLIENT_iOS_4.3.20160405 // 客户端使用的SDK版本为iOS版4.3.20160405，根据此版本可以找到其支持的网关版本
 TICK_GATEWAY_ID: GW9823794-GW923479 //仅搜索ID为GW9823794和GW923479的网关
 */

@interface TICKSSDP_Client : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *serviceList;
+ (instancetype)sharedInstance;
- (BOOL)startOnQueue:(dispatch_queue_t)aQueue;
- (BOOL)sendDiscoverMessage:(NSString *)aMessage;

@end
