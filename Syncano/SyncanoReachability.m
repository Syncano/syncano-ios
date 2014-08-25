//
//  SyncanoReachability.m
//  Syncano
//
//  Created by Mariusz Wisniewski on 25/08/14.
//  Copyright (c) 2014 Mindpower. All rights reserved.
//

#import "SyncanoReachability.h"

#import <AFNetworkReachabilityManager.h>

@interface SyncanoReachability ()

@property (strong, nonatomic) AFNetworkReachabilityManager *reachabilityManager;
@property (strong, readwrite, nonatomic) NSString *domain;

@end

@implementation SyncanoReachability

#pragma mark - Private

- (AFNetworkReachabilityManager *)reachabilityManager {
	if (_reachabilityManager == nil) {
		_reachabilityManager = [AFNetworkReachabilityManager managerForDomain:self.domain];
	}
	return _reachabilityManager;
}

- (SyncanoNetworkReachabilityStatus)syncanoNetworkStatusForAFNetworkStatus:(AFNetworkReachabilityStatus)afNetworkStatus {
	SyncanoNetworkReachabilityStatus syncanoStatus = SyncanoNetworkReachabilityStatusUnknown;
  
	switch (afNetworkStatus) {
		case AFNetworkReachabilityStatusUnknown:
			syncanoStatus = SyncanoNetworkReachabilityStatusUnknown;
			break;
      
		case AFNetworkReachabilityStatusNotReachable:
			syncanoStatus = SyncanoNetworkReachabilityStatusNotReachable;
			break;
      
		case AFNetworkReachabilityStatusReachableViaWWAN:
			syncanoStatus = SyncanoNetworkReachabilityStatusReachableViaWWAN;
			break;
      
		case AFNetworkReachabilityStatusReachableViaWiFi:
			syncanoStatus = SyncanoNetworkReachabilityStatusReachableViaWiFi;
			break;
      
		default:
			syncanoStatus = SyncanoNetworkReachabilityStatusUnknown;
			break;
	}
  
	return syncanoStatus;
}

+ (instancetype)reachabilityForDomain:(NSString *)domain {
	if (domain.length == 0) {
		return nil;
	}
	SyncanoReachability *reachability = [[self alloc] init];
	reachability.domain = domain;
	return reachability;
}

#pragma mark - Public

- (BOOL)isReachable {
	return self.reachabilityManager.isReachable;
}

- (BOOL)isReachableViaWWAN {
	return self.reachabilityManager.isReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
	return self.reachabilityManager.isReachableViaWiFi;
}

- (void)startMonitoring {
	[self.reachabilityManager startMonitoring];
}

- (void)stopMonitoring {
	[self.reachabilityManager stopMonitoring];
}

- (void)setReachabilityStatusChangeBlock:(void (^)(SyncanoNetworkReachabilityStatus status))block {
	__weak SyncanoReachability *weakSelf = self;
	[self.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
    SyncanoNetworkReachabilityStatus syncanoStatus = [weakSelf syncanoNetworkStatusForAFNetworkStatus:status];
    if (block) {
      block(syncanoStatus);
		}
	}];
}

@end
