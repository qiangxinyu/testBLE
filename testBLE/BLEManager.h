//
//  BLEManager.h
//  testBLE
//
//  Created by apple on 15/9/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class BLEManager;
@protocol BLEManagerDelegate <NSObject>

/**
 *  返回蓝牙状态
    0.初始的时候是未知的（刚刚创建的时候）
    1.正在重置状态
    2.设备不支持的状态
    3.设备未授权状态
    4.设备关闭状态
    5.设备开启状态 -- 可用状态
 *
 */
- (void)bLEManager:(BLEManager *)bLEManager state:(int)state;
/**
 *  成功搜索到设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager findPeripheral:(CBPeripheral *)peripheral;
/**
 *  链接到设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager connectPeripheral:(CBPeripheral *)peripheral;
/**
 *  断开设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager disconnectPeripheral:(CBPeripheral *)peripheral;
@end

@interface BLEManager : NSObject

@property (nonatomic,strong)CBCentralManager * manager;
@property (nonatomic,strong)NSMutableArray * peripheralsArray;
@property (nonatomic,assign)id<BLEManagerDelegate>  delegate;

+ (BLEManager *)shareBLEManager;

- (id)isKindCBPerpheral:(id)object;

/**
 *  搜索设备
 */
- (void)scanForPeripherals;

/**
 *  停止搜索设备
 */
- (void)stopScan;

/**
 *  链接设备
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 *  断开链接设备
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;

/**
 *  写入数据
 */
- (void)writeData:(NSData *)data withPeropheral:(CBPeripheral *)peripheral;
@end
