//
//  MapViewController.m
//  
//
//  Created by James Rochabrun on 11/3/16.
//
//

#import "MapViewController.h"
@import GoogleMaps;
#import "CSMarker.h"

@interface MapViewController ()<GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (copy, nonatomic) NSSet *markers;
@property (strong, nonatomic) CSMarker *userCreatedMarker;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //codeSchool
   // [self putCameraOnMapPosition];
    [self customMarker];
    //[self polyline];
   // [self camera];
   // [self indoor];

    //[self streetView];

}

//code school
//step 1 create a camera and a mapview
- (void)customMarker {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.887
                                                            longitude:-87.622
                                                                 zoom:15];
    
    
    CGRect frame = CGRectMake(0, (self.view.frame.size.height - 300) /2, self.view.frame.size.width, 300);
    
    self.mapView = [GMSMapView mapWithFrame:frame camera:camera];
    self.mapView.delegate = self;
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    // marker.icon = [UIImage imageNamed:@"flag_icon"];
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = _mapView;
//    
    [self.view addSubview:_mapView];
    [self setupMarkerData];
}

//step 2 set up markers
- (void)setupMarkerData {
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(41.895, -87.622);
    marker.title = @"uno";
    marker.map = nil;

    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(41.887, -87.622);
    marker1.title = @"dos";
    marker1.map = nil;

    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(41.880, -87.622);
    marker2.title = @"tres";
    marker2.map = nil;
    
   self.markers = [NSSet setWithObjects:marker, marker1, marker2, nil];
    [self drawMarkers];
}

//step 3 display markers in map
- (void)drawMarkers {
    
    //for markers coming form an API call
    for (GMSMarker *marker in self.markers) {
        
        if (marker.map == nil) {
            marker.map = self.mapView;
        }
    }
    
    //for user markers OPTIONAL
    if (self.userCreatedMarker != nil && self.userCreatedMarker.map == nil) {
        self.userCreatedMarker.map = self.mapView;
        self.mapView.selectedMarker = self.userCreatedMarker;
        //fix for center the camera on new marker added
        GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:self.userCreatedMarker.position];
        [self.mapView animateWithCameraUpdate:cameraUpdate];
    }
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    UIView *infoView = [UIView new];
    infoView.frame = CGRectMake(0, 0, 200, 70);;
    infoView.backgroundColor = [UIColor greenColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(14, 11, 175, 16);
    [infoView addSubview:titleLabel];
    titleLabel.text = marker.title;
    
    UILabel *snippetLabel = [UILabel new];
    snippetLabel.frame = CGRectMake(14, 42, 175, 16);
    [infoView addSubview:snippetLabel];
    snippetLabel.text = marker.snippet;
    
    return infoView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    NSLog(@"marker %@ tapped", marker.title);
}

//displaying other type of marker subclassin a  gmsmarker OPTIONAL
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    //check if the marker exists before created to avoid repeated markers
    if (self.userCreatedMarker != nil) {
        
        //follow this order, first the map property second the object
        self.userCreatedMarker.map = nil;
        self.userCreatedMarker = nil;
    }
    
    __weak MapViewController *weakSelf = self;
    GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
    [geoCoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError * error) {
        CSMarker *marker = [CSMarker new];
        marker.position = coordinate;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = nil;
        marker.title = response.firstResult.thoroughfare;
        marker.snippet = response.firstResult.locality;
        weakSelf.userCreatedMarker = marker;
        [weakSelf drawMarkers];

    }];
}

//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//    
//    //check if my location is setted
//    if (mapView.myLocation != nil) {
//        
//    }
//    
//}













- (void)streetView {
    
    //CLLocationCoordinate2D panoramaNear = {50.059139,-122.958391};
    CLLocationCoordinate2D panoramaNear = {37.900370,-122.183667};

    
    GMSPanoramaView *panoView =
    [GMSPanoramaView panoramaWithFrame:CGRectZero
                        nearCoordinate:panoramaNear];
    
    self.view = panoView;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];

}

- (void)putCameraOnMapPosition {
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    
    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
    // kGMSTypeTerrain, kGMSTypeNone
    
    // Set the mapType to Satellite
    _mapView.mapType = kGMSTypeSatellite;
    
    self.view = _mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.map = _mapView;
}




- (void)polyline {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:-165
                                                                 zoom:2];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:-33.866 longitude:151.195]; // Sydney
    [path addLatitude:-18.142 longitude:178.431]; // Fiji
    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;
    
    self.view = mapView;
}

- (void)camera {
    
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:-37.809487
                                longitude:144.965699
                                     zoom:17.5
                                  bearing:30
                             viewingAngle:40];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
}

- (void)indoor {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.78318
                                                            longitude:-122.40374
                                                                 zoom:18];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
