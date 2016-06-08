//
//  BookStore.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Syncano.h"

@interface BookStore : SCDataObject
@property (nonnull,retain) SCGeoPoint *location;
@end
