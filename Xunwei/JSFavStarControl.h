

#import <UIKit/UIKit.h>
#import "ReviewTableViewController.h"
@class ReviewTableViewController;

@interface JSFavStarControl : UIControl {
    
    NSInteger _rating;
    
    UIImage *_dot, *_star;
}

@property (nonatomic, readonly) NSInteger rating;
@property ReviewTableViewController *delegate;

// dotImage and starImage can both be nil, or not even a dot or a star (a any images you want!)
// If either of these parameters are nil, the class will draw its own dot/star
// Use location to position the favstar control in your view - the control will manage its own width/height (kind of like UIActivityIndicator)
- (id)initWithLocation:(CGPoint)location dotImage:(UIImage *)dotImage starImage:(UIImage *)starImage;

@end
