#import "MarkerAnnotation.h"

@implementation MarkerAnnotation

- (id)initWithLocation: (CLLocationCoordinate2D) coord title:(NSString *)title subTitle:(NSString *)subTitle{
    self = [super init];
    if (self) {
        _coordinate = coord;
        _title = title;
        _subtitle = subTitle;
    }
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Marker"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}


@end
