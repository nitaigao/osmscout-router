#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface OSMRouter : NSObject {
  NSString* mapPath;
}

- (id)initWithMap:(NSString*)mapPath;

- (NSArray*)routeFrom:(CLLocationCoordinate2D)start destination:(CLLocationCoordinate2D)destination;

@end
