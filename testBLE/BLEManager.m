//
//  BLEManager.m
//  testBLE
//
//  Created by apple on 15/9/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#define kUUID @"FF00"

#import "BLEManager.h"

@interface BLEManager () <CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation BLEManager

+ (BLEManager *)shareBLEManager
{
    static BLEManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[BLEManager alloc]init];

    });
    return manager;
}

- (instancetype)init
{
    if ([super init]) {
        self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------Method-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (id)isKindCBPerpheral:(id)object
{
    if ([object isKindOfClass:[CBPeripheral class]]) {
        return object;
    }
    return nil;
}
/**
 *  搜索设备
 */
- (void)scanForPeripherals
{
    [self.peripheralsArray removeAllObjects];
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}
/**
 *  停止搜索设备
 */
- (void)stopScan
{
    [self.manager stopScan];
}

/**
 *  链接设备
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    [self.manager connectPeripheral:peripheral options:nil];
}

/**
 *  断开链接设备
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral
{
    [self.manager cancelPeripheralConnection:peripheral];
}

/**
 *  写入数据
 */
- (void)writeData:(NSData *)data withPeropheral:(CBPeripheral *)peripheral
{
    
    peripheral.delegate = self;
    //搜索服务   成功后会执行  - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [peripheral discoverServices:nil];
}


#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------CBCentralManagerDelegate-------------------------------------
#pragma mark ----------------------------------------------------------------------
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if ([self.peripheralsArray containsObject:peripheral]) {
        return;
    }
    CBUUID * uuid = [advertisementData[@"kCBAdvDataServiceUUIDs"] firstObject];
    if (![uuid.UUIDString isEqualToString:kUUID]) {
        return;
    }
    
    [self.peripheralsArray addObject:peripheral];

    NSLog(@"peripheral is : %@  ------ data is : %@ ----  RSSI is : %@",peripheral,advertisementData,RSSI);
//    NSLog(@"peripheral is : %@",peripheral);
    if ([self.delegate respondsToSelector:@selector(bLEManager:findPeripheral:)]) {
        [self.delegate bLEManager:self findPeripheral:peripheral];
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManager did update state, centralManager is : %ld",(long)central.state);
    if ([self.delegate respondsToSelector:@selector(bLEManager:state:)]) {
        [self.delegate bLEManager:self state:central.state];
    }

}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"manager didconnect peripheral is: %@ ,error is : %@",peripheral,error);
    if ([self.delegate respondsToSelector:@selector(bLEManager:disconnectPeripheral:)]) {
        [self.delegate bLEManager:self disconnectPeripheral:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"centralManager did connect peripheral, manager is: %@ , peripheral is : %ld",central,(long)peripheral.state);
    
    if ([self.delegate respondsToSelector:@selector(bLEManager:connectPeripheral:)]) {
        [self.delegate bLEManager:self connectPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"centralManager did fail to connect,error is: %@",error);
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
    NSLog(@"manager will Restore state %@",dict);
}


#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------CBPeripheralDelegate-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //搜索到服务  然后匹配服务
    for (CBService * s in peripheral.services) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:kUUID]]) {
            //找到对应的 服务 发送请求  成功后 会
            //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
            
            [peripheral discoverCharacteristics:nil forService:s];
        }
    }
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
     for (CBCharacteristic * c in service.characteristics) {
        NSLog(@"%@",c.UUID.UUIDString);
        NSLog(@"%lu",(unsigned long)c.properties);
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]]) {
        
//            NSData * data = [self stringToHex:@"550502013C01AA"];
//            [peripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
//            [NSThread sleepForTimeInterval:0.2];   ////// 200毫秒
//            
//            data = [self stringToHex:@"550501010901AA"];
//            [peripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
//            [NSThread sleepForTimeInterval:0.2];   ////// 200毫秒
        
            NSData * data = [self stringToHex:@"550504010101AA"];
            [peripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
         
        }
    }
}
- (NSMutableData *) stringToHex:(NSString *)string{
    const char *buf = [string UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);
        if (len %2 != 0) {
           
            
            return data;
        }
        
        for (uint32_t i = 0; i < len; i++) {
            bool isHex = isxdigit(buf[i]);
            if (!isHex) {
               
                return data;
                break;
            }
        }
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp) length:1];
            }
            else
            {
                break;
            }
        }
    }
    return data;
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------Lazy Loading-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (CBCentralManager *)manager
{
    if (!_manager) {
    }
    return _manager;
}
- (NSMutableArray *)peripheralsArray
{
    if (!_peripheralsArray) {
        _peripheralsArray = [NSMutableArray array];
    }
    return _peripheralsArray;
}

@end
