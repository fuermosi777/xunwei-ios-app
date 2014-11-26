//
//  MarkerAnnotation.h
//  Foovoor
//
//  Created by Hao Liu on 10/22/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MarkerAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;
@property NSInteger tag;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

- (MKAnnotationView *)annotationView;


@end