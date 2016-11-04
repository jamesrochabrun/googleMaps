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
#import "DirectionsVC.h"
#import "StreetViewController.h"

@interface MapViewController ()<GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (copy, nonatomic) NSSet *markers;
@property (strong, nonatomic) CSMarker *userCreatedMarker;
@property (nonatomic, strong) NSArray *steps;
@property (nonatomic, strong) UIButton *directionsButton;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *streetButton;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, assign) CLLocationCoordinate2D activeMarkerCoordinate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //codeSchool
   // [self putCameraOnMapPosition];
    //[self polyline];
   // [self camera];
   // [self indoor];

    [self loadMap];
    
    _loadButton = [UIButton new];
    _loadButton = [UIButton new];
    [_loadButton setTitle:@"Load" forState:UIControlStateNormal];
    [_loadButton addTarget:self action:@selector(drawMarkers:)  forControlEvents:UIControlEventTouchUpInside];
    _loadButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_loadButton];
    
    _directionsButton = [UIButton new];
    [_directionsButton setTitle:@"Get Directions" forState:UIControlStateNormal];
    [_directionsButton addTarget:self action:@selector(showDirections:)forControlEvents:UIControlEventTouchUpInside];
    _directionsButton.backgroundColor = [UIColor blackColor];
    _directionsButton.alpha = 0.0;
    [self.view addSubview:_directionsButton];
    
    _streetButton = [UIButton new];
    [_streetButton setTitle:@"show Street mode" forState:UIControlStateNormal];
    [_streetButton addTarget:self action:@selector(goToStreetView:)forControlEvents:UIControlEventTouchUpInside];
    _streetButton.backgroundColor = [UIColor blackColor];
    _streetButton.alpha = 0.0;
    [self.view addSubview:_streetButton];

}

//code school
//step 1 create a camera and a mapview
- (void)loadMap {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 37.773972
                                                            longitude:-122.431297
                                                                 zoom:15
                                                              bearing:0//rotation
                                                         viewingAngle:0];
    
    
//    CGRect frame = CGRectMake(0, (self.view.frame.size.height - 300) /2, self.view.frame.size.width, 300);
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
   // self.mapView.mapType = kGMSTypeSatellite;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:10 maxZoom:18];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    // marker.icon = [UIImage imageNamed:@"flag_icon"];
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = _mapView;
//
    self.view = _mapView;
   // [self.view addSubview:_mapView];
    [self setupMarkerData];
}


//step 2 set up markers
- (void)setupMarkerData {
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(37.900000, -122.431297);
    // marker.title = @"uno";
    marker.map = nil;
    
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(37.773990, -122.431297);
    // marker1.title = @"dos";
    marker1.map = nil;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(37.974030,-122.431297);
    //  marker2.title = @"tres";
    marker2.map = nil;
    
    self.markers = [NSSet setWithObjects:marker, marker1, marker2, nil];
}

