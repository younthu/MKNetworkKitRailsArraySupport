//
//  OperationSupportRailsArray.h
//  DealGlobe
//
//  Created by Andrew(Zhiyong) Yang on 1/11/16.
//  Copyright © 2016 Fool Dragon. All rights reserved.
//

#import <MKNetworkKit/MKNetworkKit.h>

@interface OperationSupportRailsArray : MKNetworkOperation

@end


@interface MKNetworkEngine (postRailsArrayInUrlParams)
- (MKNetworkOperation *)ay_operationWithPath:(NSString *)path params:(NSDictionary *)body httpMethod:(NSString *)method;
@end