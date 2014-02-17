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

- (NSArray*)routeFrom:(NSArray*)params {
	CLLocation* fromLocation = [params objectAtIndex:0];
	CLLocation* destLocation = [params objectAtIndex:1];
	return [[[OSMRouterInternal alloc] initWithMap:mapPath] routeFrom:fromLocation.coordinate 
														  destination:destLocation.coordinate];
}

@end