//step 3 display markers in map
- (void)drawMarkers:(id)sender {
    
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


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showDirections:(UIButton *)sender {
    
    DirectionsVC *directionsVC = [DirectionsVC new];
    directionsVC.steps = self.steps;
    [self presentViewController:directionsVC animated:YES completion:^{
        self.steps = nil;
        self.mapView.selectedMarker = nil;
        self.directionsButton.alpha = 0.0;
        self.streetButton.alpha = 0.0;
    }];
    
}

- (void)goToStreetView:(id)sender {
    
    StreetViewController *streetVC = [StreetViewController new];
    streetVC.activeMarkerCoordinate = self.activeMarkerCoordinate;
    [self presentViewController:streetVC animated:YES completion:^{
        self.streetButton.alpha = 0.0;
        self.directionsButton.alpha = 0.0;
        self.mapView.selectedMarker = nil;
    }];
    
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
    self.polyline.map = nil;
    self.polyline = nil;
    
    __weak MapViewController *weakSelf = self;
    GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
    [geoCoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError * error) {
        CSMarker *marker = [CSMarker new];
        marker.position = coordinate;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = nil;
        marker.title = response.firstResult.thoroughfare;//street address
        marker.snippet = response.firstResult.locality;
        weakSelf.userCreatedMarker = marker;
        [weakSelf drawMarkers:mapView];

    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length +5, 0, self.bottomLayoutGuide.length + 5, 0);
    
    CGRect frame = _loadButton.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y = 40;
    _loadButton.frame = frame;
    
    frame = _directionsButton.frame;
    frame.size.width = 200;
    frame.size.height = 50;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height *2;
    _directionsButton.frame = frame;
    
    frame = _streetButton.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y = CGRectGetMinY(_directionsButton.frame) - frame.size.height *2;
    _streetButton.frame = frame;
    
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    self.activeMarkerCoordinate = marker.position;
    //check if my location is setted
    if (mapView.myLocation != nil) {
        //1) create a nsurl based on the directions API
        NSString *baseURL = @"https://maps.googleapis.com/maps/api/directions/json?";
        //required parameters
        NSString *startLocation = [NSString stringWithFormat:@"%f,%f",mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude];
        NSString *endLocation = [NSString stringWithFormat:@"%f,%f",marker.position.latitude, marker.position.longitude];
        NSString *browserAPIKEY = @"AIzaSyBK2neKROEYl_9rXXrOsFq_iwRE73shxWs";
        
        NSString *urlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&key=%@", baseURL, startLocation, endLocation,browserAPIKEY];
        
        
        NSLog(@"%@", urlString);
        //2) make a network request
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sharedSession];
        __weak MapViewController *weakSelf = self;
        self.polyline.map = nil;
        self.polyline = nil;
        
        NSURLSessionDataTask *directionsTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //3) parse json response

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (!error) {
                weakSelf.steps = json[@"routes"][0][@"legs"][0][@"steps"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.directionsButton.alpha = 1.0;
                    weakSelf.streetButton.alpha = 1.0;
                    //polyline
                    GMSPath *path = [GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
                    weakSelf.polyline = [GMSPolyline polylineWithPath:path];
                    weakSelf.polyline.strokeColor = [UIColor lightGrayColor];
                    weakSelf.polyline.strokeWidth = 2.0f;
                    weakSelf.polyline.map = weakSelf.mapView;

                });
                
               // NSArray *test = [json valueForKeyPath:@"routes.legs.steps.html_instructions"];
                NSLog(@"steps.count %lu", weakSelf.steps.count);
            }
        }];
        [directionsTask resume];
    }
    return YES;
}


//hide button
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.directionsButton.alpha > 0.0) {
        self.directionsButton.alpha = 0.0;
    }
    if (self.streetButton.alpha > 0.0) {
        self.streetButton.alpha = 0.0;
    }
    self.polyline.map = nil;
    self.polyline = nil;
}



- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    
    if (self.directionsButton.alpha > 0.0) {
        self.directionsButton.alpha = 0.0;
    }
    if (self.streetButton.alpha > 0.0) {
        self.streetButton.alpha = 0.0;
    }
    self.mapView.selectedMarker = nil;
    self.polyline.map = nil;
    self.polyline = nil;
}












































//
//- (void)streetView {
//    
//    //CLLocationCoordinate2D panoramaNear = {50.059139,-122.958391};
//    CLLocationCoordinate2D panoramaNear = {37.900370,-122.183667};
//
//    
//    GMSPanoramaView *panoView =
//    [GMSPanoramaView panoramaWithFrame:CGRectZero
//                        nearCoordinate:panoramaNear];
//    
//    self.view = panoView;
//}

//
//- (void)putCameraOnMapPosition {
//    
//    // Create a GMSCameraPosition that tells the map to display the
//    // coordinate -33.86,151.20 at zoom level 6.
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                            longitude:151.20
//                                                                 zoom:6];
//    
//    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    _mapView.myLocationEnabled = YES;
//    
//    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
//    // kGMSTypeTerrain, kGMSTypeNone
//    
//    // Set the mapType to Satellite
//    _mapView.mapType = kGMSTypeSatellite;
//    
//    self.view = _mapView;
//    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
//    marker.map = _mapView;
//}




//- (void)polyline {
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
//                                                            longitude:-165
//                                                                 zoom:2];
//    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    
//    GMSMutablePath *path = [GMSMutablePath path];
//    [path addLatitude:-33.866 longitude:151.195]; // Sydney
//    [path addLatitude:-18.142 longitude:178.431]; // Fiji
//    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
//    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
//    
//    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//    polyline.strokeColor = [UIColor blueColor];
//    polyline.strokeWidth = 5.f;
//    polyline.map = mapView;
//    
//    self.view = mapView;
//}

//- (void)camera {
//    
//    GMSCameraPosition *camera =
//    [GMSCameraPosition cameraWithLatitude:-37.809487
//                                longitude:144.965699
//                                     zoom:17.5
//                                  bearing:30
//                             viewingAngle:40];
//    
//    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    self.view = mapView;
//}
//
//- (void)indoor {
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.78318
//                                                            longitude:-122.40374
//                                                                 zoom:18];
//    
//    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    self.view = mapView;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
