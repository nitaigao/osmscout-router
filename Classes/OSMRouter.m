#import "OSMRouter.h"
#import "OSMRouterInternal.h"

@implementation OSMRouter

- (id)initWithMap:(NSString*)aMapPath {
  self = [super init];
  if (self) {
    mapPath = aMapPath;
  }
  return self;
}

- (NSArray*)routeFrom:(CLLocationCoordinate2D)start destination:(CLLocationCoordinate2D)destination {
  return [[[OSMRouterInternal alloc] initWithMap:mapPath] routeFrom:start destination:destination];
}

@end
