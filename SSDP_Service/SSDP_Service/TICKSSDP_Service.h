//
//  TICKSSDP_Service.h
//  SSDP_Service
//
//  Created by Claris on 2016.04.20.Wednesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 示例
 HTTP/1.1 200 OK
 Cache-Control: no-cache="Ext", max-age = 5000
 Ext:
 LOCATION: http://192.168.4.71:8081/igd.xml
 DATE:20160405030859_GMT8 // 2016.04.05.03:08:59或时间戳
 SERVER: LINUX/4.5, TICK_GATEWAY/5.3.20160304
 ST:urn:gateway-tick-site:device:gateway:release //需要与搜索的一致，与USN后半部分相同
 USN:uuid:GW9823794::name:网关名称::version:4.7::urn:gateway-tick-site:device:gateway:release
 
 TICK_SEARCH_CODE: SC123456 // 标志响应哪个搜索码
 TICK_RESPONSE_CODE: RC98273497 // 回应码
 TICK_GATEWAY_ID: GW923JJSDHK79274 // 网关ID
 TICK_GATEWAY_SYS: LINUX/4.5, TICK_GATEWAY/5.3.20160304 // 网关系统信息
 TICK_GATEWAY_SDK: GATEWAY_Linux_6.6.20160405 // 网关端sdk版本
 
 // DATE:Tue, 01 Mar 2016 08:47:42 GMT+00:00
 // SERVER: Linux/3.10.33 UPnP/1.0 Teleal-Cling/1.0
 // SERVER: tick_gateway_os/4.4.1115,UPnP/1.0
 */

/*
 NOTIFY * HTTP/1.1
 NT:urn:tick-site:device:gateway
 HOST:239.255.255.250:1900（IPv4）或FF0x::C(IPv6)
 NTS:ssdp:alive
 LOCATION:http://192.168.32.1:2351/des.xml
 CACHE-CONTROL: max-age = 5000
 SERVER: tick_gateway_os/4.4.1115,UPnP/1.0
 USN:uuid:GW923JJSDHK79274::urn:schemas-upnp-org:device:tickGateway:4
 
 // 以下待验证，或通过LOCATION进一步验证
 // IP地址可以从Localtion获得的消息中直接获取？
 TICK_RESPONSE_CODE: xljs024 //回应码
 TICK_GATEWAY_ID:GW923JJSDHK79274-GW823497HDI2342394 // 客户端要搜索指定id的网关（可以多个）
 TICK_GATEWAY_IP:192.168.1:8888
 TICK_GATEWAY_SYS:Linux8.3/tick_gateway_os72.34
 TICK_GATEWAY_SDK:gw_linux_8.3 // 网关端sdk版本
 */

/*
 NOTIFY * HTTP/1.1
 NT:urn:tick-site:device:gateway
 HOST:239.255.255.250:1900（IPv4）或FF0x::C(IPv6)
 NTS:ssdp:byebye
 USN:uuid:GW923JJSDHK79274::urn:schemas-upnp-org:device:tickGateway:4
 
 LOCATION:http://192.168.32.1:2351/des.xml
 CACHE-CONTROL: max-age = 5000
 SERVER: tick_gateway_os/4.4.1115,UPnP/1.0
 
 
 // 以下待验证，或通过LOCATION进一步验证
 // IP地址可以从Localtion获得的消息中直接获取？
 TICK_RESPONSE_CODE: xljs024 //回应码
 TICK_GATEWAY_ID:GW923JJSDHK79274-GW823497HDI2342394 // 客户端要搜索指定id的网关（可以多个）
 TICK_GATEWAY_IP:192.168.1:8888
 TICK_GATEWAY_SYS:Linux8.3/tick_gateway_os72.34
 TICK_GATEWAY_SDK:gw_linux_8.3 // 网关端sdk版本
 */

@interface TICKSSDP_Service : NSObject
@property (nonatomic, strong) NSString *receivedMessage;
@property (nonatomic, strong) NSString *receivedIp;
@property (nonatomic, assign) uint16_t receivedPort;
+ (instancetype)sharedInstance;
- (BOOL)startOnQueue:(dispatch_queue_t)aQueue;
- (void)sendAlive;
- (void)sendByebye;
@end
