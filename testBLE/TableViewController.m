//
//  TableViewController.m
//  testBLE
//
//  Created by apple on 15/9/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TableViewController.h"
#import "BLEManager.h"
@interface TableViewController () <BLEManagerDelegate>
@property (nonatomic,strong)BLEManager * manager;

@property (nonatomic,strong)NSMutableArray * connectArray;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.manager = [BLEManager shareBLEManager];
    self.manager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
- (IBAction)search:(id)sender {
    [self.manager scanForPeripherals];
    
}
- (IBAction)sendAction:(id)sender {
    
    
    [self.manager writeData:nil withPeropheral:self.connectArray.firstObject];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------BLEManager Delegate-------------------------------------
#pragma mark ----------------------------------------------------------------------
- (void)bLEManager:(BLEManager *)bLEManager state:(int)state
{
    
}
/**
 *  成功搜索到设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager findPeripheral:(CBPeripheral *)peripheral
{
    [self.tableView reloadData];
}
/**
 *  链接到设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager connectPeripheral:(CBPeripheral *)peripheral
{
    [self.connectArray addObject:peripheral];
}
/**
 *  断开设备
 *
 *  @param bLEManager manager
 *  @param peripheral 设备
 */
- (void)bLEManager:(BLEManager *)bLEManager disconnectPeripheral:(CBPeripheral *)peripheral
{
    [self.connectArray removeObject:peripheral];
}




#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------tableView Delegate-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.manager.peripheralsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a" forIndexPath:indexPath];
    
    CBPeripheral * peripheral = [self.manager isKindCBPerpheral:self.manager.peripheralsArray[indexPath.row]];
    if (peripheral) {
        cell.textLabel.text = peripheral.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral * peripheral = [self.manager isKindCBPerpheral:self.manager.peripheralsArray[indexPath.row]];
    if (peripheral.state == CBPeripheralStateDisconnected) {
        [self.manager connectPeripheral:peripheral];
    } else if(peripheral.state == CBPeripheralStateConnected || peripheral.state == CBPeripheralStateConnecting){
        [self.manager disconnectPeripheral:peripheral];
    }
}

#pragma mark ----------------------------------------------------------------------
#pragma mark ----------------------Lazy Loading-------------------------------------
#pragma mark ----------------------------------------------------------------------

- (NSMutableArray *)connectArray
{
    if (!_connectArray) {
        _connectArray = [NSMutableArray array];
    }
    return _connectArray;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
