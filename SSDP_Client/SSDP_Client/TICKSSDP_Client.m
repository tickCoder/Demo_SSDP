//
//  TICKSSDP_Client.m
//  SSDP_Client
//
//  Created by Claris on 2016.04.19.Tuesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "TICKSSDP_Client.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

@interface TICKSSDP_Client () <GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong, readwrite) NSMutableArray *serviceList;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (atomic, assign, getter=isBinded) BOOL binded;
@end

@implementation TICKSSDP_Client

+ (instancetype)sharedInstance {
    static TICKSSDP_Client *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _binded = false;
        _serviceList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public
- (BOOL)startOnQueue:(dispatch_queue_t)aQueue {
    if (self.isBinded) {
        return true;
    }
    [self.serviceList removeAllObjects];
    _binded = true;
    NSError *error = nil;
    if (!_udpSocket) {
        if (aQueue) {
            _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:aQueue];
        } else {
            _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        }
    }
    
    [_udpSocket setIPv6Enabled:NO];
    
    if (![_udpSocket bindToPort:0 error:&error]) {
        NSLog(@"%@", error);
        return false;
    }
    
    if (![_udpSocket enableBroadcast:YES error:&error ]) {
        NSLog(@"%@", error);
        return false;
    }
    
    if (![_udpSocket joinMulticastGroup:@"239.255.255.250" error:&error]) {
        NSLog(@"%@", error);
        return false;
    }
    
    if (![_udpSocket beginReceiving:&error]) {
        NSLog(@"%@", error);
        return false;
    }
    
    NSLog(@"start");
    return true;
}

- (BOOL)sendDiscoverMessage:(NSString *)aMessage {
    //!!!: 具体形式如何，根据各家的规定不同而不同。
    /*
     比如TP-Link的路由器需要在尾部增加至少两个NEWLINE，不能有其他的东西。
     而其他的则可能没有这个问题。
     为了能与其它厂家(或者upnp规定)的兼容，ST自断等需要按照标准来，
     其它的可以通过增加自定义字段处理
     */
    
    /*
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
    
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"M-SEARCH * HTTP/1.1\r\n"];
    [message appendFormat:@"HOST: 239.255.255.250:1900\r\n"];
    [message appendFormat:@"MAN: \"ssdp:discover\"\r\n"];
    [message appendFormat:@"MX: 5\r\n"];
    //[message appendString:@"USER-AGENT: Client/iOS/9.3 SDK/iOS/4.3.20160405\r\n"];
    //[message appendFormat:@"ST:urn:gateway-tick-site:device:gateway:release\r\n"];
    [message appendString:@"ST: ssdp:all\r\n"];
    
    // 以下为自定义字段
    [message appendString:@"TICK_SEARCH_CODE: ABCDEFG9720348HD\r\n"];
    [message appendString:@"TICK_CLIENT_ID: C1234123\r\n"];
    [message appendString:@"TICK_CLIENT_SYS: iOS9.3\r\n"];
    [message appendString:@"TICK_CLIENT_SDK: CLIENT_iOS_4.3.20160405\r\n"];
    [message appendString:@"TICK_GATEWAY_ID: GW9823794-GW923479\r\n"];
    [message appendString:@"\r\n"];
    
    NSLog(@"\n%@", message);
    
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:@"239.255.255.250" port:1900 withTimeout:-1 tag:11];
    return true;
}

#pragma mark <GCDAsyncUdpSocketDelegate>
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"%@", address);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"%ld", tag);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"%ld, %@", tag, error);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    if (![message containsString:@"urn:gateway-tick-site:device:gateway:release"]) {
//        NSLog(@"receive one message, but not what I want");
//        return;
//    }
    
    NSString *ip =[GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSLog(@"\n%@:%d\n\n%@",ip, port, message);

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self mutableArrayValueForKey:@"serviceList"] addObject:message];//方便observer
    });
    
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"%@", error);
}
@end
