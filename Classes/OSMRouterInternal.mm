#import "OSMRouterInternal.h"

#include <osmscout/Database.h>
#include <osmscout/Router.h>
#include <osmscout/RoutePostprocessor.h>

#include <osmscout/util/Geometry.h>

@implementation OSMRouterInternal

- (id)initWithMap:(NSString*)aMapPath {
  self = [super init];
  if (self) {
    mapPath = aMapPath;
  }
  return self;
}

- (NSArray*)routeFrom:(CLLocationCoordinate2D)start destination:(CLLocationCoordinate2D)destination {
  double startLat = start.latitude;// 51.507222;
  double startLon = start.longitude;// -0.1275;
  
  osmscout::Vehicle                         vehicle=osmscout::vehicleFoot;
  osmscout::FastestPathRoutingProfile       routingProfile;
  
  std::string                               map = [mapPath cStringUsingEncoding:NSUTF8StringEncoding];
  
  double                                    targetLat = destination.latitude;// 51.507222;
  double                                    targetLon = destination.longitude ;//-0.1285;
  
  osmscout::ObjectFileRef                   startObject;
  size_t                                    startNodeIndex;
  
  osmscout::ObjectFileRef                   targetObject;
  size_t                                    targetNodeIndex;
  
  double tlat;
  double tlon;
  
  osmscout::GetEllipsoidalDistance(startLat, startLon, 45, 1000, tlat, tlon);
  
  osmscout::DatabaseParameter databaseParameter;
  osmscout::Database          database(databaseParameter);
  
  if (!database.Open(map.c_str())) {
    std::cerr << "Cannot open database" << std::endl;
  }
  
  osmscout::RouterParameter routerParameter;
  
  osmscout::Router router(routerParameter, vehicle);
  
  if (!router.Open(map.c_str())) {
    std::cerr << "Cannot open routing database" << std::endl;
  }
  
  osmscout::TypeConfig                *typeConfig=router.GetTypeConfig();
  osmscout::RouteData                 data;
  osmscout::RouteDescription          description;
  std::map<std::string,double>        carSpeedTable;
  
  routingProfile.ParametrizeForFoot(*typeConfig, 5.0);

  if (!database.GetClosestRoutableNode(startLat,
                                       startLon,
                                       vehicle,
                                       1000,
                                       startObject,
                                       startNodeIndex)) {
    std::cerr << "Error while searching for routing node near start location!" << std::endl;
  }
  
  if (startObject.Invalid() || startObject.GetType()==osmscout::refNode) {
    std::cerr << "Cannot find start node for start location!" << std::endl;
  }
  
  if (!database.GetClosestRoutableNode(targetLat,
                                       targetLon,
                                       vehicle,
                                       1000,
                                       targetObject,
                                       targetNodeIndex)) {
    std::cerr << "Error while searching for routing node near target location!" << std::endl;
  }
  
  if (targetObject.Invalid() || targetObject.GetType()==osmscout::refNode) {
    std::cerr << "Cannot find start node for target location!" << std::endl;
  }
  
  if (!router.CalculateRoute(routingProfile,
                             startObject,
                             startNodeIndex,
                             targetObject,
                             targetNodeIndex,
                             data)) {
    std::cerr << "There was an error while calculating the route!" << std::endl;
    router.Close();
  }
  
  if (data.IsEmpty()) {
    std::cout << "No Route found!" << std::endl;
    
    router.Close();
  }
  
  router.TransformRouteDataToRouteDescription(data,description);
  
  std::list<osmscout::RoutePostprocessor::PostprocessorRef> postprocessors;
  postprocessors.push_back(new osmscout::RoutePostprocessor::DistanceAndTimePostprocessor());
  postprocessors.push_back(new osmscout::RoutePostprocessor::StartPostprocessor("Start"));
  postprocessors.push_back(new osmscout::RoutePostprocessor::TargetPostprocessor("Target"));
  postprocessors.push_back(new osmscout::RoutePostprocessor::WayNamePostprocessor());
  postprocessors.push_back(new osmscout::RoutePostprocessor::CrossingWaysPostprocessor());
  postprocessors.push_back(new osmscout::RoutePostprocessor::DirectionPostprocessor());
  
  osmscout::RoutePostprocessor::InstructionPostprocessor *instructionProcessor=new osmscout::RoutePostprocessor::InstructionPostprocessor();
  instructionProcessor->AddMotorwayType(typeConfig->GetWayTypeId("highway_motorway"));
  instructionProcessor->AddMotorwayLinkType(typeConfig->GetWayTypeId("highway_motorway_link"));
  instructionProcessor->AddMotorwayType(typeConfig->GetWayTypeId("highway_motorway_trunk"));
  instructionProcessor->AddMotorwayType(typeConfig->GetWayTypeId("highway_motorway_primary"));
  instructionProcessor->AddMotorwayType(typeConfig->GetWayTypeId("highway_trunk"));
  instructionProcessor->AddMotorwayLinkType(typeConfig->GetWayTypeId("highway_trunk_link"));
  postprocessors.push_back(instructionProcessor);
  
  std::list<osmscout::Point> points;
  
  if (!router.TransformRouteDataToPoints(data, points)) {
    std::cerr << "Error during route conversion" << std::endl;
  }
  
  NSMutableArray* results = [NSMutableArray array];
  
  for (std::list<osmscout::Point>::const_iterator point=points.begin(); point!=points.end(); ++point) {
    CLLocation* location = [[CLLocation alloc] initWithLatitude:point->GetLat() longitude:point->GetLon()];
    [results addObject:location];
  }
  
  return results;
}

@end
