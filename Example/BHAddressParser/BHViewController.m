//
//  BHViewController.m
//  BHAddressParser
//
//  Created by 学宝 on 06/12/2019.
//  Copyright (c) 2019 学宝. All rights reserved.
//

#import "BHViewController.h"
#import <BHAddressParser/BHAddressParser.h>

@interface BHViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BHAddressModel *addressModel;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (nonatomic, strong) NSDictionary *addressDict;
@end

@implementation BHViewController
- (IBAction)pressParseButtonAction:(id)sender {
    [self parserTextViewText];
}
- (IBAction)changeSwitch:(UISwitch *)sender {
    [self.tableView reloadData];
}

- (void)parserTextViewText {
    _addressDict = [BHAddressParser bh_parserToAddressDictionaryWithText:self.textView.text];
    _addressModel = [BHAddressParser bh_parserToAddressModelWithText:self.textView.text];
    
    [self.textView resignFirstResponder];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"结构地址解析";
    [self.modeSwitch setOn:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Choose Text" style:UIBarButtonItemStylePlain target:self action:@selector(pressRightBarItem)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"asdfadsfwer123"];
}

- (void)pressRightBarItem {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                             message:@"用于测试的几种格式"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"姓名+电话+地址"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              马云15000000000安徽省宣城市广德县富康路姚家园3楼
                                                              ***/
                                                             weakSelf.textView.text = @"马云15000000000安徽省宣城市广德县富康路姚家园3楼";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction2];

    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"姓名+地址+电话"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              马云北京市朝阳区富康路姚家园3楼15000000000
                                                              ***/
                                                             weakSelf.textView.text = @"马云北京市朝阳区富康路姚家园3楼15000000000";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction3];
    
    UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"地址+电话+姓名"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              北京市朝阳区富康路姚家园3楼15000000000马云
                                                              ***/
                                                             weakSelf.textView.text = @"北京市朝阳区富康路姚家园3楼150000-0000马云";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction4];
    
    UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:@"地址+姓名+电话"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              北京市朝阳区富康路姚家园3号楼5单元3305欧阳啃不起15000000000
                                                              ***/
                                                             weakSelf.textView.text = @"北京市朝阳区富康路姚家园3号楼5单元3305欧阳啃不起15000000000";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction5];
    
    UIAlertAction *alertAction6 = [UIAlertAction actionWithTitle:@"电话+姓名+地址"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              15000000000马云北京市朝阳区富康路姚家园3号楼5单元3305邮编038300
                                                              ***/
                                                             weakSelf.textView.text = @"15000000000马云北京市朝阳区富康路姚家园3号楼5单元3305邮编038300";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction6];
    
    UIAlertAction *alertAction7 = [UIAlertAction actionWithTitle:@"电话+地址+姓名"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              15000000000北京市朝阳区富康路姚家园3号楼5单元3305马云
                                                              ***/
                                                             weakSelf.textView.text = @"15000000000北京市朝阳区富康路姚家园3号楼5单元3305马云";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction7];
    
    UIAlertAction *alertAction8 = [UIAlertAction actionWithTitle:@"复制-淘宝-收货人"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              收货人: 学宝
                                                              手机号码: 13888888888
                                                              所在地区: 浙江省杭州市江干区白杨街道
                                                              详细地址: 天真小区顽皮苑6幢3单元2019室
                                                              ***/
                                                             weakSelf.textView.text = @"收货人: 学宝\n手机号码: 13888888888\n所在地区: 浙江省杭州市江干区白杨街道\n详细地址: 天真小区顽皮苑6幢3单元2019室";
                                                             [weakSelf parserTextViewText];
                                                         }];
    [alertController addAction:alertAction8];
    
    UIAlertAction *alertAction9 = [UIAlertAction actionWithTitle:@"复制-微信-我的地址"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              联系人：学宝
                                                              手机号码：05716666888
                                                              地区：浙江省 杭州市 江干区
                                                              详细地址：经济技术开发区新加坡杭州科技园188幢
                                                              邮政编码：310016
                                                              ***/
                                                             weakSelf.textView.text = @"联系人：学宝\n手机号码：05716666888\n地区：浙江省 杭州市 江干区\n详细地址：经济技术开发区新加坡杭州科技园188幢\n邮政编码：310016";
                                                             [weakSelf parserTextViewText];

                                                         }];
    [alertController addAction:alertAction9];

    UIAlertAction *alertAction10 = [UIAlertAction actionWithTitle:@"复制-京东-地址管理"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             /***
                                                              姓名：学宝
                                                              地址：安徽合肥市瑶海区城区 合肥市瑶海区胜利路126号
                                                              ***/
                                                             weakSelf.textView.text = @"                                                              姓名：学宝\n地址：安徽合肥市瑶海区城区 合肥市瑶海区胜利路126号";
                                                             [weakSelf parserTextViewText];
                                                             
                                                         }];
    [alertController addAction:alertAction10];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
//                                                             [alertController dismissViewControllerAnimated:YES completion:NULL];
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"asdfadsfwer123" forIndexPath:indexPath];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.2f;
    switch (indexPath.row) {
        case 0:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"姓名：" stringByAppendingString:self.addressModel.name ?: @""];
            }else {
                cell.textLabel.text = [@"姓名：" stringByAppendingString:self.addressDict[BHAddressParserNameKey] ?: @""];
            }
            break;
        case 1:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"联系方式：" stringByAppendingString:self.addressModel.phone ?: @""];
            }else{
                cell.textLabel.text = [@"联系方式：" stringByAppendingString:self.addressDict[BHAddressParserPhoneKey] ?: @""];
                NSLog(@"\n addressDict:%@   \n phone:%@",self.addressDict,self.addressDict[BHAddressParserPhoneKey]);
            }
            break;
        case 2:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"省：" stringByAppendingString:self.addressModel.province ?: @""];
            }else {
                cell.textLabel.text = [@"省：" stringByAppendingString:self.addressDict[BHAddressParserProvinceKey] ?: @""];
            }
            break;
        case 3:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"市：" stringByAppendingString:self.addressModel.city ?: @""];
            }else {
                cell.textLabel.text = [@"市：" stringByAppendingString:self.addressDict[BHAddressParserCityKey] ?: @""];
            }
            break;
        case 4:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"区：" stringByAppendingString:self.addressModel.district ?: @""];
            }else {
                cell.textLabel.text = [@"区：" stringByAppendingString:self.addressDict[BHAddressParserDistrictKey] ?: @""];
            }
            break;
        case 5:
            if (self.modeSwitch.isOn) {
                cell.textLabel.text = [@"详细地址：" stringByAppendingString:self.addressModel.detailAddress ?: @""];
            }else {
                cell.textLabel.text = [@"详细地址：" stringByAppendingString:self.addressDict[BHAddressParserDetailAddressKey] ?: @""];
            }
            break;
        default:

            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
