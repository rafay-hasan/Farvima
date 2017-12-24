//
//  MessageObject.h
//  Farvima
//
//  Created by Rafay Hasan on 12/3/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *details;
@property (strong,nonatomic) NSString *creationDate;
@property (strong,nonatomic) NSString *referencePharmacyId;

@end