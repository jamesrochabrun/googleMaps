//
//  StreetViewController.m
//  GoogleMapsStockCode
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "StreetViewController.h"

@interface StreetViewController ()
@property (nonatomic, strong) UIButton *button;

@end

@implementation StreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    GMSPanoramaService *service = [GMSPanoramaService new];
    [service requestPanoramaNearCoordinate:self.activeMarkerCoordinate callback:^(GMSPanorama * _Nullable panorama, NSError * _Nullable error) {
        
        if (panorama !=  nil) {
            
            GMSPanoramaCamera *camera = [GMSPanoramaCamera cameraWithHeading:180
                                                                       pitch:0
                                                                        zoom:1
                                                                         FOV:90];
            GMSPanoramaView *panoView = [GMSPanoramaView new];
            panoView.camera = camera;
            panoView.panorama = panorama;
            self.view = panoView;
            
            _button = [UIButton new];
            _button.backgroundColor = [UIColor blackColor];
            [_button setTitle:@"dismiss" forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_button];
            
        } else {
            
            [self dismissView];
        }
     
    }];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    CGRect frame = _button.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height *2;
    _button.frame = frame;
    
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
