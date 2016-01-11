# MKNetworkKitRailsArraySupport
Support rails way of query parameters.

# Submit array&dict to rails api

If you've beening work with rails api, you will familiar with array&dict query paramters like this

~~~objc
/api/search?p1[min]=-999&p1[max]=999&p2[]=3&p2[]=4 
~~~

It's oc code should be  should be

~~~objc

[MKNetworkEngine sharedEngine] operationWithPath:@"api/search" params:@{@"p1"":{@"min":@-999, @"max":999}, @"p2":@[@3,@4]}

~~~

But ,

MKNetworkKit does not support this way.


So, i write some code to support it.


# How to use it

1. Register operation to engine

   ~~~objc
   [MKNetworkEngine.sharedEngine registerOperationSubclass:[OperationSupportRailsArray class]];
   ~~~
1. Create operation in this way

	~~~objc
	MKNetworkOperation *op = [[MKNetworkEngine sharedEngine] ay_operationWithPath:@"api/search" params:@{@"p1"":{@"min":@-999, @"max":999}, @"p2":@[@3,@4]} httpMethod:@"GET"];

	~~~
	

1. Go as normal MKNetwork way, and Done.


# If you don't want subclass of MKNetworkOperation

You can try to modify method of MKNetworkEngine in line 354~362

~~~objc

-(MKNetworkOperation*) operationWithURLString:(NSString*) urlString
                                       params:(NSDictionary*) body
                                   httpMethod:(NSString*)method {
  # The bug lies in the init of operation, Please figure out a way to  set the custom handler before init the operation. maybe an init method with custom data encoding handler
  MKNetworkOperation *operation = [[self.customOperationSubclass alloc] initWithURLString:urlString params:body httpMethod:method]; 
  
  [self prepareHeaders:operation];
  return operation;
}
~~~

