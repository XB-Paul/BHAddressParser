//
//  BHAddressParser.m
//  BHAddressParser
//
//  Created by 学宝 on 2019/7/16.
//

#import "BHAddressParser.h"

static const NSInteger kAddressParserNameMaxLength = 5;

BHAddressParserKey const BHAddressParserNameKey = @"com.bhaddressparser.name.key";
BHAddressParserKey const BHAddressParserPhoneKey = @"com.bhaddressparser.phone.key";
BHAddressParserKey const BHAddressParserProvinceKey = @"com.bhaddressparser.province.key";
BHAddressParserKey const BHAddressParserCityKey = @"com.bhaddressparser.city.key";
BHAddressParserKey const BHAddressParserDistrictKey = @"com.bhaddressparser.district.key";
BHAddressParserKey const BHAddressParserDetailAddressKey = @"com.bhaddressparser.detailaddress.key";

@implementation BHAddressParser
+ (NSDictionary<BHAddressParserKey,NSString *> *)bh_parserToAddressDictionaryWithText:(NSString *)text {
    return [self bh_parserAddressText:text useModel:NO];
}

+ (BHAddressModel *)bh_parserToAddressModelWithText:(NSString *)text {
    return [self bh_parserAddressText:text useModel:YES];
}


+ (id)bh_parserAddressText:(NSString *)text useModel:(BOOL)useModel {
    __block NSString *parserName = nil;
    __block NSString *parserPhone = nil;
    __block NSString *parserProvince = nil;
    __block NSString *parserCity = nil;
    __block NSString *areaAndDetailAddress = nil;
    NSString *parserDistrict = nil;
    NSString *parserAddress = nil;
    
    
    NSString *addressStr = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    addressStr = [addressStr stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    if (addressStr.length < 1) {
        return nil;
    }
    NSError *error;
    if ([addressStr containsString:@"\n"] ) {
        NSArray <NSString *>*addressStrArray = [addressStr componentsSeparatedByString:@"\n"];
        NSMutableArray *tempStrArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < addressStrArray.count; i++) {
            NSString *itemStr = addressStrArray[i];
            if ([itemStr containsString:@":"]) {
                NSArray *itemStrArray = [itemStr componentsSeparatedByString:@":"];
                if (itemStrArray.count > 1) {
                    NSString *itemKeyStr = itemStrArray.firstObject;
                    NSString *itemValueStr = itemStrArray.lastObject;
                    if (([itemKeyStr containsString:@"人"] || [itemKeyStr containsString:@"名"] || [itemKeyStr containsString:@"name"]) && itemValueStr.length > 0) {
                        parserName = itemValueStr;
                    }else if (([itemKeyStr containsString:@"手机号"] || [itemKeyStr containsString:@"联系方式"] || [itemKeyStr containsString:@"号码"]) && itemValueStr.length > 5) {
                        parserPhone = itemValueStr;
                    }else {
                        [tempStrArray addObject:itemValueStr];
                    }
                }else {
                    [tempStrArray addObject:itemStrArray.lastObject];
                }
            }else {
                [tempStrArray addObject:itemStr];
            }
        }
        addressStr = [tempStrArray componentsJoinedByString:@""];
    }
    
    __block NSRange phoneRange = NSMakeRange(NSNotFound, NSNotFound);
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeAddress error:&error];
    
    [detector enumerateMatchesInString:addressStr options:0 range:NSMakeRange(0, addressStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.phoneNumber && parserPhone == nil) {
            phoneRange = result.range;
            parserPhone = result.phoneNumber;
        }
        if (result.addressComponents) {
            [result.addressComponents enumerateKeysAndObjectsUsingBlock:^(NSTextCheckingKey  _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:NSTextCheckingNameKey]) {
                    parserName  = obj;
                }else if ([key isEqualToString:NSTextCheckingStateKey]) {
                    parserProvince = obj;
                }else if ([key isEqualToString:NSTextCheckingCityKey]) {
                    parserCity = obj;
                }else if ([key isEqualToString:NSTextCheckingStreetKey]) {
                    //此处的街道信息，包含了“区”+“详细地址”
                    areaAndDetailAddress = obj;
//                    NSLog(@"areaAndDetailAddress:%@",areaAndDetailAddress);
                }else if ([key isEqualToString:NSTextCheckingPhoneKey] && parserPhone == nil) {
                    parserPhone = obj;
                }
            }];
        }
    }];
    
    if (parserProvince == nil && parserCity!=nil) {
        //直辖市
        if (parserCity.length > 2) {
            //目前中国的直辖市，都是三个字的
            //此处解决的问题是识别类似“北京北京市...”
            parserCity = [parserCity substringFromIndex:parserCity.length - 3];
            if ([parserCity hasSuffix:@"市"]) {
                parserProvince = [parserCity substringToIndex:parserCity.length - 1];
            }else {
                parserProvince = parserCity;
            }
        }else {
            parserCity = nil;
        }
    }
    
    if (parserCity) {
        //通过特定字符（“区”和“县”）拆分，解析出“区/县”和“详细地址”
        NSRange areaRange;
        if ([areaAndDetailAddress containsString:@"区"]) {
            areaRange = [areaAndDetailAddress rangeOfString:@"区"];
            parserDistrict = [areaAndDetailAddress substringWithRange:NSMakeRange(0, areaRange.length + areaRange.location)];
            parserAddress = [areaAndDetailAddress substringFromIndex:areaRange.length + areaRange.location];
        }else if ([areaAndDetailAddress containsString:@"县"]){
            areaRange = [areaAndDetailAddress rangeOfString:@"县"];
            parserDistrict = [areaAndDetailAddress substringWithRange:NSMakeRange(0, areaRange.length + areaRange.location)];
            parserAddress = [areaAndDetailAddress substringFromIndex:areaRange.length + areaRange.location];
        } else {
            parserAddress = areaAndDetailAddress;
        }
        
        
        //以下是认定“姓名”逻辑
        NSRange provinceRange = [addressStr rangeOfString:parserProvince];
        NSRange areaAndDetailRange = [addressStr rangeOfString:areaAndDetailAddress];
        
        if (parserName == nil && phoneRange.location > 0 && phoneRange.location <= kAddressParserNameMaxLength) {
            //当“电话”前面不大于5个字符，认定“电话”之前是“姓名”
            parserName = [addressStr substringToIndex:phoneRange.location];
        }else if (parserName == nil && provinceRange.location >0 && provinceRange.location <= kAddressParserNameMaxLength) {
            //当“省”前面不大于5个字符，认定“省”之前是“姓名”
            parserName = [addressStr substringToIndex:provinceRange.location];
        }else if (parserName == nil && phoneRange.location > areaAndDetailRange.location) {
             //“电话”在“详细”之后
            NSInteger afterPhoneLength = addressStr.length - NSMaxRange(phoneRange);
            if (afterPhoneLength > 0 && afterPhoneLength <= kAddressParserNameMaxLength) {
                //“电话”在“详细”之后，优先去认定“电话”后面的信息是姓名
                parserName = [addressStr substringWithRange:NSMakeRange(NSMaxRange(phoneRange), afterPhoneLength)];
            }else {
                NSInteger length = phoneRange.location - NSMaxRange(areaAndDetailRange);
                if (length > 0 && length <= kAddressParserNameMaxLength) {
                    //“电话”在“详细”之后，且“电话”后面的信息不是姓名， 认定“详细”和“电话”之间是姓名
                    parserName = [addressStr substringWithRange:NSMakeRange(NSMaxRange(areaAndDetailRange), length)];
                }
            }

        }else if (parserName == nil && phoneRange.location < provinceRange.location) {
            //“电话”在“省”之前
            NSInteger length = provinceRange.location - NSMaxRange(phoneRange);
            if (length > 0 && length <= kAddressParserNameMaxLength) {
                //“电话”在“省”之前，认定“电话”和“省”之间是姓名
                parserName = [addressStr substringWithRange:NSMakeRange(NSMaxRange(phoneRange), length)];
            }else {
                NSInteger afterDetailLength = addressStr.length - NSMaxRange(areaAndDetailRange);
                if (afterDetailLength > 0 && afterDetailLength <= kAddressParserNameMaxLength) {
                    //“电话”在“省”之前，且 “电话”和“省”之间不是姓名，认定“详细”之后是姓名
                    parserName = [addressStr substringWithRange:NSMakeRange(NSMaxRange(areaAndDetailRange), afterDetailLength)];
                }
            }
        }
        
    }else {
        parserAddress = text;
    }

    
    if (useModel) {
        BHAddressModel *addressModel = [BHAddressModel new];
        addressModel.name = parserName;
        addressModel.phone = parserPhone;
        addressModel.province = parserProvince;
        addressModel.city = parserCity;
        addressModel.district = parserDistrict;
        addressModel.detailAddress = parserAddress;
        return addressModel;
    }else {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:parserName forKey:BHAddressParserNameKey];
        [dict setValue:parserPhone forKey:BHAddressParserPhoneKey];
        [dict setValue:parserProvince forKey:BHAddressParserProvinceKey];
        [dict setValue:parserCity forKey:BHAddressParserCityKey];
        [dict setValue:parserDistrict forKey:BHAddressParserDistrictKey];
        [dict setValue:parserAddress forKey:BHAddressParserDetailAddressKey];
        return dict;
    }
}

@end

@implementation BHAddressModel

@end
