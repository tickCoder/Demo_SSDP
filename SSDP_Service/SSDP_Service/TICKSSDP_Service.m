//
//  TICKSSDP_Service.m
//  SSDP_Service
//
//  Created by Claris on 2016.04.20.Wednesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "TICKSSDP_Service.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
#import <ARNAlert/ARNAlert.h>

@interface TICKSSDP_Service () <GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (atomic, assign, getter=isBinded) BOOL binded;
@end

@implementation TICKSSDP_Service

+ (instancetype)sharedInstance {
    static TICKSSDP_Service *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)startOnQueue:(dispatch_queue_t)aQueue {
    if (self.isBinded) {
        return true;
    }
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
    
    if (![_udpSocket bindToPort:1900 error:&error]) {
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

- (void)sendAlive {
    NSMutableString *aliveMessage = [[NSMutableString alloc] initWithString:@"NOTIFY * HTTP/1.1\r\n"];
    //[aliveMessage appendString:@"USER-AGENT: Client/iOS/9.3 SDK/iOS/4.3.20160405\r\n"];
    //[aliveMessage appendFormat:@"ST:urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"NTS:ssdp:alive\r\n"];
    [aliveMessage appendString:@"HOST:239.255.255.250:1900\r\n"];
    [aliveMessage appendString:@"NT: urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"LOCATION:http://192.168.32.1:2351/des.xml\r\n"];
    [aliveMessage appendString:@" CACHE-CONTROL: max-age = 5000\r\n"];
    [aliveMessage appendString:@"SERVER: tick_gateway_os/4.4.1115,UPnP/1.0\r\n"];
    [aliveMessage appendString:@"USN:uuid:GW9823794::name:网关名称::version:4.7::urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"SERVER: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [aliveMessage appendString:@"DATE:20160405030859_GMT8\r\n"];
    
    // 以下为自定义字段
    //[aliveMessage appendString:@"TICK_SEARCH_CODE: ABCDEFG9720348HD\r\n"];
    //[aliveMessage appendString:@"TICK_RESPONSE_CODE: RC98273497\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_ID: GW923JJSDHK79274\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_SYS: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_SDK: GATEWAY_Linux_6.6.20160405\r\n"];
    [aliveMessage appendString:@"\r\n"];

    NSData *aliveData=[aliveMessage dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:aliveData toHost:@"239.255.255.250" port:1900 withTimeout:-11 tag:13];
    
}

- (void)sendByebye {
    NSMutableString *aliveMessage = [[NSMutableString alloc] initWithString:@"NOTIFY * HTTP/1.1\r\n"];
    //[aliveMessage appendString:@"USER-AGENT: Client/iOS/9.3 SDK/iOS/4.3.20160405\r\n"];
    //[aliveMessage appendFormat:@"ST:urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"NTS:ssdp:byebye\r\n"];
    [aliveMessage appendString:@"HOST:239.255.255.250:1900\r\n"];
    [aliveMessage appendString:@"NT: urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"LOCATION:http://192.168.32.1:2351/des.xml\r\n"];
    [aliveMessage appendString:@"CACHE-CONTROL: max-age = 5000\r\n"];
    [aliveMessage appendString:@"SERVER: tick_gateway_os/4.4.1115,UPnP/1.0\r\n"];
    [aliveMessage appendString:@"USN:uuid:GW9823794::name:网关名称::version:4.7::urn:gateway-tick-site:device:gateway:release\r\n"];
    [aliveMessage appendString:@"SERVER: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [aliveMessage appendString:@"DATE:20160405030859_GMT8\r\n"];
    
    // 以下为自定义字段
    //[aliveMessage appendString:@"TICK_SEARCH_CODE: ABCDEFG9720348HD\r\n"];
    //[aliveMessage appendString:@"TICK_RESPONSE_CODE: RC98273497\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_ID: GW923JJSDHK79274\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_SYS: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [aliveMessage appendString:@"TICK_GATEWAY_SDK: GATEWAY_Linux_6.6.20160405\r\n"];
    [aliveMessage appendString:@"\r\n"];
    
    NSData *aliveData=[aliveMessage dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:aliveData toHost:@"239.255.255.250" port:1900 withTimeout:-11 tag:13];
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
    
    if (![message containsString:@"urn:gateway-tick-site:device:gateway:release"]) {
        NSLog(@"receive one message, but not what I want");
        return;
    }
    
    if (![message containsString:@"ssdp:discover"]) {
        return;
    }
    
    NSString *ip =[GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    // 发送消息到来源ip和port
    NSMutableString *responseMessage = [[NSMutableString alloc] initWithString:@"HTTP/1.1 200 OK\r\n"];
    [responseMessage appendFormat:@"Cache-Control: no-cache=\"Ext\", max-age = 5000\r\n"];
    [responseMessage appendFormat:@"Ext:\r\n"];
    //[responseMessage appendString:@"USER-AGENT: Client/iOS/9.3 SDK/iOS/4.3.20160405\r\n"];
    //[responseMessage appendFormat:@"ST:urn:gateway-tick-site:device:gateway:release\r\n"];
    [responseMessage appendString:@"ST: urn:gateway-tick-site:device:gateway:release\r\n"];
    [responseMessage appendString:@"USN:uuid:GW9823794::name:网关名称::version:4.7::urn:gateway-tick-site:device:gateway:release\r\n"];
    [responseMessage appendString:@"SERVER: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [responseMessage appendString:@"DATE:20160405030859_GMT8\r\n"];
    
    // 以下为自定义字段
    [responseMessage appendString:@"TICK_SEARCH_CODE: ABCDEFG9720348HD\r\n"];
    [responseMessage appendString:@"TICK_RESPONSE_CODE: RC98273497\r\n"];
    [responseMessage appendString:@"TICK_GATEWAY_ID: GW923JJSDHK79274\r\n"];
    [responseMessage appendString:@"TICK_GATEWAY_SYS: LINUX/4.5, TICK_GATEWAY/5.3.20160304\r\n"];
    [responseMessage appendString:@"TICK_GATEWAY_SDK: GATEWAY_Linux_6.6.20160405\r\n"];
    [responseMessage appendString:@"\r\n"];
    
    NSLog(@"\nresponseMessage: \n%@", responseMessage);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *showMsg = [NSString stringWithFormat:@"%@:%d\n%@", ip,port,responseMessage];
        [ARNAlert showNoActionAlertWithTitle:@"回应discover" message:showMsg buttonTitle:@"ok"];
    });
    
    NSData *responseData=[responseMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    [_udpSocket sendData:responseData toHost:ip port:port withTimeout:-1 tag:13];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.receivedMessage = message;
        self.receivedIp = ip;
        self.receivedPort = port;
    });
    
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
