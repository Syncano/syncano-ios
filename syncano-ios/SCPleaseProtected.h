//
//  SCPleaseProtected.h
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

@interface SCPlease ()

/**
 *  API class name representation of connected SCDataObject Class
 */
@property (nonatomic,retain) NSString *classNameForAPICalls;

- (SCAPIClient *)apiClient;
- (void)handleResponse:(id)responseObject error:(NSError *)error completion:(SCDataObjectsCompletionBlock)completion;

@end
