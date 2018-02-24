//
//  PharmacyObject.h
//  Farvima
//
//  Created by Rafay Hasan on 2/23/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PharmacyObject : NSObject

@property (strong,nonatomic) NSString *latitude,*longlititude,*phone,*facebookUrl,*totalOffer,*emailAddress,*webAddress,*location;
@property (strong,nonatomic) NSArray *eventArray;

@end
