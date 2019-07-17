//
//  BHAddressParser.h
//  BHAddressParser
//
//  Created by 学宝 on 2019/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *BHAddressParserKey;

@class BHAddressModel;


/**
 智能地址解析对象
 
 1. 能够识别多种结构的地址信息
 2. 兼容解析常用平台App的复制地址信息
 3. 结合NSDataDetector智能高效识别，未直接使用地址库检索
 
 */
@interface BHAddressParser : NSObject


/**
 解析文本信息，得到地址信息字典

 @param text 目标文本信息
 @return 地址信息字典
 */
+ (nonnull NSDictionary<BHAddressParserKey, NSString *> *)bh_parserToAddressDictionaryWithText:(nonnull NSString *)text;


/**
 解析文本信息，得到地址信息对象

 @param text 目标文本信息
 @return 地址信息对象
 */
+ (nonnull BHAddressModel *)bh_parserToAddressModelWithText:(nonnull NSString *)text;

@end


@interface BHAddressModel : NSObject

/**
 名字
 根据常用结构，推断名字
 */
@property (nonatomic, copy, nullable) NSString *name;


/**
 联系方式：手机号/固话
 */
@property (nonatomic, copy, nullable) NSString *phone;


/**
 省    （直辖市的情况，如“上海市”，此属性值为“北京”）
 */
@property (nonatomic, copy, nullable) NSString *province;


/**
 市
 */
@property (nonatomic, copy, nullable) NSString *city;


/**
 区/县
 */
@property (nonatomic, copy, nullable) NSString *district;


/**
（街道信息）+ 详细地址
 */
@property (nonatomic, copy, nullable) NSString *detailAddress;

@end

FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserNameKey;
FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserPhoneKey;
FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserProvinceKey;
FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserCityKey;
FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserDistrictKey;
FOUNDATION_EXPORT BHAddressParserKey const BHAddressParserDetailAddressKey;

NS_ASSUME_NONNULL_END
