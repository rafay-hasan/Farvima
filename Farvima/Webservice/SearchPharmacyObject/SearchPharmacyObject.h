//
//  SearchPharmacyObject.h
//  Farvima
//
//  Created by Rafay Hasan on 12/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchPharmacyObject : NSObject

@property (strong,nonatomic) NSString *pharmacyId;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *addres;
@property (strong,nonatomic) NSString *postalCode;
@property (strong,nonatomic) NSString *vatNumber;
@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *state;
@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *longlitude;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *email;

@end
