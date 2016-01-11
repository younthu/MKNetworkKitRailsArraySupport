//
//  OperationSupportRailsArray.m
//  DealGlobe
//
//  Created by Andrew(Zhiyong) Yang on 1/11/16.
//  Copyright © 2016 Fool Dragon. All rights reserved.
//

#import "OperationSupportRailsArray.h"

@interface MKNetworkOperation(ext)
- (NSString *)encodedPostDataString;
@end

@interface NSDictionary (toUrlQueryString)

- (NSString *)serializeToQueryString ;

@end
@implementation NSDictionary (toUrlQueryString)
- (NSString *)serializeToQueryString {
    NSMutableArray *pairs = NSMutableArray.array;
    for (NSString *key in self.keyEnumerator) {
        id value = self[key];
        if ([value isKindOfClass:[NSDictionary class]])
            for (NSString *subKey in value)
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, [self escapeValueForURLParameter:[value objectForKey:subKey]]]];
        
        else if ([value isKindOfClass:[NSArray class]])
            for (NSString *subValue in value)
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, [self escapeValueForURLParameter:subValue]]];
        
        else
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [self escapeValueForURLParameter:value]]];
        
    }
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)escapeValueForURLParameter:(NSString *)valueToEscape {
    if (![valueToEscape isKindOfClass:[NSString class]]) {
        id v = valueToEscape;
        return [[v stringValue] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]   ];
    }
    return [valueToEscape stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]   ];
}
@end

@implementation OperationSupportRailsArray
- (NSString*)encodedPostDataString {
    NSString *returnValue = @"";
    if(self.postDataEncoding == MKNKPostDataEncodingTypeURL){
        returnValue = [[self valueForKey:@"fieldsToBePosted"] serializeToQueryString];
    }else{
        returnValue = [super encodedPostDataString];
    }
    
    return returnValue;
}
@end

@implementation MKNetworkEngine (postRailsArrayInUrlParams)

- (MKNetworkOperation *)ay_operationWithPath:(NSString *)path params:(NSDictionary *)body httpMethod:(NSString *)method{
    MKNetworkOperation *op = [self operationWithPath:path params:body httpMethod:method];
    
    op.postDataEncoding = MKNKPostDataEncodingTypeCustom;
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return [body serializeToQueryString];
    } forType:@"application/x-www-form-urlencoded"];
    
    return op;
}
@end
