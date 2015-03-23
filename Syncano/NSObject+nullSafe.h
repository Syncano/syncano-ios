//
//  NSObject+nullSafe.h
//  Syncano
//
//  Created by Mateusz on 22.01.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASSIGN_IF_NOT_NIL(leftOperand, rightOperand) { if (rightOperand) leftOperand = rightOperand; }

@interface NSObject (SyncanoNullSafe)

- (id)syncanoNullSafe;

@end
