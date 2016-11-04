//
//  DirectionsVC.m
//  GoogleMapsStockCode
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DirectionsVC.h"

@interface DirectionsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation DirectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableview = [UITableView new];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor blackColor];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    
    _dismissButton = [UIButton new];
    _dismissButton.backgroundColor = [UIColor blackColor];
    [_dismissButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dismissButton];
}

- (void)dismissView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    _tableview.frame = self.view.bounds;
    
    CGRect frame = _dismissButton.frame;
    frame.size.width = 200;
    frame.size.height = 50;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) /2;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height *2;
    _dismissButton.frame = frame;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *stepDict = [self.steps objectAtIndex:indexPath.row];
    NSString *direction = [stepDict valueForKey:@"html_instructions"];
    cell.textLabel.text = direction;

    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.steps.count;
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
