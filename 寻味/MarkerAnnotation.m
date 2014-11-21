//
//  MarkerAnnotation.m
//  Foovoor
//
//  Created by Hao Liu on 10/22/14.
//  Copyright (c) 2014 foovoor. All rights reserved.
//

#import "MarkerAnnotation.h"

@implementation MarkerAnnotation

- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self->_coordinate = coord;
    }
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Marker"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    
    return annotationView;
}


@end
