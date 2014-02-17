#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface OSMRouter : NSObject {
  NSString* mapPath;
}

- (id)initWithMap:(NSString*)mapPath;

- (NSArray*)routeFrom:(NSArray*)params;

@end
