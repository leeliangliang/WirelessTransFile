//
//  NetworkTool.h
//  Pods
//
//  Created by Lee on 2019/4/25.
//


#ifndef IPAddressTool_h
#define IPAddressTool_h

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_WIFI        @"en0"

//获取所有相关IP信息
NSString * WLT_getIPAddresses()
{
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                if (![name isEqualToString:IOS_WIFI])
                {
                    //如果那不是WiFi
                    continue;
                }
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        return [NSString stringWithUTF8String:addrBuf];
                    }
                }
                //                else {
                //                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                //                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                //
                //                    }
                //            }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return nil;
}
#endif /* IPAddressTool_h */
