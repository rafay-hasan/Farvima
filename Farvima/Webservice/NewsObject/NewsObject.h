//
//  NewsObject.h
//  Farvima
//
//  Created by Rafay Hasan on 12/3/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *details;
@property (strong,nonatomic) NSString *imageUel;
@property (strong,nonatomic) NSString *creationDate;

@end