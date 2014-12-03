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

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, strong) NSURL *imageURL;
@property NSInteger tag;

- (id)initWithLocation: (CLLocationCoordinate2D) coord title:(NSString *)title subTitle:(NSString *)subTitle;

@end