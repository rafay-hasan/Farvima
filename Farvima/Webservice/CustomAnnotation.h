//
//  CustomAnnotation.h
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
